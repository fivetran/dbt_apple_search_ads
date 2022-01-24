with campaign_report as (
    
    select *
    from {{ var('campaign_report') }}

), campaign as (

    select *
    from {{ ref('int_apple_search_ads__most_recent_campaign') }}

), organization as (

    select * 
    from {{ var('organization') }}

), joined as (

    select 
        campaign_report.date_day,
        campaign.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        campaign_report.currency,
        campaign_report.taps,
        campaign_report.new_downloads,
        campaign_report.redownloads,
        (campaign_report.new_downloads + campaign_report.redownloads) as total_downloads,
        campaign_report.impressions,
        campaign_report.spend
    from campaign_report
    join campaign 
        on campaign_report.campaign_id = campaign.campaign_id
    join organization 
        on campaign.organization_id = organization.organization_id

)

select * 
from joined