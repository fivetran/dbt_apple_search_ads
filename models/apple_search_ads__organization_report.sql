{{ config(enabled=var('ad_reporting__apple_search_ads_enabled', True)) }}

with report as (
    
    select *
    from {{ var('campaign_report') }}
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
        organization.currency,
        sum(report.taps) as taps,
        sum(report.new_downloads) as new_downloads,
        sum(report.redownloads) as redownloads,
        sum(report.new_downloads + report.redownloads) as total_downloads,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='apple_search_ads__campaign_passthrough_metrics', transform = 'sum') }}
    from report
    join campaign 
        on report.campaign_id = campaign.campaign_id
    join organization 
        on campaign.organization_id = organization.organization_id
    {{ dbt_utils.group_by(4) }}
)

select * 
from joined