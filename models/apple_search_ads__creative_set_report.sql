with creative_set_report as (
    select *
    from {{ var('creative_set_report') }}
), ad_group as (
    select * 
    from {{ ref('int_apple_search_ads__most_recent_ad_group') }}
), campaign as (
    select *
    from {{ ref('int_apple_search_ads__most_recent_campaign') }}
), organization as (
    select * 
    from {{ var('organization') }}
), joined as (
    select 
        organization.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        ad_group.ad_group_id,
        ad_group.ad_group_name,
        creative_set_report.creative_set_name,
        creative_set_report.creative_set_id,
        creative_set_report.created_at,
        creative_set_report.display_status,
        creative_set_report.date_day,
        creative_set_report.taps,
        creative_set_report.new_downloads,
        creative_set_report.redownloads,
        creative_set_report.impressions,
        creative_set_report.local_spend_amount as spend,
        creative_set_report.local_spend_currency as currency
    from creative_set_report
    join ad_group on creative_set_report.ad_group_id = ad_group.ad_group_id
    join campaign on ad_group.campaign_id = campaign.campaign_id
    join organization on ad_group.organization_id = organization.organization_id
)

select * from joined
