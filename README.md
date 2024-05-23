
<!-- README.md is generated from README.Rmd. Please edit that file -->

# healthyR.data <img src="man/figures/logo.png" width="147" height="170" align="right" />

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/healthyR.data)](https://cran.r-project.org/package=healthyR.data)
![](http://cranlogs.r-pkg.org/badges/healthyR.data?color=brightgreen)
![](http://cranlogs.r-pkg.org/badges/grand-total/healthyR.data?color=brightgreen)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html##stable)
[![PRs
Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com)
<!-- badges: end -->

The goal of the { healthyR.data } package is to provide a simple yet
feature rich administrative data-set allowing for the testing of
functions inside of the { healthyR } package. It can be used to test its
functions or any function you create.

## Installation

You can install the released version of healthyR.data from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("healthyR.data")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("spsanderson/healthyR.data")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(healthyR.data)
library(dplyr)

df <- healthyR_data

glimpse(df)
#> Rows: 187,721
#> Columns: 17
#> $ mrn                      <chr> "86069614", "60856527", "80673110", "55897373…
#> $ visit_id                 <chr> "3519249247", "3602225015", "3125290892", "38…
#> $ visit_start_date_time    <dttm> 2010-01-04 05:00:00, 2010-01-04 05:00:00, 20…
#> $ visit_end_date_time      <dttm> 2010-01-04, 2010-01-04, 2010-01-04, 2010-01-…
#> $ total_charge_amount      <dbl> 25983.88, 22774.05, 10690.45, 8788.02, 7325.1…
#> $ total_amount_due         <dbl> 0.00, 0.00, 0.00, 0.00, 0.00, 201.52, 20.00, …
#> $ total_adjustment_amount  <dbl> -20799.61, -12978.37, -7596.09, -7663.57, -60…
#> $ payer_grouping           <chr> "Medicare B", "Medicare HMO", "HMO", "Medicar…
#> $ total_payment_amount     <dbl> -5184.27, -9795.68, -3094.36, -1124.45, -1269…
#> $ ip_op_flag               <chr> "O", "O", "O", "O", "O", "O", "O", "O", "O", …
#> $ service_line             <chr> "General Outpatient", "General Outpatient", "…
#> $ length_of_stay           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ expected_length_of_stay  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ length_of_stay_threshold <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ los_outlier_flag         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ readmit_flag             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ readmit_expectation      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```

``` r

df %>% 
    count(ip_op_flag, service_line) %>%
    arrange(ip_op_flag, desc(n)) %>%
    rename(count = n)
#> # A tibble: 30 × 3
#>    ip_op_flag service_line                                 count
#>    <chr>      <chr>                                        <int>
#>  1 I          Medical                                      64435
#>  2 I          Surgical                                     14916
#>  3 I          COPD                                          4398
#>  4 I          CHF                                           3871
#>  5 I          Pneumonia                                     3323
#>  6 I          Cellulitis                                    3311
#>  7 I          Major Depression/Bipolar Affective Disorders  2866
#>  8 I          Chest Pain                                    2766
#>  9 I          GI Hemorrhage                                 2404
#> 10 I          MI                                            2253
#> # ℹ 20 more rows
```
