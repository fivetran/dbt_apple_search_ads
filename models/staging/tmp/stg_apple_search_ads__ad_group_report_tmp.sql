{{ config(enabled=var('ad_reporting__apple_search_ads_enabled', True)) }}

{% if var('apple_search_ads_union_schemas', []) | length > 0 or var('apple_search_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='ad_group_report', 
        database_variable='apple_search_ads_database', 
        schema_variable='apple_search_ads_schema', 
        default_database=target.database,
        default_schema='apple_search_ads',
        default_variable='ad_group_report',
        union_schema_variable='apple_search_ads_union_schemas',
        union_database_variable='apple_search_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='apple_search_ads_sources',
        single_source_name='apple_search_ads',
        single_table_name='ad_group_report'
    )
}}

{% endif %}