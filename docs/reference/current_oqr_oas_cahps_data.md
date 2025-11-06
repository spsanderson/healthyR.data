# Get Current OAS CAHPS Data.

Get the current OAS CAHPS data.

## Usage

``` r
current_oqr_oas_cahps_data(
  .data,
  .data_sets = c("Facility", "State", "National")
)
```

## Arguments

- .data:

  The data that results from the
  [`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)
  function.

- .data_sets:

  The default is: c("Claim","Facility","State","National"), which will
  bring back all of the data in the OAS CAHPS data sets that are in the
  file. You can choose from the following:

  - Facility

  - National

  - State

  You can also pass things like c("state","Nation") as behind the scenes
  only the OAS CAHPS data sets are available to the function to choose
  from and `grep` is used to find matches with `ignore.case = TRUE` set.

## Value

Gets the current OAS CAHPS data from the current hospital data file.

## Details

This function will obtain the current OAS CAHPS data from the output of
the
[`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)
function, that is the required input for the `.data` parameter. You can
pass in a list of which of those data sets you would like,

## See also

<https://data.cms.gov/provider-data/topics/hospitals/>

Other Hospital Data:
[`current_asc_data()`](https://www.spsanderson.com/healthyR.data/reference/current_asc_data.md),
[`current_asc_oas_cahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_asc_oas_cahps_data.md),
[`current_comp_death_data()`](https://www.spsanderson.com/healthyR.data/reference/current_comp_death_data.md),
[`current_hai_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hai_data.md),
[`current_hcahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hcahps_data.md),
[`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md),
[`current_hvbp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hvbp_data.md),
[`current_ipfqr_data()`](https://www.spsanderson.com/healthyR.data/reference/current_ipfqr_data.md),
[`current_maternal_data()`](https://www.spsanderson.com/healthyR.data/reference/current_maternal_data.md),
[`current_medicare_hospital_spending_data()`](https://www.spsanderson.com/healthyR.data/reference/current_medicare_hospital_spending_data.md),
[`current_outpatient_imaging_efficiency_data()`](https://www.spsanderson.com/healthyR.data/reference/current_outpatient_imaging_efficiency_data.md),
[`current_payments_data()`](https://www.spsanderson.com/healthyR.data/reference/current_payments_data.md),
[`current_pch_hai_hospital_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_hai_hospital_data.md),
[`current_pch_hcahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_hcahps_data.md),
[`current_pch_oncology_measures_hospital_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_oncology_measures_hospital_data.md),
[`current_pch_outcomes_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_outcomes_data.md),
[`current_timely_and_effective_care_data()`](https://www.spsanderson.com/healthyR.data/reference/current_timely_and_effective_care_data.md),
[`current_unplanned_hospital_visits_data`](https://www.spsanderson.com/healthyR.data/reference/current_unplanned_hospital_visits_data.md),
[`current_va_data()`](https://www.spsanderson.com/healthyR.data/reference/current_va_data.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
if (FALSE) { # \dontrun{
current_hosp_data() |>
  current_maternal_data(.data_sets = c("State","National"))
} # }
```
