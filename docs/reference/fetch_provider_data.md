# Fetch Provider Data as Tibble or Download CSV

This function retrieves provider data from the provided link and returns
it as a tibble with cleaned names or downloads the data as a CSV file if
the link ends in .csv. This function is intended to be used with the CMS
provider data API.

## Usage

``` r
fetch_provider_data(.data_link, .limit = 500)
```

## Arguments

- .data_link:

  A character string containing the URL to fetch data from.

- .limit:

  An integer specifying the maximum number of rows to fetch. Default
  is 500. If set to 0, all records will be returned.

## Value

A tibble containing the fetched data with cleaned names, or downloads a
CSV file to the user-selected directory. If an error occurs, returns
`NULL`.

## Details

The function sends a request to the provided URL using
[`httr2::request`](https://httr2.r-lib.org/reference/request.html) and
[`httr2::req_perform`](https://httr2.r-lib.org/reference/req_perform.html).
If the response status is not 200, it stops with an error message
indicating the failure. If the URL ends in .csv, it uses
[`utils::download.file`](https://rdrr.io/r/utils/download.file.html) to
download the CSV file to a directory chosen by the user. Otherwise, the
response body is parsed as JSON and converted into a tibble using
[`dplyr::as_tibble`](https://tibble.tidyverse.org/reference/as_tibble.html).
The column names are cleaned using
[`janitor::clean_names`](https://sfirke.github.io/janitor/reference/clean_names.html),
and any character columns are stripped of leading and trailing
whitespace using
[`stringr::str_squish`](https://stringr.tidyverse.org/reference/str_trim.html).
The default limit for a return on records is 500. If the limit is set to
0, all records will be returned.

## See also

[`get_provider_meta_data`](https://www.spsanderson.com/healthyR.data/reference/get_provider_meta_data.md)

## Examples

``` r
library(dplyr)

# Example usage:
data_url <- "069d-826b"

df_tbl <- fetch_provider_data(data_url, .limit = 1)

df_tbl |>
 glimpse()
#> Rows: 1
#> Columns: 15
#> $ zip_code                                             <chr> "00210"
#> $ min_medicare_pricing_for_new_patient                 <chr> "57.752"
#> $ max_medicare_pricing_for_new_patient                 <chr> "174.264"
#> $ mode_medicare_pricing_for_new_patient                <chr> "132.096"
#> $ min_copay_for_new_patient                            <chr> "14.438"
#> $ max_copay_for_new_patient                            <chr> "43.566"
#> $ mode_copay_for_new_patient                           <chr> "33.024"
#> $ most_utilized_procedure_code_for_new_patient         <chr> "99204"
#> $ min_medicare_pricing_for_established_patient         <chr> "18.704"
#> $ max_medicare_pricing_for_established_patient         <chr> "142.152"
#> $ mode_medicare_pricing_for_established_patient        <chr> "71.856"
#> $ min_copay_for_established_patient                    <chr> "4.676"
#> $ max_copay_for_established_patient                    <chr> "35.538"
#> $ mode_copay_for_established_patient                   <chr> "17.964"
#> $ most_utilized_procedure_code_for_established_patient <chr> "99213"
```
