# Function Reference

Complete reference for all functions in the healthyR.data package, organized by category.

## Table of Contents

- [Overview](#overview)
- [Meta Data Functions](#meta-data-functions)
- [Data Download Functions](#data-download-functions)
- [Specific Hospital Data Functions](#specific-hospital-data-functions)
- [Utility Functions](#utility-functions)
- [Dataset](#dataset)
- [Quick Reference Table](#quick-reference-table)

## Overview

The healthyR.data package contains 27+ functions organized into these categories:

- **Meta Data Functions** (2): Search and explore CMS datasets
- **Data Download Functions** (3): Fetch CMS and provider data
- **Specific Hospital Data Functions** (20+): Access specific CMS datasets
- **Utility Functions** (1): Helper functions
- **Dataset** (1): Built-in healthcare data

## Meta Data Functions

Functions for searching and exploring available CMS datasets.

### get_cms_meta_data()

**Purpose**: Search CMS data catalog for available datasets

**Usage**:
```r
get_cms_meta_data(
  .title = NULL,
  .modified_date = NULL,
  .keyword = NULL,
  .identifier = NULL,
  .data_version = "current",
  .media_type = "all"
)
```

**Parameters**:
- `.title` - Dataset title to search for
- `.modified_date` - Filter by modification date (YYYY-MM-DD)
- `.keyword` - Search keyword
- `.identifier` - Unique dataset identifier
- `.data_version` - "current", "archive", or "all" (default: "current")
- `.media_type` - "all", "csv", "API", or "other" (default: "all")

**Returns**: Tibble with dataset metadata including data links

**Example**:
```r
# Search for readmission data
cms_meta <- get_cms_meta_data(
  .keyword = "readmission",
  .data_version = "current"
)
```

**See Also**: [CMS Data Access Guide](CMS-Data-Access.md#get_cms_meta_data)

---

### get_provider_meta_data()

**Purpose**: Search provider-specific datasets

**Usage**:
```r
get_provider_meta_data(.keyword = NULL)
```

**Parameters**:
- `.keyword` - Search keyword for provider data

**Returns**: Tibble with provider dataset metadata

**Example**:
```r
# Search provider data
provider_meta <- get_provider_meta_data(.keyword = "hospital")
```

---

## Data Download Functions

Functions for fetching actual CMS data.

### fetch_cms_data()

**Purpose**: Fetch data from a CMS data link

**Usage**:
```r
fetch_cms_data(.data_link)
```

**Parameters**:
- `.data_link` - URL to CMS data (from `get_cms_meta_data()`)

**Returns**: Tibble with fetched data, cleaned column names

**Features**:
- Handles API endpoints
- Handles CSV files
- Handles Excel files
- Handles ZIP archives
- Automatic URL validation
- Clean column names

**Example**:
```r
# Get metadata first
cms_meta <- get_cms_meta_data(.keyword = "quality", .media_type = "API")

# Extract link
data_link <- cms_meta$data_link[1]

# Fetch data
quality_data <- fetch_cms_data(data_link)
```

**See Also**: `get_cms_meta_data()`, `is_valid_url()`

---

### fetch_provider_data()

**Purpose**: Fetch provider data via API using dataset identifier

**Usage**:
```r
fetch_provider_data(.data_identifier, .limit = 500)
```

**Parameters**:
- `.data_identifier` - Provider dataset identifier
- `.limit` - Number of records to return (default: 500, 0 = all)

**Returns**: Tibble with provider data

**Example**:
```r
# Fetch 100 provider records
provider_data <- fetch_provider_data(
  .data_identifier = "069d-826b",
  .limit = 100
)

# Fetch all records
all_provider_data <- fetch_provider_data(
  .data_identifier = "069d-826b",
  .limit = 0
)
```

---

### current_hosp_data()

**Purpose**: Download all current hospital data files

**Usage**:
```r
current_hosp_data()
```

**Parameters**: None (interactive - prompts for directory)

**Returns**: Named list of tibbles, one per dataset

**Features**:
- Downloads ALL current CMS hospital data
- Interactive directory selection
- Returns list of datasets

**Example**:
```r
# Download all data (will prompt for directory)
all_data <- current_hosp_data()

# View what was downloaded
names(all_data)

# Access specific dataset
first_dataset <- all_data[[1]]
```

**Note**: This function can take significant time to download all data

---

### current_hosp_data_dict()

**Purpose**: Get data dictionaries for hospital datasets

**Usage**:
```r
current_hosp_data_dict()
```

**Returns**: Named list with data dictionaries

**Example**:
```r
# Get data dictionaries
data_dicts <- current_hosp_data_dict()

# View available dictionaries
names(data_dicts)
```

---

## Specific Hospital Data Functions

Functions to access specific CMS hospital quality and outcome datasets. All functions follow the pattern:

```r
current_[type]_data(all_hosp_data, .data_sets = NULL)
```

Where:
- `all_hosp_data` - Result from `current_hosp_data()`
- `.data_sets` - Optional vector of specific datasets to extract

### Quality and Patient Satisfaction

#### current_hcahps_data()

**Purpose**: Hospital Consumer Assessment of Healthcare Providers and Systems

**Usage**:
```r
current_hcahps_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: National, State, Facility level HCAHPS scores

**Example**:
```r
all_data <- current_hosp_data()
hcahps <- current_hcahps_data(all_data)

# Or specific datasets
hcahps_state <- current_hcahps_data(all_data, .data_sets = c("State"))
```

---

#### current_hai_data()

**Purpose**: Healthcare-Associated Infections data

**Usage**:
```r
current_hai_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: HAI measures including CLABSI, CAUTI, SSI, CDI, MRSA

**Example**:
```r
hai <- current_hai_data(all_data)

# Filter for specific infection types
clabsi <- hai %>% filter(measure_id == "HAI_1_SIR")
```

---

### Outcomes and Complications

#### current_comp_death_data()

**Purpose**: Complications and Deaths measures

**Usage**:
```r
current_comp_death_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Death rates, complication rates by condition

---

#### current_unplanned_hospital_visits_data()

**Purpose**: Unplanned hospital visits and returns

**Usage**:
```r
current_unplanned_hospital_visits_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Readmission measures, emergency department visits

---

#### current_maternal_data()

**Purpose**: Maternal health quality measures

**Usage**:
```r
current_maternal_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Maternal care quality indicators

---

### Quality Programs

#### current_hvbp_data()

**Purpose**: Hospital Value-Based Purchasing program data

**Usage**:
```r
current_hvbp_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: VBP scores and payments

---

#### current_ipfqr_data()

**Purpose**: Inpatient Psychiatric Facility Quality Reporting

**Usage**:
```r
current_ipfqr_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Psychiatric facility quality measures

---

#### current_oqr_oas_cahps_data()

**Purpose**: Outpatient Quality Reporting and CAHPS

**Usage**:
```r
current_oqr_oas_cahps_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Outpatient quality measures

---

### Care Quality

#### current_timely_and_effective_care_data()

**Purpose**: Timely and effective care measures

**Usage**:
```r
current_timely_and_effective_care_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Process of care measures, treatment timeliness

---

#### current_outpatient_imaging_efficiency_data()

**Purpose**: Outpatient imaging efficiency measures

**Usage**:
```r
current_outpatient_imaging_efficiency_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Imaging appropriateness measures

---

### Payment and Cost

#### current_payments_data()

**Purpose**: Payment and value of care data

**Usage**:
```r
current_payments_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Medicare payment and spending data

---

#### current_medicare_hospital_spending_data()

**Purpose**: Medicare hospital spending per beneficiary

**Usage**:
```r
current_medicare_hospital_spending_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Hospital spending patterns

---

### Ambulatory Surgery Centers

#### current_asc_data()

**Purpose**: Ambulatory Surgery Center quality measures

**Usage**:
```r
current_asc_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: ASC quality indicators

**Example**:
```r
asc <- current_asc_data(all_data, .data_sets = c("Facility", "State"))
```

---

#### current_asc_oas_cahps_data()

**Purpose**: ASC patient satisfaction (OAS CAHPS)

**Usage**:
```r
current_asc_oas_cahps_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: ASC patient survey results

---

### Pediatric and Children's Hospitals

#### current_pch_hcahps_data()

**Purpose**: Pediatric HCAHPS survey results

**Usage**:
```r
current_pch_hcahps_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Pediatric patient satisfaction

---

#### current_pch_hai_hospital_data()

**Purpose**: Pediatric healthcare-associated infections

**Usage**:
```r
current_pch_hai_hospital_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Pediatric infection measures

---

#### current_pch_outcomes_data()

**Purpose**: Pediatric outcomes measures

**Usage**:
```r
current_pch_outcomes_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Pediatric quality outcomes

---

#### current_pch_oncology_measures_hospital_data()

**Purpose**: Pediatric oncology quality measures

**Usage**:
```r
current_pch_oncology_measures_hospital_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: Pediatric cancer care quality

---

### Other

#### current_va_data()

**Purpose**: Veterans Affairs hospital data

**Usage**:
```r
current_va_data(all_hosp_data, .data_sets = NULL)
```

**Datasets**: VA hospital quality measures

---

## Utility Functions

### is_valid_url()

**Purpose**: Validate URL before fetching data

**Usage**:
```r
is_valid_url(url)
```

**Parameters**:
- `url` - Character string with URL to validate

**Returns**: Logical (TRUE if valid, FALSE otherwise)

**Example**:
```r
# Validate URL
url <- "https://data.cms.gov/api/data.json"
is_valid <- is_valid_url(url)

if (is_valid) {
  data <- fetch_cms_data(url)
}
```

**Note**: Used internally by fetch functions but available for manual validation

---

## Dataset

### healthyR_data

**Purpose**: Built-in synthetic healthcare administrative dataset

**Type**: Data frame / tibble

**Dimensions**: 187,721 rows × 17 columns

**Usage**:
```r
data(healthyR_data)
# Or simply
healthyR_data
```

**Variables**: See [Data Dictionary](Data-Dictionary.md)

**Example**:
```r
library(healthyR.data)
library(dplyr)

# Load data
df <- healthyR_data

# Explore
glimpse(df)
summary(df)
```

**Documentation**: See [Built-in Dataset](Built-in-Dataset.md)

---

## Quick Reference Table

### Meta Data Functions

| Function | Purpose | Returns |
|----------|---------|---------|
| `get_cms_meta_data()` | Search CMS datasets | Metadata tibble |
| `get_provider_meta_data()` | Search provider datasets | Metadata tibble |

### Data Download Functions

| Function | Purpose | Returns |
|----------|---------|---------|
| `fetch_cms_data()` | Fetch CMS data from link | Data tibble |
| `fetch_provider_data()` | Fetch provider data via API | Data tibble |
| `current_hosp_data()` | Download all hospital data | List of tibbles |
| `current_hosp_data_dict()` | Get data dictionaries | List of dictionaries |

### Specific Hospital Data Functions

| Function | Dataset Type |
|----------|-------------|
| `current_hcahps_data()` | Patient satisfaction (HCAHPS) |
| `current_hai_data()` | Healthcare-associated infections |
| `current_comp_death_data()` | Complications and deaths |
| `current_unplanned_hospital_visits_data()` | Readmissions |
| `current_maternal_data()` | Maternal health |
| `current_hvbp_data()` | Value-based purchasing |
| `current_ipfqr_data()` | Psychiatric facility quality |
| `current_oqr_oas_cahps_data()` | Outpatient quality |
| `current_timely_and_effective_care_data()` | Process measures |
| `current_outpatient_imaging_efficiency_data()` | Imaging efficiency |
| `current_payments_data()` | Payment data |
| `current_medicare_hospital_spending_data()` | Medicare spending |
| `current_asc_data()` | ASC quality |
| `current_asc_oas_cahps_data()` | ASC satisfaction |
| `current_pch_hcahps_data()` | Pediatric HCAHPS |
| `current_pch_hai_hospital_data()` | Pediatric HAI |
| `current_pch_outcomes_data()` | Pediatric outcomes |
| `current_pch_oncology_measures_hospital_data()` | Pediatric oncology |
| `current_va_data()` | VA hospital data |

### Utility Functions

| Function | Purpose |
|----------|---------|
| `is_valid_url()` | Validate URL |

### Dataset

| Object | Description |
|--------|-------------|
| `healthyR_data` | Built-in healthcare dataset (187,721 × 17) |

## Function Families

Functions are organized into these families (for help system):

- **Meta Data**: `get_cms_meta_data()`, `get_provider_meta_data()`
- **CMS Data**: `fetch_cms_data()`, `current_hosp_data()`, all `current_*_data()` functions
- **Provider Data**: `fetch_provider_data()`, `get_provider_meta_data()`
- **Utility**: `is_valid_url()`

## Getting Help

Get help for any function:

```r
# Function help
?get_cms_meta_data
?current_hcahps_data
?healthyR_data

# Package help
?healthyR.data

# See all functions
library(help = "healthyR.data")

# See functions in a family
?`Meta Data`
?`CMS Data`
```

## Related Documentation

- [CMS Data Access](CMS-Data-Access.md) - Detailed guide for CMS functions
- [Built-in Dataset](Built-in-Dataset.md) - healthyR_data documentation
- [Data Dictionary](Data-Dictionary.md) - Variable reference
- [Use Cases and Examples](Use-Cases-and-Examples.md) - Applied examples

---

[← Back to Home](Home.md) | [CMS Data Access →](CMS-Data-Access.md)
