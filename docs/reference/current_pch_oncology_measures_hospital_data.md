# Get Current PCH Oncology Measures Data.

Get the current PCH Oncology Measures data.

## Usage

``` r
current_pch_oncology_measures_hospital_data(.data)
```

## Arguments

- .data:

  The data that results from the
  [`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)
  function.

## Value

Gets the current PCH Oncology Measures Hospital data from the current
hospital data file.

## Details

This function will obtain the current PCH Oncology Measures data from
the output of the
[`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)
function, that is the required input for the `.data` parameter. This
function only returns a single object.

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
[`current_oqr_oas_cahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_oqr_oas_cahps_data.md),
[`current_outpatient_imaging_efficiency_data()`](https://www.spsanderson.com/healthyR.data/reference/current_outpatient_imaging_efficiency_data.md),
[`current_payments_data()`](https://www.spsanderson.com/healthyR.data/reference/current_payments_data.md),
[`current_pch_hai_hospital_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_hai_hospital_data.md),
[`current_pch_hcahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_hcahps_data.md),
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
  current_pch_oncology_measures_hospital_data()
} # }
```
