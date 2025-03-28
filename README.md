# Apple Search Ads Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_apple_search_ads/))
<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_apple_search_ads/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

## What does this dbt package do?
- Produces modeled tables that leverage Apple Search Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/apple-search-ads) in the format described by [this ERD](https://fivetran.com/docs/applications/apple-search-ads#schemainformation) and builds off the output of our [Apple Search Ads source package](https://github.com/fivetran/dbt_apple_search_ads_source).
- Enables you to better understand the performance of your ads across varying grains:
    - Providing an organization, campaign, ad group, keyword, search term and ad level reports.
- Materializes output models designed to work simultaneously with our [multi-platform Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting).
- Generates a comprehensive data dictionary of your source and modeled Apple Search Ads data through the [dbt docs site](https://fivetran.github.io/dbt_apple_search_ads/).

<!--section="apple_search_ads_transformation_model"-->
The following table provides a detailed list of all tables materialized within this package by default.

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [apple_search_ads__organization_report](https://fivetran.github.io/dbt_apple_search_ads/#!/model/model.apple_search_ads.apple_search_ads__organization_report)             | Each record in this table represents the daily performance at the organization level. |
| [apple_search_ads__campaign_report](https://fivetran.github.io/dbt_apple_search_ads/#!/model/model.apple_search_ads.apple_search_ads__campaign_report)            | Each record in this table represents the daily performance of a campaign at the campaign/advertising_channel/advertising_channel_subtype level. |
| [apple_search_ads__ad_group_report](https://fivetran.github.io/dbt_apple_search_ads/#!/model/model.apple_search_ads.apple_search_ads__ad_group_report)            | Each record in this table represents the daily performance at the ad group level. |
| [apple_search_ads__ad_report](https://fivetran.github.io/dbt_apple_search_ads/#!/model/model.apple_search_ads.apple_search_ads__ad_report)            | Each record in this table represents the daily performance at the ad level. |
| [apple_search_ads__keyword_report](https://fivetran.github.io/dbt_apple_search_ads/#!/model/model.apple_search_ads.apple_search_ads__keyword_report)            | Each record in this table represents the daily performance at the ad group level for keywords. |
| [apple_search_ads__search_term_report](https://fivetran.github.io/dbt_apple_search_ads/#!/model/model.apple_search_ads.apple_search_ads__keyword_report)            | Each record in this table represents the daily performance at the ad group level for search term report. |

### Materialized Models
Each Quickstart transformation job run materializes 26 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Apple Search Ads connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if also using the `ad_reporting` combo package)
Include the following apple_search_ads package version in your `packages.yml` file _if_ you are not also using the upstream [Ad Reporting combination package](https://github.com/fivetran/dbt_ad_reporting):
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/apple_search_ads
    version: [">=0.5.0", "<0.6.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do NOT include the `apple_search_ads_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well.


### Step 3: Define database and schema variables
By default, this package runs using your destination and the `apple_search_ads` schema. If this is not where your Apple Search Ads data is (for example, if your Apple Search Ads schema is named `apple_search_ads_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    apple_search_ads_database: your_destination_name
    apple_search_ads_schema: your_schema_name 
```

### (Optional) Step 4: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Union multiple connections
If you have multiple apple_search_ads connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `apple_search_ads_union_schemas` OR `apple_search_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    apple_search_ads_union_schemas: ['apple_search_ads_usa','apple_search_ads_canada'] # use this if the data is in different schemas/datasets of the same database/project
    apple_search_ads_union_databases: ['apple_search_ads_usa','apple_search_ads_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Adding passthrough metrics
By default, this package will select `taps`, `impressions`, `spend` (aliased from source `local_spend_amount` field), `new_downloads`, `redownloads`, `total_downloads` (sum of `new_downloads` and `redownloads`), `conversions` (installs resulting from a view or a tap), `tap_new_downloads`, `tap_redownloads`, `tap_installs` (these last 3 fields are replacing `new_downloads`, `redownloads`, `conversions`, respectively, which will be deprecated in an upcoming release) from the source reporting tables to store into the staging models. If you would like to pass through additional metrics to the staging models, add the below configurations to your `dbt_project.yml` file. These variables allow for the pass-through fields to be aliased (`alias`) if desired, but not required. Use the below format for declaring the respective pass-through variables.

> NOTE: There is no direct `conversion_value` field available in Apple Search Ads data. See the [DECISIONLOG](https://github.com/fivetran/dbt_apple_search_ads/blob/main/DECISIONLOG.md#conversion-value) for more details on alternatives.

```yml
vars:
    apple_search_ads__ad_group_passthrough_metrics: 
      - name: "new_custom_field"
        alias: "custom_field"
      - name: "another_one"
    apple_search_ads__ad_passthrough_metrics:
      - name: "this_field"
    apple_search_ads__campaign_passthrough_metrics:
      - name: "unique_string_field"
        alias: "field_id"
    apple_search_ads__keyword_passthrough_metrics:
      - name: "that_field"
    apple_search_ads__search_term_passthrough_metrics:
      - name: "other_id"
        alias: "another_id"
```

> IMPORTANT: Make sure to exercise due diligence when adding metrics to these models. The metrics added by default have been vetted by the Fivetran team, maintaining this package for accuracy. There are metrics included within the source reports, such as metric averages, which may be inaccurately represented at the grain for reports created in this package. You must ensure that whichever metrics you pass through are appropriate to aggregate at the respective reporting levels in this package.

#### Disabling Additional Models
Your Apple Search Ads connection might not sync every table this package expects. If your syncs exclude certain tables, you either don't use that functionality in Apple Search Ads or actively exclude some tables from your syncs. You must add the relevant variables to disable the corresponding functionality in the package. By default, the package assumes that all variables are true. Add variables for only the tables you want to disable.

The `apple_search_ads__using_search_terms` variable below refers to the `search_terms_report` table. You must enable the [search match](https://searchads.apple.com/help/campaigns/0006-understand-search-match) function within each ad group to populate this table with data.

The `apple_search_ads__using_search_terms` variable below refers to the `search_terms_report` table. You must enable the [search match](https://searchads.apple.com/help/campaigns/0006-understand-search-match) function within each ad group to populate this table with data.

```yml
# dbt_project.yml
vars:
  apple_search_ads__using_search_terms: False # by default this is True
```

#### Change the build schema
By default, this package builds the Apple Search Ads staging models (10 views, 10 tables) within a schema titled (`<target_schema>` + `_apple_search_ads_source`) and your Apple Search Ads modeling models (6 tables) within a schema titled (`<target_schema>` + `_apple_search_ads`) in your destination. If this is not where you would like your Apple Search Ads data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    apple_search_ads_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    apple_search_ads:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_apple_search_ads/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    apple_search_ads_<default_source_table_name>_identifier: your_table_name 
```

</details>

### (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/apple_search_ads_source
      version: [">=0.5.0", "<0.6.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/apple_search_ads/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_apple_search_ads/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_apple_search_ads/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_apple_search_ads/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
