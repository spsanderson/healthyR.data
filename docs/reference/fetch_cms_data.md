# Fetch Data as Tibble

This function retrieves data from the provided link and returns it as a
tibble with cleaned names. This function is intended to be used with the
CMS data API function
[`get_cms_meta_data`](https://www.spsanderson.com/healthyR.data/reference/get_cms_meta_data.md).

## Usage

``` r
fetch_cms_data(.data_link)
```

## Arguments

- .data_link:

  A character string containing the URL to fetch data from.

## Value

A tibble containing the fetched data with cleaned names. If an error
occurs, returns `NULL`.

## Details

The function sends a request to the provided URL using
[`httr2::request`](https://httr2.r-lib.org/reference/request.html) and
[`httr2::req_perform`](https://httr2.r-lib.org/reference/req_perform.html).
If the response status is not 200, it stops with an error message
indicating the failure. The response body is parsed as JSON and
converted into a tibble using
[`dplyr::as_tibble`](https://tibble.tidyverse.org/reference/as_tibble.html).
The column names are cleaned using
[`janitor::clean_names`](https://sfirke.github.io/janitor/reference/clean_names.html),
and any character columns are stripped of leading and trailing
whitespace using
[`stringr::str_squish`](https://stringr.tidyverse.org/reference/str_trim.html).

## See also

[`get_cms_meta_data`](https://www.spsanderson.com/healthyR.data/reference/get_cms_meta_data.md)

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

# Example usage:
base_url <- "https://data.cms.gov/data-api/v1/dataset/"
data_identifier <- "9767cb68-8ea9-4f0b-8179-9431abc89f11"
data_url <- paste0(base_url, data_identifier, "/data")

df_tbl <- fetch_cms_data(data_url)

df_tbl |>
 head(1) |>
 glimpse()
#> Rows: 1
#> Columns: 30
#> $ aco_id                       <chr> "A2811"
#> $ par_lbn                      <chr> "ARIZONA COMMUNITY PHYSICIANS PC"
#> $ aco_name                     <chr> "Abacus Health LLC"
#> $ aco_service_area             <chr> "AZ"
#> $ agreement_period_num         <chr> "3"
#> $ initial_start_date           <chr> "1/1/2016"
#> $ current_start_date           <chr> "1/1/2024"
#> $ re_entering_aco              <chr> "0"
#> $ basic_track                  <chr> "0"
#> $ basic_track_level            <chr> ""
#> $ enhanced_track               <chr> "1"
#> $ high_revenue_aco             <chr> "0"
#> $ low_revenue_aco              <chr> "1"
#> $ adv_pay                      <chr> "0"
#> $ aim                          <chr> "0"
#> $ aip                          <chr> "0"
#> $ snf_3_day_rule_waiver        <chr> "0"
#> $ prospective_assignment       <chr> "0"
#> $ retrospective_assignment     <chr> "1"
#> $ aco_address                  <chr> "5055 East Broadway Blvd., Suite A-215, T…
#> $ aco_public_reporting_website <chr> "https://www.abacushealthaco.com/en/publi…
#> $ aco_exec_name                <chr> "Jim Stelzer"
#> $ aco_exec_email               <chr> "jstelzer@azacp.com"
#> $ aco_exec_phone               <chr> "(520) 547-4918"
#> $ aco_public_name              <chr> "Kimberly Clifton"
#> $ aco_public_email             <chr> "kclifton@azacp.com"
#> $ aco_public_phone             <chr> "(520) 545-1192"
#> $ aco_compliance_contact_name  <chr> "Tracy Rohn"
#> $ aco_medical_director_name    <chr> "Melissa Levine"
#> $ pc_flex_agreement_status     <chr> "0"
```
