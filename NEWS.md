# healthyR.data (development version)

## Breaking Changes
1. Require R version 3.4.0 in keeping with tidyverse practices.

## New Functions
1. Fix #12 - Add function `dl_hosp_data_dict()`
2. Fix #10 - Add function `current_hosp_data()`
3. Fix #22 - Add function `current_asc_data()`
4. Fix #28 - Add function `current_asc_oas_cahps_data()`
5. Fix #31 - Add function `current_comp_death_data()`
6. Fix #33 - Confirm logic in `current_hosp_data()` (@rjake)

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
