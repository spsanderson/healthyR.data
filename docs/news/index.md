# Changelog

## healthyR.data (development version)

## healthyR.data 1.2.0

CRAN release: 2025-01-13

### Breaking Changes

None

### New Functions

None

### Minor Fixes and Improvements

1.  \#116 Fix for httr2 from [@hadley](https://github.com/hadley)

## healthyR.data 1.1.1

CRAN release: 2024-07-04

### Breaking Changes

1.  Fix
    [\#111](https://github.com/spsanderson/healthyR.data/issues/111) -
    Requires R version 4.1.0 or higher.

### New Functions

1.  Fix
    [\#102](https://github.com/spsanderson/healthyR.data/issues/102) -
    Add function
    [`is_valid_url()`](https://www.spsanderson.com/healthyR.data/reference/is_valid_url.md)

### Minor Fixes and Improvements

1.  Fix
    [\#101](https://github.com/spsanderson/healthyR.data/issues/101) -
    Fixed
    [`fetch_cms_data()`](https://www.spsanderson.com/healthyR.data/reference/fetch_cms_data.md)
    to handle all types of data presented, not just API data. Now
    appropriately handles both API and non-API data such as, .csv,
    vnd.ms-excel and .zip files.
2.  Fix
    [\#103](https://github.com/spsanderson/healthyR.data/issues/103) -
    Added
    [`is_valid_url()`](https://www.spsanderson.com/healthyR.data/reference/is_valid_url.md)
    call to `fetch_` functions.
3.  Fix
    [\#107](https://github.com/spsanderson/healthyR.data/issues/107) -
    Add parameter of `.limit` to
    [`fetch_provider_data()`](https://www.spsanderson.com/healthyR.data/reference/fetch_provider_data.md)
    to limit the number of records returned via the API. Default is 500
    and 0 will return all records.

## healthyR.data 1.1.0

CRAN release: 2024-05-23

### Breaking Changes

None

### New Function

1.  Fix [\#77](https://github.com/spsanderson/healthyR.data/issues/77) -
    Add function
    [`get_cms_meta_data()`](https://www.spsanderson.com/healthyR.data/reference/get_cms_meta_data.md)
2.  Fix [\#82](https://github.com/spsanderson/healthyR.data/issues/82) -
    Add function
    [`get_provider_meta_data()`](https://www.spsanderson.com/healthyR.data/reference/get_provider_meta_data.md)
3.  Fix [\#89](https://github.com/spsanderson/healthyR.data/issues/89) -
    Add functions
    [`fetch_cms_data()`](https://www.spsanderson.com/healthyR.data/reference/fetch_cms_data.md),
    [`fetch_provider_data()`](https://www.spsanderson.com/healthyR.data/reference/fetch_provider_data.md)

### Minor Fixes and Improvements

1.  Fix [\#72](https://github.com/spsanderson/healthyR.data/issues/72) -
    Fix bug in directory file paths for
    [`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)

## healthyR.data 1.0.3

CRAN release: 2023-05-05

### Breaking Changes

1.  Require R version 3.4.0 in keeping with tidyverse practices.

### New Functions

1.  Fix [\#12](https://github.com/spsanderson/healthyR.data/issues/12) -
    Add function
    [`current_hosp_data_dict()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data_dict.md)
2.  Fix [\#10](https://github.com/spsanderson/healthyR.data/issues/10) -
    Add function
    [`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)
3.  Fix [\#22](https://github.com/spsanderson/healthyR.data/issues/22) -
    Add function
    [`current_asc_data()`](https://www.spsanderson.com/healthyR.data/reference/current_asc_data.md)
4.  Fix [\#28](https://github.com/spsanderson/healthyR.data/issues/28) -
    Add function
    [`current_asc_oas_cahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_asc_oas_cahps_data.md)
5.  Fix [\#31](https://github.com/spsanderson/healthyR.data/issues/31) -
    Add function
    [`current_comp_death_data()`](https://www.spsanderson.com/healthyR.data/reference/current_comp_death_data.md)
6.  Fix [\#33](https://github.com/spsanderson/healthyR.data/issues/33) -
    Confirm logic in
    [`current_hosp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hosp_data.md)
    ([@rjake](https://github.com/rjake))
7.  Fix [\#38](https://github.com/spsanderson/healthyR.data/issues/38) -
    Add function
    [`current_hai_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hai_data.md)
    8, Fix
    [\#39](https://github.com/spsanderson/healthyR.data/issues/39) - Add
    function
    [`current_hcahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hcahps_data.md)
8.  Fix [\#42](https://github.com/spsanderson/healthyR.data/issues/42) -
    Add function
    [`current_hvbp_data()`](https://www.spsanderson.com/healthyR.data/reference/current_hvbp_data.md)
9.  Fix [\#45](https://github.com/spsanderson/healthyR.data/issues/45) -
    Add function
    [`current_ipfqr_data()`](https://www.spsanderson.com/healthyR.data/reference/current_ipfqr_data.md)
10. Fix [\#47](https://github.com/spsanderson/healthyR.data/issues/47) -
    Add function
    [`current_maternal_data()`](https://www.spsanderson.com/healthyR.data/reference/current_maternal_data.md)
11. Fix [\#49](https://github.com/spsanderson/healthyR.data/issues/49) -
    Add function
    [`current_medicare_hospital_spending_data()`](https://www.spsanderson.com/healthyR.data/reference/current_medicare_hospital_spending_data.md)
12. Fix [\#51](https://github.com/spsanderson/healthyR.data/issues/51) -
    Add function `current_opqr_data()`
13. Fix [\#52](https://github.com/spsanderson/healthyR.data/issues/52) -
    Add function `current_imaging_efficiency_data()`
14. Fix [\#60](https://github.com/spsanderson/healthyR.data/issues/60) -
    Add function
    [`current_unplanned_hospital_visits_data()`](https://www.spsanderson.com/healthyR.data/reference/current_unplanned_hospital_visits_data.md)
15. Fix [\#53](https://github.com/spsanderson/healthyR.data/issues/53) -
    Add function
    [`current_payments_data()`](https://www.spsanderson.com/healthyR.data/reference/current_payments_data.md)
16. Fix [\#55](https://github.com/spsanderson/healthyR.data/issues/55) -
    Add function
    [`current_pch_hcahps_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_hcahps_data.md)
17. Fix [\#56](https://github.com/spsanderson/healthyR.data/issues/56) -
    Add function
    [`current_pch_hai_hospital_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_hai_hospital_data.md)
18. Fix [\#57](https://github.com/spsanderson/healthyR.data/issues/57) -
    Add function
    [`current_pch_oncology_measures_hospital_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_oncology_measures_hospital_data.md)
19. Fix [\#58](https://github.com/spsanderson/healthyR.data/issues/58) -
    Add function
    [`current_pch_outcomes_data()`](https://www.spsanderson.com/healthyR.data/reference/current_pch_outcomes_data.md)
20. Fix [\#59](https://github.com/spsanderson/healthyR.data/issues/59) -
    Add function
    [`current_timely_and_effective_care_data()`](https://www.spsanderson.com/healthyR.data/reference/current_timely_and_effective_care_data.md)
21. Fix \$65 - Add function
    [`current_va_data()`](https://www.spsanderson.com/healthyR.data/reference/current_va_data.md)

### Minor Fixes and Improvements

None

## healthyR.data 1.0.2

CRAN release: 2023-01-21

### Breaking Changes

None

### New Features

None

### Minor Fixes and Improvments

1.  Fix [\#8](https://github.com/spsanderson/healthyR.data/issues/8) -
    Drop need for `cli`, `crayon`, and `rstudioapi`

## healthyR.data 1.0.1

CRAN release: 2021-04-09

- The CRAN policy asks for minimal package size, which includes
  installed size. Add LazyDataCompression: xz to DESCRIPTION file per
  CRAN

## healthyR.data 1.0.0

CRAN release: 2020-11-23

- Version 1.0.0 Released onto CRAN

## healthyR.data 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
- Added the inital administrative data-set to this data only package.
