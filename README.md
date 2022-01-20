[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Apple Search Ads (Source) 

This package models Apple Search Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/apple-search-ads). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/apple-search-ads/#schemainformation).

This package contains transformation models, designed to work simultaneously with our [Apple Search Ads source package](https://github.com/fivetran/dbt_apple_search_ads_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                    | **description**                                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| apple_search_ads__organization_report        | Each record represents the daily ad performance of each organization |
| apple_search_ads__campaign_report        | Each record represents the daily ad performance of each campaign |
| apple_search_ads__ad_group_report     | Each record represents the daily ad performance of each ad group |
| apple_search_ads__keyword_report    | Each record represents the daily ad performance of each keyword |
| apple_search_ads__search_term_report    | Each record represents the daily ad performance of each search term |
| apple_search_ads__creative_set_report    | Each record represents the daily ad performance of each creative set |