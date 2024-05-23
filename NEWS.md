# healthyR.data 1.1.0

## Breaking Changes
None

## New Function
1. Fix #77 - Add function `get_cms_meta_data()`
2. Fix #82 - Add function `get_provider_meta_data()`
3. Fix #89 - Add functions `fetch_cms_data()`, `fetch_provider_data()`

## Minor Fixes and Improvements
1. Fix #72 - Fix bug in directory file paths for `current_hosp_data()`

# healthyR.data 1.0.3

## Breaking Changes
1. Require R version 3.4.0 in keeping with tidyverse practices.

## New Functions
1. Fix #12 - Add function `current_hosp_data_dict()`
2. Fix #10 - Add function `current_hosp_data()`
3. Fix #22 - Add function `current_asc_data()`
4. Fix #28 - Add function `current_asc_oas_cahps_data()`
5. Fix #31 - Add function `current_comp_death_data()`
6. Fix #33 - Confirm logic in `current_hosp_data()` (@rjake)
7. Fix #38 - Add function `current_hai_data()`
8, Fix #39 - Add function `current_hcahps_data()`
9. Fix #42 - Add function `current_hvbp_data()`
10. Fix #45 - Add function `current_ipfqr_data()`
11. Fix #47 - Add function `current_maternal_data()`
12. Fix #49 - Add function `current_medicare_hospital_spending_data()`
13. Fix #51 - Add function `current_opqr_data()`
14. Fix #52 - Add function `current_imaging_efficiency_data()`
15. Fix #60 - Add function `current_unplanned_hospital_visits_data()`
16. Fix #53 - Add function `current_payments_data()`
17. Fix #55 - Add function `current_pch_hcahps_data()`
18. Fix #56 - Add function `current_pch_hai_hospital_data()`
19. Fix #57 - Add function `current_pch_oncology_measures_hospital_data()`
20. Fix #58 - Add function `current_pch_outcomes_data()`
21. Fix #59 - Add function `current_timely_and_effective_care_data()`
22. Fix $65 - Add function `current_va_data()`

## Minor Fixes and Improvements
None

# healthyR.data 1.0.2

## Breaking Changes
None

## New Features
None

## Minor Fixes and Improvments
1. Fix #8 - Drop need for `cli`, `crayon`, and `rstudioapi`

# healthyR.data 1.0.1
* The CRAN policy asks for minimal package size, which includes installed
size. Add LazyDataCompression: xz to DESCRIPTION file per CRAN


# healthyR.data 1.0.0
* Version 1.0.0 Released onto CRAN

# healthyR.data 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
* Added the inital administrative data-set to this data only package.
