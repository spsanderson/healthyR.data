
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

## Overview

To view the full wiki, click here: [Full healthyR.data
Wiki](https://github.com/spsanderson/healthyR.data/blob/master/wiki/Home.md)

**healthyR.data** is a comprehensive R package that provides healthcare
administrative datasets and tools for accessing CMS (Centers for
Medicare & Medicaid Services) hospital data. The package serves two
primary purposes:

1.  **Built-in Healthcare Data**: Provides a rich, realistic
    administrative dataset (`healthyR_data`) with 187,721 rows covering
    hospital visits, patient demographics, charges, payments, and
    quality metrics
2.  **CMS Data Access**: Offers a suite of functions to fetch, download,
    and work with current CMS hospital data, including quality measures,
    outcomes, and provider information

Whether you’re testing healthcare analytics functions, teaching health
informatics, or conducting research, **healthyR.data** provides the data
infrastructure you need.

## Features

### Built-in Administrative Dataset

The `healthyR_data` dataset includes:

- **Patient Information**: Medical Record Numbers (MRN), visit IDs, and
  visit dates
- **Financial Data**: Charges, payments, adjustments, and amounts due
- **Clinical Metrics**: Length of stay, service lines, readmission flags
- **Quality Indicators**: Expected vs actual length of stay, outlier
  flags, readmission expectations
- **Payer Information**: Insurance classifications and payer groupings

### CMS Data Access Functions

The package provides multiple ways to access current CMS hospital data:

1.  **Meta Data Functions**: Search and explore available CMS datasets
    - `get_cms_meta_data()` - Search CMS data catalog
    - `get_provider_meta_data()` - Search provider data
2.  **Data Download Functions**: Fetch current hospital data
    - `current_hosp_data()` - Download all current hospital data
    - `fetch_cms_data()` - Fetch specific CMS datasets
    - `fetch_provider_data()` - Fetch provider data via API
3.  **Specific Hospital Data Functions**: Get targeted datasets
    - `current_asc_data()` - Ambulatory Surgery Center data
    - `current_hcahps_data()` - Hospital Consumer Assessment of
      Healthcare Providers and Systems
    - `current_hai_data()` - Healthcare-Associated Infections
    - `current_readmission_data()` - Hospital readmissions
    - And 20+ more specific data extraction functions

### Utility Functions

- `is_valid_url()` - Validate URLs before data fetching
- `current_hosp_data_dict()` - Get data dictionaries

## Installation

Install the released version from [CRAN](https://CRAN.R-project.org):

``` r
install.packages("healthyR.data")
```

Install the development version from
[GitHub](https://github.com/spsanderson/healthyR.data):

``` r
# install.packages("devtools")
devtools::install_github("spsanderson/healthyR.data")
```

## Quick Start

### Using the Built-in Dataset

``` r
library(healthyR.data)
library(dplyr)

# Load the built-in dataset
df <- healthyR_data

# Explore the data structure
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

# Analyze service lines by patient type
df %>% 
    count(ip_op_flag, service_line) %>%
    arrange(ip_op_flag, desc(n)) %>%
    rename(count = n) %>%
    head(10)
#> # A tibble: 10 × 3
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
```

### Analyzing Financial Data

``` r
# Analyze charges and payments by payer type
df %>%
    group_by(payer_grouping) %>%
    summarise(
        visits = n(),
        avg_charge = mean(total_charge_amount, na.rm = TRUE),
        avg_payment = mean(abs(total_payment_amount), na.rm = TRUE),
        .groups = "drop"
    ) %>%
    arrange(desc(visits)) %>%
    head(10)
#> # A tibble: 10 × 4
#>    payer_grouping visits avg_charge avg_payment
#>    <chr>           <int>      <dbl>       <dbl>
#>  1 Medicare A      52622     68452.      11861.
#>  2 Medicaid HMO    25484     37285.       5575.
#>  3 Blue Cross      24357     31561.      10374.
#>  4 Medicare B      22563     16136.       2531.
#>  5 Medicare HMO    18997     55526.       8443.
#>  6 HMO             17444     31407.       9405.
#>  7 Medicaid         8777     49428.       7602.
#>  8 Commercial       6567     35300.      12506.
#>  9 Self Pay         3649     24998.        662.
#> 10 Compensation     2502     40101.       6413.
```

### Quality Metrics Analysis

``` r
# Examine length of stay outliers
df %>%
    filter(ip_op_flag == "I") %>%  # Inpatient only
    group_by(service_line) %>%
    summarise(
        total_visits = n(),
        avg_los = mean(length_of_stay, na.rm = TRUE),
        outlier_rate = mean(los_outlier_flag, na.rm = TRUE) * 100,
        readmit_rate = mean(readmit_flag, na.rm = TRUE) * 100,
        .groups = "drop"
    ) %>%
    arrange(desc(total_visits)) %>%
    head(10)
#> # A tibble: 10 × 5
#>    service_line                   total_visits avg_los outlier_rate readmit_rate
#>    <chr>                                 <int>   <dbl>        <dbl>        <dbl>
#>  1 Medical                               64435    5.72       0.205         12.8 
#>  2 Surgical                              14916    9.35       0.436         10.8 
#>  3 COPD                                   4398    5.28       0.0910        19.6 
#>  4 CHF                                    3871    6.42       0.103         21.1 
#>  5 Pneumonia                              3323    5.89       0.120         14.2 
#>  6 Cellulitis                             3311    4.78       0.242          9.09
#>  7 Major Depression/Bipolar Affe…         2866   10.4        0.105          5.58
#>  8 Chest Pain                             2766    2.05       0.145          8.28
#>  9 GI Hemorrhage                          2404    5.86       0.416         14.6 
#> 10 MI                                     2253    4.96       0.266         14.4
```

## Working with CMS Data

### Searching for CMS Datasets

``` r
library(healthyR.data)

# Search for datasets about hospital readmissions
meta_data <- get_cms_meta_data(
    .keyword = "readmission",
    .data_version = "current"
)

# View available datasets
meta_data %>%
    select(title, modified, media_type) %>%
    head()
```

### Fetching CMS Data via API

``` r
# Get metadata for a specific dataset
cms_meta <- get_cms_meta_data(
    .title = "Unplanned Hospital Visits",
    .data_version = "current",
    .media_type = "API"
)

# Extract the data link
data_link <- cms_meta$data_link[1]

# Fetch the actual data
hospital_data <- fetch_cms_data(data_link)

glimpse(hospital_data)
```

### Downloading Complete Hospital Data

``` r
# Download all current hospital data files (requires user to select directory)
all_hosp_data <- current_hosp_data()

# The result is a list of tibbles, one for each data file
names(all_hosp_data)

# Extract specific datasets
asc_data <- current_asc_data(
    all_hosp_data, 
    .data_sets = c("Facility", "State")
)
```

### Working with Provider Data

``` r
# Search for provider datasets
provider_meta <- get_provider_meta_data(.keyword = "hospital")

# Fetch provider data using an identifier
provider_data <- fetch_provider_data("069d-826b", .limit = 100)

glimpse(provider_data)
```

## Use Cases

**healthyR.data** is ideal for:

- **Healthcare Analytics**: Test and develop healthcare analytics
  functions with realistic data
- **Education**: Teach health informatics and data analysis courses
- **Research**: Prototype healthcare research analyses before working
  with protected data
- **Package Development**: Test healthcare R packages (like the
  [healthyR](https://github.com/spsanderson/healthyR) package)
- **Quality Improvement**: Analyze hospital quality metrics and
  performance indicators
- **Financial Analysis**: Study healthcare billing, payments, and
  reimbursement patterns
- **Benchmarking**: Compare your data against national hospital data
  from CMS

## Data Dictionary

The `healthyR_data` dataset contains 187,721 rows and 17 variables:

| Variable | Description |
|----|----|
| `mrn` | Medical Record Number (unique patient identifier) |
| `visit_id` | Unique hospital visit identifier |
| `visit_start_date_time` | Visit start date and time |
| `visit_end_date_time` | Visit end date and time |
| `total_charge_amount` | Total charges for the visit (USD) |
| `total_amount_due` | Amount still owed for the visit (USD) |
| `total_adjustment_amount` | Total adjustments to the account (USD) |
| `payer_grouping` | Insurance classification |
| `total_payment_amount` | Total payments received (USD) |
| `ip_op_flag` | Patient type (I=Inpatient, O=Outpatient) |
| `service_line` | Hospital service line |
| `length_of_stay` | Total days admitted to hospital |
| `expected_length_of_stay` | Expected days for admission |
| `length_of_stay_threshold` | LOS threshold for outlier classification |
| `los_outlier_flag` | Binary indicator if visit exceeded LOS threshold |
| `readmit_flag` | Binary indicator if readmitted within 30 days |
| `readmit_expectation` | Expected readmission rate from benchmark |

## Requirements

- R \>= 4.1.0
- Dependencies: `dplyr`, `rlang`, `utils`, `janitor`, `httr2`,
  `stringr`, `tidyr`, `stats`

## Documentation

- [Package Website](https://www.spsanderson.com/healthyR.data/)
- [Function
  Reference](https://www.spsanderson.com/healthyR.data/reference/index.html)
- [News/Changelog](https://www.spsanderson.com/healthyR.data/news/index.html)

## Getting Help

If you encounter a bug or have a feature request:

- [Report issues on
  GitHub](https://github.com/spsanderson/healthyR.data/issues)
- Check the [function
  reference](https://www.spsanderson.com/healthyR.data/reference/index.html)
  for detailed documentation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
For major changes:

1.  Fork the repository
2.  Create your feature branch
    (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

Please make sure to update tests as appropriate and follow the existing
code style.

## Related Packages

- [healthyR](https://github.com/spsanderson/healthyR) - Hospital data
  analysis workflow tools
- [healthyverse](https://github.com/spsanderson/healthyverse) -
  Meta-package for healthcare analytics

## License

MIT License - see [LICENSE.md](LICENSE.md) for details

## Author

Steven P. Sanderson II, MPH  
Email: <spsanderson@gmail.com>  
ORCID: [0009-0006-7661-8247](https://orcid.org/0009-0006-7661-8247)

## Citation

If you use this package in your research, please cite:

``` r
citation("healthyR.data")
```

------------------------------------------------------------------------

**Note**: The built-in `healthyR_data` dataset contains
synthetic/de-identified data for demonstration and testing purposes.
When working with CMS data functions, you’re accessing real, publicly
available CMS hospital data.
