with ad_group_report as (

    select *
    from {{ var('ad_group_report') }}
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
        ad_group_report.date_day,
        organization.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        ad_group.ad_group_id,
        ad_group.ad_group_name,
        ad_group_report.currency,
        ad_group_report.taps,
        ad_group_report.new_downloads,
        ad_group_report.redownloads,
        (ad_group_report.new_downloads + ad_group_report.redownloads) as total_downloads,
        ad_group_report.impressions,
        ad_group_report.spend
    from ad_group_report
    join ad_group 
        on ad_group_report.ad_group_id = ad_group.ad_group_id
    join campaign 
        on ad_group.campaign_id = campaign.campaign_id
    join organization 
        on ad_group.organization_id = organization.organization_id
)

select * 
from joined
