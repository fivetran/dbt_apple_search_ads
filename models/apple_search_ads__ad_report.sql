with report as (

    select *
    from {{ var('ad_report') }}
), 

ad as (

    select * 
    from {{ var('ad_history') }}
    where is_most_recent_record = True
), 

ad_group as (

    select * 
    from {{ var('ad_group_history') }}
    where is_most_recent_record = True
), 

campaign as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True
), 

organization as (

    select * 
    from {{ var('organization') }}
), 

joined as (

    select 
        report.date_day,
        organization.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        ad_group.ad_group_id,
        ad_group.ad_group_name,
        ad.ad_id,
        ad.ad_name,
        report.currency,
        sum(report.taps) as taps,
        sum(report.new_downloads) as new_downloads,
        sum(report.redownloads) as redownloads,
        sum(report.new_downloads + report.redownloads) as total_downloads,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend
        {% for metric in var('apple_search_ads__ad_passthrough_metrics',[]) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}
    from report
    join ad 
        on report.ad_id = ad.ad_id
    join ad_group 
        on report.ad_group_id = ad_group.ad_group_id
    join campaign 
        on report.campaign_id = campaign.campaign_id
    join organization 
        on ad.organization_id = organization.organization_id
    {{ dbt_utils.group_by(10) }}
)

select * 
from joined
