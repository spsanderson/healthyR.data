# Download Current Hospital Data Files.

Download the current Hospital Data Sets.

## Usage

``` r
current_hosp_data(path = utils::choose.dir())
```

## Arguments

- path:

  The location to download and unzip the files

## Value

Downloads the current hospital data sets.

## Details

This function will download the current and the official hospital data
sets from the **CMS.gov** website.

The function makes use of a temporary directory and file to save and
unzip the data. This will grab the current Hospital Data Files, unzip
them and return a list of tibbles with each tibble named after the data
file.

The function returns a list object with all of the current hospital data
as a tibble. It does not save the data anywhere so if you want to save
it you will have to do that manually.

This also means that you would have to store the data as a variable in
order to access the data later on. It does have a given attributes and a
class so that it can be piped into other functions.

## See also

<https://data.cms.gov/provider-data/topics/hospitals/>

Other Hospital Data:
[`current_asc_data()`](https://www.spsanderson.com/healthyR.data/reference/current_asc_data.md),
[`current_asc_oas_cahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_asc_oas_cahps_data.md),
[`current_comp_death_data()`](https://www.spsanderson.com/healthyR.data/reference/current_comp_death_data.md),
[`current_hai_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hai_data.md),
[`current_hcahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hcahps_data.md),
[`current_hvbp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hvbp_data.md),
[`current_ipfqr_data()`](https://www.spsanderson.com/healthyR.data/reference/current_ipfqr_data.md),
[`current_maternal_data()`](https://www.spsanderson.com/healthyR.data/reference/current_maternal_data.md),
[`current_medicare_hospital_spending_data()`](https://www.spsanderson.com/healthyR.data/reference/current_medicare_hospital_spending_data.md),
[`current_oqr_oas_cahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_oqr_oas_cahps_data.md),
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
  current_hosp_data()
} # }
```
