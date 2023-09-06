# dbt_apple_search_ads v0.3.0
[PR #20](https://github.com/fivetran/dbt_apple_search_ads/pull/20) includes the following updates:
## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple apple_search_ads connectors. Refer to the [README](https://github.com/fivetran/dbt_apple_search_ads/blob/main/README.md) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
- Updated tests to account for the new `source_relation` column.
    - The `source_relation` column is included in all joins in the transform package. 

# dbt_apple_search_ads v0.2.2
## Bugfix:
- Updated the dbt_utils.unique_combination_of_columns test for the `apple_search_ads__search_term_report` to include the following fields. ([PR #18](https://github.com/fivetran/dbt_apple_search_ads/pull/18)):
        - date_day
        - search_term_text
        - keyword_id
        - ad_group_id
        - campaign_id
        - organization_id
        - match_type

## Under the Hood:

- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([PR #15](https://github.com/fivetran/dbt_apple_search_ads/pull/15))
- Updated the pull request [templates](/.github). ([PR #15](https://github.com/fivetran/dbt_apple_search_ads/pull/15))

## Contributors:

- [@yuna-tang](https://github.com/yuna-tang) ([PR #17](https://github.com/fivetran/dbt_apple_search_ads/pull/17))



# dbt_apple_search_ads v0.2.1

Accidental Release

# dbt_apple_search_ads v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #14](https://github.com/fivetran/dbt_apple_search_ads/pull/14) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `packages.yml` has been updated to reflect new default `fivetran/fivetran_utils` version, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_apple_search_ads v0.1.0

## Initial Release
- This is the initial release of this package. For more information refer to the [README](/README.md).
