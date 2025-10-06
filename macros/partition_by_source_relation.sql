{%- macro partition_by_source_relation(has_other_partitions='yes', alias=None) -%}
    {%- set prefix = '' if alias is none else alias ~ '.' -%}

    {# Determine total number of union sources (schemas or databases, not both) #}
    {%- set num_sources =
        (var('apple_search_ads_union_schemas', []) | length)
        + (var('apple_search_ads_union_databases', []) | length)
    -%}

    {%- if has_other_partitions == 'no' -%}
        {{ 'partition by ' ~ prefix ~ 'source_relation' if num_sources > 1 }}
    {%- else -%}
        {{ ', ' ~ prefix ~ 'source_relation' if num_sources > 1 }}
    {%- endif -%}
{%- endmacro -%}
