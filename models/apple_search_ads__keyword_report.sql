{{ config(enabled=var('ad_reporting__apple_search_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('keyword_report') }}
), 

keyword as (

    select *
    from {{ var('keyword_history') }}
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
        keyword.keyword_id,
        keyword.keyword_text,
        keyword.match_type,
        report.currency,
        keyword.keyword_status,
        sum(report.taps) as taps,
        sum(report.new_downloads) as new_downloads,
        sum(report.redownloads) as redownloads,
        sum(report.new_downloads + report.redownloads) as total_downloads,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='apple_search_ads__keyword_passthrough_metrics', transform = 'sum') }}
    from report
    join keyword 
        on report.keyword_id = keyword.keyword_id
    join ad_group 
        on keyword.ad_group_id = ad_group.ad_group_id
    join campaign 
        on ad_group.campaign_id = campaign.campaign_id
    join organization 
        on ad_group.organization_id = organization.organization_id
    {{ dbt_utils.group_by(12) }}
)

select * 
from joined
