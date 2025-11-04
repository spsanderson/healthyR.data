# CMS Data Access

Comprehensive guide to accessing Centers for Medicare & Medicaid Services (CMS) hospital data using healthyR.data.

## Table of Contents

- [Overview](#overview)
- [Understanding CMS Data](#understanding-cms-data)
- [Meta Data Functions](#meta-data-functions)
- [Data Download Functions](#data-download-functions)
- [Specific Hospital Data Functions](#specific-hospital-data-functions)
- [Complete Workflows](#complete-workflows)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

The healthyR.data package provides comprehensive access to publicly available CMS hospital data through:

1. **Meta Data Functions**: Search and explore available datasets
2. **Data Download Functions**: Fetch specific datasets
3. **Specific Hospital Data Functions**: Access 20+ pre-configured datasets
4. **Utility Functions**: Validate URLs and handle data

### Key Features

- ✅ Access current CMS hospital data
- ✅ Search by keyword, title, identifier
- ✅ Filter by media type (API, CSV, etc.)
- ✅ Download complete hospital data collections
- ✅ Fetch specific quality measures
- ✅ Access provider data via API

## Understanding CMS Data

### What is CMS Data?

CMS (Centers for Medicare & Medicaid Services) provides public datasets about:
- Hospital quality measures
- Healthcare-associated infections
- Hospital readmissions
- Patient satisfaction (HCAHPS)
- Payment and cost data
- Hospital outcomes
- And much more

### Data Versions

- **Current**: Latest available data (recommended)
- **Archive**: Historical data
- **All**: Both current and archived data

### Media Types

- **API**: JSON data via API (most flexible)
- **CSV**: Downloadable CSV files
- **Other**: Excel files, ZIP archives, etc.
- **All**: All available formats

## Meta Data Functions

### get_cms_meta_data()

Search and explore available CMS datasets.

#### Basic Usage

```r
library(healthyR.data)
library(dplyr)

# Search for all current hospital data
cms_meta <- get_cms_meta_data(
  .data_version = "current"
)

# View results
glimpse(cms_meta)
```

#### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `.title` | Character | NULL | Search by dataset title |
| `.modified_date` | Character | NULL | Filter by date (YYYY-MM-DD) |
| `.keyword` | Character | NULL | Search by keyword |
| `.identifier` | Character | NULL | Search by unique identifier |
| `.data_version` | Character | "current" | "current", "archive", or "all" |
| `.media_type` | Character | "all" | "all", "csv", "API", or "other" |

#### Search Examples

**Search by Keyword:**

```r
# Find readmission data
readmission_meta <- get_cms_meta_data(
  .keyword = "readmission",
  .data_version = "current"
)

# View titles
readmission_meta %>%
  select(title, modified, media_type) %>%
  print(n = 20)
```

**Search by Title:**

```r
# Find specific dataset
specific_data <- get_cms_meta_data(
  .title = "Unplanned Hospital Visits",
  .data_version = "current"
)

# Extract data link
data_link <- specific_data$data_link[1]
```

**Filter by Media Type:**

```r
# Get only API datasets
api_data <- get_cms_meta_data(
  .keyword = "hospital",
  .data_version = "current",
  .media_type = "API"
)

# Get only CSV files
csv_data <- get_cms_meta_data(
  .keyword = "quality",
  .data_version = "current",
  .media_type = "csv"
)
```

**Search by Date:**

```r
# Get datasets modified after specific date
recent_data <- get_cms_meta_data(
  .modified_date = "2024-01-01",
  .data_version = "current"
)
```

#### Return Columns

The function returns a tibble with these columns:

- `title` - Dataset title
- `description` - Detailed description
- `landing_page` - CMS landing page URL
- `modified` - Last modified date
- `keyword` - Associated keywords
- `described_by` - Data dictionary link
- `fn` - Contact name
- `has_email` - Contact email
- `identifier` - Unique identifier
- `start` - Data start date
- `end` - Data end date
- `references` - Related documentation
- `distribution_description` - Distribution details
- `distribution_title` - Distribution title
- `distribution_modified` - Distribution modified date
- `distribution_start` - Distribution start date
- `distribution_end` - Distribution end date
- `media_type` - File format (API, csv, etc.)
- `data_link` - Direct link to data

### get_provider_meta_data()

Search provider-specific data.

```r
# Search provider data
provider_meta <- get_provider_meta_data(
  .keyword = "hospital"
)

# View available datasets
provider_meta %>%
  select(title, modified, media_type)
```

## Data Download Functions

### fetch_cms_data()

Fetch data from a CMS data link.

#### Basic Usage

```r
# Step 1: Get metadata
cms_meta <- get_cms_meta_data(
  .title = "Unplanned Hospital Visits",
  .data_version = "current",
  .media_type = "API"
)

# Step 2: Extract data link
data_link <- cms_meta$data_link[1]

# Step 3: Fetch the data
hospital_data <- fetch_cms_data(data_link)

# Step 4: Explore
glimpse(hospital_data)
```

#### Features

- Handles API endpoints
- Handles CSV files
- Handles Excel files
- Handles ZIP archives
- Automatic URL validation
- Clean column names
- Trimmed whitespace

#### Example: Complete Workflow

```r
# Find and fetch readmission data
readmission_meta <- get_cms_meta_data(
  .keyword = "readmission",
  .data_version = "current",
  .media_type = "API"
)

# Get first API result
if (nrow(readmission_meta) > 0) {
  readmit_link <- readmission_meta$data_link[1]
  readmit_data <- fetch_cms_data(readmit_link)
  
  # Analyze
  readmit_data %>%
    count(state) %>%
    arrange(desc(n))
}
```

### fetch_provider_data()

Fetch provider data via API.

```r
# Fetch provider data with limit
provider_data <- fetch_provider_data(
  .data_identifier = "069d-826b",
  .limit = 100
)

# Fetch all records (no limit)
all_provider_data <- fetch_provider_data(
  .data_identifier = "069d-826b",
  .limit = 0
)
```

#### Parameters

- `.data_identifier` - Provider dataset identifier
- `.limit` - Number of records (default: 500, 0 = all)

### current_hosp_data()

Download all current hospital data files.

```r
# Download all data (interactive - prompts for directory)
all_hosp_data <- current_hosp_data()

# Result is a list of tibbles
names(all_hosp_data)

# Access specific dataset
first_dataset <- all_hosp_data[[1]]
```

**Note**: This function:
- Downloads ALL current hospital data
- Prompts user to select save directory
- Returns a list of tibbles
- Can be time-consuming

### current_hosp_data_dict()

Get data dictionaries for hospital data.

```r
# Download data dictionaries
data_dicts <- current_hosp_data_dict()

# View available dictionaries
names(data_dicts)
```

## Specific Hospital Data Functions

The package provides 20+ functions to access specific CMS datasets.

### Available Functions

#### Quality and Outcomes

1. **current_hcahps_data()** - Hospital Consumer Assessment (HCAHPS)
2. **current_hai_data()** - Healthcare-Associated Infections
3. **current_comp_death_data()** - Complications and Deaths
4. **current_unplanned_hospital_visits_data()** - Unplanned Visits
5. **current_maternal_data()** - Maternal Health Measures
6. **current_va_data()** - Veterans Affairs Data

#### Quality Programs

7. **current_hvbp_data()** - Hospital Value-Based Purchasing
8. **current_ipfqr_data()** - Inpatient Psychiatric Facility Quality Reporting
9. **current_oqr_oas_cahps_data()** - Outpatient Quality Reporting

#### Specific Care Areas

10. **current_timely_and_effective_care_data()** - Timely & Effective Care
11. **current_readmission_data()** - Hospital Readmissions (composite function)
12. **current_outpatient_imaging_efficiency_data()** - Imaging Efficiency

#### Payment and Cost

13. **current_payments_data()** - Payment and Value of Care
14. **current_medicare_hospital_spending_data()** - Medicare Spending

#### Ambulatory Surgery Centers

15. **current_asc_data()** - ASC Quality Measures
16. **current_asc_oas_cahps_data()** - ASC Patient Satisfaction

#### Pediatric and Children's Hospitals

17. **current_pch_hcahps_data()** - Pediatric HCAHPS
18. **current_pch_hai_hospital_data()** - Pediatric HAI
19. **current_pch_outcomes_data()** - Pediatric Outcomes
20. **current_pch_oncology_measures_hospital_data()** - Pediatric Oncology

### Usage Pattern

All specific functions follow similar patterns:

```r
# General pattern
dataset <- current_[type]_data(
  all_hosp_data,           # Result from current_hosp_data()
  .data_sets = c("...")    # Optional: specific datasets to extract
)
```

### Example: HCAHPS Data

```r
# Download all hospital data first
all_data <- current_hosp_data()

# Extract HCAHPS data
hcahps <- current_hcahps_data(all_data)

# Or specify datasets
hcahps_specific <- current_hcahps_data(
  all_data,
  .data_sets = c("National", "State")
)

# Analyze
hcahps %>%
  filter(state == "NY") %>%
  count(measure_id) %>%
  arrange(desc(n))
```

### Example: Hospital Readmissions

```r
# Get readmission data
readmissions <- current_readmission_data(all_data)

# Analyze by state
readmissions %>%
  group_by(state) %>%
  summarise(
    hospitals = n_distinct(facility_id),
    avg_score = mean(score, na.rm = TRUE)
  ) %>%
  arrange(desc(avg_score))
```

### Example: Healthcare-Associated Infections

```r
# Get HAI data
hai_data <- current_hai_data(all_data)

# Analyze infection types
hai_data %>%
  count(measure_id) %>%
  arrange(desc(n))
```

## Complete Workflows

### Workflow 1: Find and Analyze Quality Data

```r
library(healthyR.data)
library(dplyr)

# 1. Search for quality datasets
quality_meta <- get_cms_meta_data(
  .keyword = "quality",
  .data_version = "current",
  .media_type = "API"
)

# 2. Review options
quality_meta %>%
  select(title, modified) %>%
  print(n = 20)

# 3. Select and fetch specific dataset
data_link <- quality_meta$data_link[1]
quality_data <- fetch_cms_data(data_link)

# 4. Analyze
quality_data %>%
  group_by(state) %>%
  summarise(
    facilities = n_distinct(facility_id),
    measures = n_distinct(measure_id)
  )
```

### Workflow 2: Compare Hospitals by State

```r
# 1. Download all data
all_data <- current_hosp_data()

# 2. Get HCAHPS scores
hcahps <- current_hcahps_data(all_data)

# 3. Calculate state averages
state_scores <- hcahps %>%
  filter(!is.na(patient_survey_star_rating)) %>%
  group_by(state) %>%
  summarise(
    hospitals = n(),
    avg_rating = mean(as.numeric(patient_survey_star_rating), na.rm = TRUE)
  ) %>%
  arrange(desc(avg_rating))

# 4. Visualize
library(ggplot2)
state_scores %>%
  top_n(20, avg_rating) %>%
  ggplot(aes(x = reorder(state, avg_rating), y = avg_rating)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 20 States by HCAHPS Rating")
```

### Workflow 3: Infection Rate Analysis

```r
# 1. Get HAI data
all_data <- current_hosp_data()
hai <- current_hai_data(all_data)

# 2. Focus on specific infections
clabsi <- hai %>%
  filter(measure_id == "HAI_1_SIR")  # Central Line Infections

# 3. Analyze by state
clabsi_summary <- clabsi %>%
  group_by(state) %>%
  summarise(
    hospitals = n(),
    avg_sir = mean(score, na.rm = TRUE)
  ) %>%
  arrange(avg_sir)

# 4. Identify best performers
best_hospitals <- clabsi %>%
  filter(comparison == "Better than the National Benchmark") %>%
  select(facility_name, city, state, score)
```

## Best Practices

### 1. Cache Metadata Searches

```r
# Cache metadata to avoid repeated API calls
cms_meta <- get_cms_meta_data(.data_version = "current")
saveRDS(cms_meta, "cms_metadata.rds")

# Load cached data
cms_meta <- readRDS("cms_metadata.rds")
```

### 2. Validate URLs Before Fetching

```r
# Check if URL is valid
data_link <- cms_meta$data_link[1]

if (is_valid_url(data_link)) {
  data <- fetch_cms_data(data_link)
} else {
  message("Invalid URL")
}
```

### 3. Handle Large Downloads

```r
# For large datasets, save directly to disk
large_data <- fetch_cms_data(data_link)
saveRDS(large_data, "large_cms_data.rds")

# Or use CSV
write.csv(large_data, "large_cms_data.csv", row.names = FALSE)
```

### 4. Filter Early

```r
# Fetch only what you need
all_data <- current_hosp_data()

# Extract only needed datasets
hcahps <- current_hcahps_data(
  all_data,
  .data_sets = c("State")  # Only state-level data
)
```

### 5. Check for Updates

```r
# Check when data was last modified
cms_meta %>%
  select(title, modified) %>%
  arrange(desc(modified))
```

## Troubleshooting

### Issue: "Invalid URL"

**Cause**: URL may be expired or malformed

**Solution**:
```r
# Refresh metadata
cms_meta <- get_cms_meta_data(
  .data_version = "current"
)

# Validate before fetching
is_valid_url(data_link)
```

### Issue: API Timeout

**Cause**: Large dataset or slow connection

**Solution**:
```r
# Try CSV format instead
cms_meta <- get_cms_meta_data(
  .keyword = "your_keyword",
  .media_type = "csv"  # Use CSV instead of API
)
```

### Issue: Empty Results

**Cause**: Search parameters too restrictive

**Solution**:
```r
# Broaden search
cms_meta <- get_cms_meta_data(
  .keyword = "hospital",  # More general keyword
  .data_version = "all"    # Include archives
)
```

### Issue: Rate Limiting

**Cause**: Too many API requests

**Solution**:
```r
# Add delays between requests
Sys.sleep(2)  # Wait 2 seconds between calls
```

## Related Documentation

- [Function Reference](Function-Reference.md) - Complete function documentation
- [API Reference](API-Reference.md) - Technical API details
- [Use Cases and Examples](Use-Cases-and-Examples.md) - Applied examples
- [Troubleshooting](Troubleshooting.md) - Common issues

## External Resources

- [CMS Data Portal](https://data.cms.gov/)
- [CMS Hospital Compare](https://www.medicare.gov/care-compare/)
- [CMS Quality Measures](https://www.cms.gov/Medicare/Quality-Initiatives-Patient-Assessment-Instruments/QualityMeasures)

---

[← Back to Home](Home.md) | [Next: Function Reference →](Function-Reference.md)
