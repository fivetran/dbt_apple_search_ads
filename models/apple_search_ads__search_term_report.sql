{{ config(enabled=var('apple_search_ads__using_search_terms', True)) }}

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
        search_term_report.date_day,
        organization.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        search_term_report.ad_group_id,
        search_term_report.ad_group_name,
        search_term_report.search_term_text,
        search_term_report.currency,
        sum(search_term_report.taps) as taps,
        sum(search_term_report.new_downloads) as new_downloads,
        sum(search_term_report.redownloads) as redownloads,
        sum(search_term_report.new_downloads + search_term_report.redownloads) as total_downloads,
        sum(search_term_report.impressions) as impressions,
        sum(search_term_report.spend) as spend
    from search_term_report
    join campaign 
        on search_term_report.campaign_id = campaign.campaign_id
    join organization 
        on campaign.organization_id = organization.organization_id
    where search_term_report.search_term_text is not null
    {{ dbt_utils.group_by(9) }}

)

select * 
from joined