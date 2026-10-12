# Retrieve CMS Metadata Links from CMS

This function sends a request to the specified CMS data URL, retrieves
the JSON data, and processes it to create a tibble with relevant
information about the datasets.

## Usage

``` r
get_cms_meta_data(
  .title = NULL,
  .modified_date = NULL,
  .keyword = NULL,
  .identifier = NULL,
  .data_version = "current",
  .media_type = "all"
)
```

## Arguments

- .title:

  This can be a title that is used to search the data.

- .modified_date:

  This can be a date in the format of "YYYY-MM-DD"

- .keyword:

  This can be a keyword that is used to search the data.

- .identifier:

  This can be an identifier that is used to search the data.

- .data_version:

  This can be one of three different choices: "current", "archive", or
  "all". The default is "current" and if you make a choice that does not
  exist then it will default to "current".

- .media_type:

  This can be one of three different choices: "all", "csv", "API", or
  "other". The default is "all" and if you make a choice that does not
  exist then it will default to "all".

## Value

A tibble with data links and relevant metadata about the datasets.

## Details

The function fetches JSON data from the CMS data URL and extracts
relevant fields to create a tidy tibble. It selects specific columns,
handles nested lists by unnesting them, cleans column names, and
processes dates and media types to make the data more useful for
analysis. Dates use the CMS ISO format (YYYY-MM-DD). Missing or invalid
dates are returned as `NA`. Temporal values without an end date have an
`NA` end date; open interval endpoints are also returned as `NA`. The
columns in the returned tibble are:

- `title`

- `description`

- `landing_page`

- `modified`

- `keyword`

- `described_by`

- `fn`

- `has_email`

- `identifier`

- `start`

- `end`

- `references`

- `distribution_description`

- `distribution_title`

- `distribution_modified`

- `distribution_start`

- `distribution_end`

- `media_type`

- `data_link`

## See also

<https://data.cms.gov/data.json>

Other Meta Data:
[`get_provider_meta_data()`](https://www.spsanderson.com/healthyR.data/reference/get_provider_meta_data.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(dplyr)

# Fetch and process metadata from the CMS data URL
get_cms_meta_data(
  .keyword = "nation",
  .title = "Market Saturation & Utilization State-County"
) |>
  glimpse()
#> Rows: 1
#> Columns: 22
#> $ title                      <chr> "Market Saturation & Utilization State-Coun…
#> $ description                <chr> "The Market Saturation and Utilization Stat…
#> $ landing_page               <df[,3]> <data.frame[1 x 3]>
#> $ modified                   <date> 2026-06-10
#> $ keyword                    <list> <"National", "States & Territories", "Co…
#> $ described_by               <df[,4]> <data.frame[1 x 4]>
#> $ fn                         <chr> "Market Saturation - CPI"
#> $ has_email                  <chr> "MarketSaturation@cms.hhs.gov"
#> $ identifier                 <chr> "https://data.cms.gov/data-api/v1/dataset/…
#> $ start                      <date> NA
#> $ end                        <date> NA
#> $ references                 <chr> "https://data.cms.gov/resources/market-sat…
#> $ distribution_resources_api <chr> "https://data.cms.gov/data-api/v1/datase…
#> $ distribution_title         <chr> "Market Saturation & Utilization StateCount…
#> $ distribution_described_by  <df[,4]> <data.frame[1 x 4]>
#> $ distribution_modified      <date> 2026-06-10
#> $ distribution_start         <date> NA
#> $ distribution_end           <date> NA
#> $ distribution_license       <chr> "https://www.usa.gov/government-works"
#> $ distribution_description   <chr> "latest"
#> $ media_type                 <chr> "API"
#> $ data_link                  <chr> "https://data.cms.gov/data-api/v1/dataset/8…
```
