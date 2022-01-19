with search_term_report as (
    select *
    from {{ var('search_term_report') }}
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
        search_term_report.ad_group_id,
        search_term_report.ad_group_name,
        search_term_report.keyword_id,
        search_term_report.keyword_text,
        search_term_report.keyword_match_type,
        search_term_report.search_term_source,
        search_term_report.search_term_text,
        search_term_report.date_day,
        search_term_report.taps,
        search_term_report.new_downloads,
        search_term_report.redownloads,
        search_term_report.impressions,
        search_term_report.local_spend_amount as spend,
        search_term_report.local_spend_currency as currency
    from search_term_report
    join campaign on search_term_report.campaign_id = campaign.campaign_id
    join organization on campaign.organization_id = organization.organization_id
)

select * from joined