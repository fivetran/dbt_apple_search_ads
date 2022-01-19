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
        campaign.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        date_day,
        taps
        new_downloads,
        redownloads,
        impressions,
        local_spend_amount as spend,
        local_spend_currency as currency
    from campaign_report
    join campaign on campaign_report.campaign_id = campaign.campaign_id
    join organization on campaign.organization_id = organization.organization_id
)

select * from joined