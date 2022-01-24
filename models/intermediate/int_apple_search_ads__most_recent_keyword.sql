with base as (
    select * 
    from {{ var('keyword_history') }}
), filtered as (
    select * 
    from base
    {% if target.type == 'snowflake' -%} --
        where is_most_recent_record = 'true' --
    {% else -%} --
        where is_most_recent_record is true --
    {% endif %} --
)

select * from filtered