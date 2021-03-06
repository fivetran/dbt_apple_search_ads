with keyword_report as (

    select *
    from {{ var('keyword_report') }}

), keyword as (

    select *
    from {{ ref('int_apple_search_ads__most_recent_keyword') }}

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
        keyword_report.date_day,
        organization.organization_id,
        organization.organization_name,
        campaign.campaign_id, 
        campaign.campaign_name, 
        ad_group.ad_group_id,
        ad_group.ad_group_name,
        keyword.keyword_id,
        keyword.keyword_text,
        keyword_report.currency,
        keyword_report.taps,
        keyword_report.new_downloads,
        keyword_report.redownloads,
        (keyword_report.new_downloads + keyword_report.redownloads) as total_downloads,
        keyword_report.impressions,
        keyword_report.spend
    from keyword_report
    join keyword 
        on keyword_report.keyword_id = keyword.keyword_id
    join ad_group 
        on keyword.ad_group_id = ad_group.ad_group_id
    join campaign 
        on ad_group.campaign_id = campaign.campaign_id
    join organization 
        on ad_group.organization_id = organization.organization_id

)

select * 
from joined
