{{ config(enabled=var('ad_reporting__apple_search_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_apple_search_ads__keyword_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_apple_search_ads__keyword_history_tmp')),
                staging_columns=get_keyword_history_columns()
            )
        }}
        
    
        {{ fivetran_utils.apply_source_relation(package_name='apple_search_ads') }}

    from base
),

final as (

    select
        source_relation, 
        modification_time as modified_at,
        campaign_id,
        ad_group_id,
        id as keyword_id,
        bid_amount, 
        bid_currency,
        match_type,
        status as keyword_status,
        text as keyword_text,
        row_number() over (partition by id {{ fivetran_utils.partition_by_source_relation(package_name='apple_search_ads') }} order by modification_time desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final