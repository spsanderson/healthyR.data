# Retrieve Provider Metadata from CMS

This function sends a request to the specified CMS metadata URL,
retrieves the JSON data, and processes it to create a tibble with
relevant information about the datasets.

## Usage

``` r
get_provider_meta_data(
  .identifier = NULL,
  .title = NULL,
  .description = NULL,
  .keyword = NULL,
  .issued = NULL,
  .modified = NULL,
  .released = NULL,
  .theme = NULL,
  .media_type = NULL
)
```

## Arguments

- .identifier:

  A dataset identifier to filter the data.

- .title:

  A title to filter the data.

- .description:

  A description to filter the data.

- .keyword:

  A keyword to filter the data.

- .issued:

  A date when the dataset was issued to filter the data.

- .modified:

  A date when the dataset was modified to filter the data.

- .released:

  A date when the dataset was released to filter the data.

- .theme:

  A theme to filter the data.

- .media_type:

  A media type to filter the data.

## Value

A tibble with metadata about the datasets.

## Details

The function fetches JSON data from the CMS metadata URL and extracts
relevant fields to create a tidy tibble. It selects specific columns,
handles nested lists by unnesting them, cleans column names, and
processes dates and media types to make the data more useful for
analysis. The columns in the returned tibble are:

- `identifier`

- `title`

- `description`

- `keyword`

- `issued`

- `modified`

- `released`

- `theme`

- `media_type`

- `download_url`

- `contact_fn`

- `contact_email`

- `publisher_name`

## See also

<https://data.cms.gov/provider-data/api/1/metastore/schemas/dataset/items>

Other Meta Data:
[`get_cms_meta_data()`](https://www.spsanderson.com/healthyR.data/reference/get_cms_meta_data.md)

## Examples

``` r
library(dplyr)

# Fetch and process metadata from the CMS data URL
get_provider_meta_data(.identifier = "3614-1eef") |>
  glimpse()
#> Rows: 1
#> Columns: 17
#> $ access_level     <chr> "public"
#> $ landing_page     <chr> "https://data.medicare.gov/provider-data/dataset/3614…
#> $ issued           <date> 2024-08-05
#> $ modified         <date> 2024-08-05
#> $ released         <date> 2024-08-08
#> $ next_update_date <chr> NA
#> $ keyword          <list> "Addiction Medicine"
#> $ identifier       <chr> "3614-1eef"
#> $ description      <chr> "Returns addiction medicine office visit costs per zi…
#> $ title            <chr> "Addiction Medicine Office Visit Costs"
#> $ theme            <list> "Physician office visit costs"
#> $ archive_exclude  <lgl> NA
#> $ contact_fn       <chr> "PPL Dataset"
#> $ contact_email    <chr> "PPL_Dataset@cms.hhs.gov"
#> $ publisher_name   <chr> "Centers for Medicare & Medicaid Services (CMS)"
#> $ download_url     <chr> "https://data.cms.gov/provider-data/sites/default/fi…
#> $ media_type       <chr> "text/csv"
```
