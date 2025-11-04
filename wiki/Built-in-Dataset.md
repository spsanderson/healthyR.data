# Built-in Dataset: healthyR_data

Comprehensive documentation for the `healthyR_data` dataset included in the healthyR.data package.

## Table of Contents

- [Overview](#overview)
- [Dataset Characteristics](#dataset-characteristics)
- [Variable Descriptions](#variable-descriptions)
- [Data Types](#data-types)
- [Data Quality](#data-quality)
- [Sample Data](#sample-data)
- [Usage Examples](#usage-examples)
- [Data Patterns](#data-patterns)
- [Important Notes](#important-notes)

## Overview

The `healthyR_data` dataset is a comprehensive, synthetic healthcare administrative dataset that mimics real-world hospital data. It's designed to be realistic enough for meaningful analysis while being completely de-identified and safe to use for:

- Testing healthcare analytics functions
- Educational purposes
- Package development
- Prototyping research analyses
- Training and demonstrations

### Quick Stats

| Metric | Value |
|--------|-------|
| **Total Records** | 187,721 |
| **Total Variables** | 17 |
| **Date Range** | 2010-2020 |
| **Patient Type** | Inpatient & Outpatient |
| **Data Type** | Synthetic/De-identified |

## Dataset Characteristics

### Size and Scope

```r
# Load and check dimensions
library(healthyR.data)
data(healthyR_data)

dim(healthyR_data)
# [1] 187721     17

# Object size
object.size(healthyR_data) %>% format(units = "MB")
# Approximately 15-20 MB
```

### Data Distribution

```r
library(dplyr)

# Patient type distribution
healthyR_data %>%
  count(ip_op_flag) %>%
  mutate(percentage = round(n / sum(n) * 100, 2))

# Output:
# ip_op_flag      n  percentage
#          I  107451       57.23
#          O   80270       42.77
```

## Variable Descriptions

### 1. mrn (Medical Record Number)
- **Type**: Character
- **Description**: Unique patient identifier
- **Format**: 8-digit number as string
- **Uniqueness**: Multiple visits can have same MRN
- **Example**: "86069614"

```r
# Unique patients in dataset
length(unique(healthyR_data$mrn))
# Approximately 100,000+ unique patients
```

### 2. visit_id
- **Type**: Character
- **Description**: Unique hospital visit identifier
- **Format**: 10-digit number as string
- **Uniqueness**: Each visit has unique ID
- **Example**: "3519249247"
- **Key**: Primary key for the dataset

```r
# Verify uniqueness
length(unique(healthyR_data$visit_id)) == nrow(healthyR_data)
# Should be TRUE
```

### 3. visit_start_date_time
- **Type**: POSIXct datetime
- **Description**: Date and time when visit started
- **Format**: YYYY-MM-DD HH:MM:SS
- **Range**: 2010-01-04 to 2020-12-31
- **Timezone**: UTC
- **Example**: "2010-01-04 05:00:00"

```r
# Date range
range(healthyR_data$visit_start_date_time)

# Extract components
library(lubridate)
healthyR_data %>%
  mutate(
    year = year(visit_start_date_time),
    month = month(visit_start_date_time),
    day = wday(visit_start_date_time, label = TRUE)
  )
```

### 4. visit_end_date_time
- **Type**: POSIXct datetime
- **Description**: Date and time when visit ended
- **Format**: YYYY-MM-DD HH:MM:SS
- **Notes**: For outpatients, often same as start date
- **Example**: "2010-01-04"

```r
# Calculate visit duration
healthyR_data %>%
  mutate(
    duration_hours = as.numeric(
      difftime(visit_end_date_time, visit_start_date_time, units = "hours")
    )
  )
```

### 5. total_charge_amount
- **Type**: Numeric (double)
- **Description**: Total charges for the visit in USD
- **Range**: $0 to $500,000+
- **Units**: US Dollars
- **Example**: 25983.88
- **Note**: Gross charges before adjustments

```r
# Charge statistics
healthyR_data %>%
  summarise(
    min_charge = min(total_charge_amount),
    mean_charge = mean(total_charge_amount),
    median_charge = median(total_charge_amount),
    max_charge = max(total_charge_amount)
  )
```

### 6. total_amount_due
- **Type**: Numeric (double)
- **Description**: Amount still owed for the visit
- **Range**: $0 to several thousand
- **Units**: US Dollars
- **Example**: 0.00
- **Note**: Often zero for fully paid accounts

```r
# Accounts with outstanding balance
healthyR_data %>%
  filter(total_amount_due > 0) %>%
  nrow()
```

### 7. total_adjustment_amount
- **Type**: Numeric (double)
- **Description**: Total adjustments (write-offs, contractual adjustments)
- **Sign**: Typically negative (reducing charges)
- **Units**: US Dollars
- **Example**: -20799.61

```r
# Adjustment analysis
healthyR_data %>%
  mutate(
    adjustment_rate = abs(total_adjustment_amount) / total_charge_amount * 100
  ) %>%
  summarise(
    mean_adjustment_rate = mean(adjustment_rate, na.rm = TRUE)
  )
```

### 8. payer_grouping
- **Type**: Character
- **Description**: Insurance classification
- **Categories**: Multiple insurance types
- **Example**: "Medicare B", "HMO", "Blue Cross"

```r
# Payer distribution
healthyR_data %>%
  count(payer_grouping) %>%
  arrange(desc(n))

# Common payer types:
# - Medicare B
# - HMO
# - Medicare HMO
# - Blue Cross
# - Self Pay
# - Commercial
# - PPO
# - Medicaid
```

### 9. total_payment_amount
- **Type**: Numeric (double)
- **Description**: Total payments received
- **Sign**: Typically negative (payments reduce balance)
- **Units**: US Dollars
- **Example**: -5184.27

```r
# Payment analysis
healthyR_data %>%
  mutate(
    payment_rate = abs(total_payment_amount) / total_charge_amount * 100
  ) %>%
  group_by(payer_grouping) %>%
  summarise(
    avg_payment_rate = mean(payment_rate, na.rm = TRUE)
  )
```

### 10. ip_op_flag
- **Type**: Character
- **Description**: Patient type indicator
- **Values**:
  - "I" = Inpatient (admitted)
  - "O" = Outpatient (not admitted)
- **Example**: "O"

```r
# Distribution
healthyR_data %>%
  count(ip_op_flag)
```

### 11. service_line
- **Type**: Character
- **Description**: Hospital service line
- **Categories**: Multiple clinical service lines
- **Example**: "Medical", "Surgical", "COPD", "CHF"

```r
# Top service lines
healthyR_data %>%
  count(service_line) %>%
  arrange(desc(n)) %>%
  head(15)

# Common service lines:
# - Medical
# - Surgical
# - General Outpatient
# - COPD
# - CHF
# - Pneumonia
# - Chest Pain
```

### 12. length_of_stay
- **Type**: Numeric (double)
- **Description**: Total days admitted
- **Range**: 0 (outpatient) to 100+ days
- **Units**: Days
- **Example**: 0 for outpatients, 1-30+ for inpatients

```r
# LOS statistics for inpatients
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  summarise(
    mean_los = mean(length_of_stay),
    median_los = median(length_of_stay),
    max_los = max(length_of_stay)
  )
```

### 13. expected_length_of_stay
- **Type**: Logical (NA for most records)
- **Description**: Expected days for admission
- **Usage**: Benchmark for LOS comparison
- **Note**: Primarily available for inpatients

### 14. length_of_stay_threshold
- **Type**: Logical (NA for most records)
- **Description**: LOS threshold for outlier classification
- **Usage**: Defines when a stay is considered an outlier

### 15. los_outlier_flag
- **Type**: Numeric (binary: 0 or 1)
- **Description**: Indicates if visit exceeded LOS threshold
- **Values**:
  - 0 = Normal stay
  - 1 = Outlier stay
- **Example**: 0

```r
# Outlier rate
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  summarise(
    outlier_rate = mean(los_outlier_flag, na.rm = TRUE) * 100
  )
```

### 16. readmit_flag
- **Type**: Numeric (binary: 0 or 1)
- **Description**: Indicates readmission within 30 days
- **Values**:
  - 0 = Not readmitted
  - 1 = Readmitted within 30 days
- **Example**: 0

```r
# Readmission rate
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  summarise(
    readmission_rate = mean(readmit_flag, na.rm = TRUE) * 100
  )
```

### 17. readmit_expectation
- **Type**: Logical (NA for most records)
- **Description**: Expected readmission rate from benchmark
- **Usage**: Compare actual vs expected readmissions

## Data Types

Complete data type reference:

```r
# Check all data types
str(healthyR_data)

# Or with dplyr
library(dplyr)
healthyR_data %>%
  summarise(across(everything(), class))
```

| Variable | R Type | Description |
|----------|--------|-------------|
| mrn | character | Patient ID |
| visit_id | character | Visit ID |
| visit_start_date_time | POSIXct | Datetime |
| visit_end_date_time | POSIXct | Datetime |
| total_charge_amount | numeric | Dollar amount |
| total_amount_due | numeric | Dollar amount |
| total_adjustment_amount | numeric | Dollar amount |
| payer_grouping | character | Category |
| total_payment_amount | numeric | Dollar amount |
| ip_op_flag | character | Category |
| service_line | character | Category |
| length_of_stay | numeric | Days |
| expected_length_of_stay | logical | Mostly NA |
| length_of_stay_threshold | logical | Mostly NA |
| los_outlier_flag | numeric | Binary |
| readmit_flag | numeric | Binary |
| readmit_expectation | logical | Mostly NA |

## Data Quality

### Completeness

```r
# Check for missing values
healthyR_data %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "missing_count")

# Percentage complete
healthyR_data %>%
  summarise(across(everything(), ~ sum(!is.na(.)) / n() * 100))
```

### Key Fields
- **Never missing**: mrn, visit_id, dates, charges, ip_op_flag
- **Often missing**: expected_length_of_stay, length_of_stay_threshold, readmit_expectation
- **Meaningful zeros**: length_of_stay (for outpatients), flags

## Sample Data

View first records:

```r
head(healthyR_data, 3)

# Example output:
#   mrn      visit_id    visit_start_date_time visit_end_date_time total_charge_amount
#   86069614 3519249247  2010-01-04 05:00:00   2010-01-04          25983.88
#   60856527 3602225015  2010-01-04 05:00:00   2010-01-04          22774.05
#   80673110 3125290892  2010-01-04 05:00:00   2010-01-04          10690.45
```

## Usage Examples

### Example 1: Basic Exploration

```r
# Load and explore
library(healthyR.data)
library(dplyr)

df <- healthyR_data

# Quick summary
df %>%
  summarise(
    total_visits = n(),
    unique_patients = n_distinct(mrn),
    date_range = paste(min(visit_start_date_time), "to", max(visit_start_date_time)),
    total_charges = sum(total_charge_amount)
  )
```

### Example 2: Inpatient Analysis

```r
# Focus on inpatients
inpatient_data <- healthyR_data %>%
  filter(ip_op_flag == "I")

# Service line summary
inpatient_data %>%
  group_by(service_line) %>%
  summarise(
    visits = n(),
    avg_los = mean(length_of_stay),
    avg_charge = mean(total_charge_amount),
    outlier_rate = mean(los_outlier_flag) * 100,
    readmit_rate = mean(readmit_flag) * 100
  ) %>%
  arrange(desc(visits))
```

### Example 3: Financial Analysis

```r
# Payment analysis by payer
healthyR_data %>%
  group_by(payer_grouping) %>%
  summarise(
    visits = n(),
    total_charges = sum(total_charge_amount),
    total_payments = sum(abs(total_payment_amount)),
    total_adjustments = sum(abs(total_adjustment_amount)),
    collection_rate = total_payments / total_charges * 100
  ) %>%
  arrange(desc(visits))
```

## Data Patterns

### Temporal Patterns

```r
library(lubridate)

# Monthly visit volume
healthyR_data %>%
  mutate(
    year_month = floor_date(visit_start_date_time, "month")
  ) %>%
  count(year_month) %>%
  arrange(year_month)
```

### Clinical Patterns

```r
# High-volume service lines
healthyR_data %>%
  count(service_line, ip_op_flag) %>%
  pivot_wider(names_from = ip_op_flag, values_from = n, values_fill = 0)
```

### Financial Patterns

```r
# Charge distribution by patient type
healthyR_data %>%
  group_by(ip_op_flag) %>%
  summarise(
    n = n(),
    mean = mean(total_charge_amount),
    median = median(total_charge_amount),
    sd = sd(total_charge_amount)
  )
```

## Important Notes

### Data Limitations

1. **Synthetic Data**: Not real patient data; patterns may differ from actual hospital data
2. **De-identified**: All patient identifiers are synthetic
3. **Incomplete Fields**: Some quality metrics (expected LOS, readmit expectation) are sparse
4. **Simplified**: Real hospital data would have many more variables

### Best Practices

1. **Always filter**: Use `filter()` to subset relevant records
2. **Handle NAs**: Check and handle missing values appropriately
3. **Convert dates**: Use lubridate for date manipulations
4. **Group wisely**: Consider ip_op_flag when analyzing metrics
5. **Validate results**: Cross-check calculations make sense

### Common Pitfalls

1. **Outpatient LOS**: length_of_stay = 0 for outpatients (not missing)
2. **Negative amounts**: Payments and adjustments are typically negative
3. **NA vs Zero**: Distinguish between missing data and true zeros
4. **Date formats**: Ensure proper datetime handling

## Related Documentation

- [Data Dictionary](Data-Dictionary.md) - Quick variable reference
- [Getting Started](Getting-Started.md) - Basic usage examples
- [Use Cases and Examples](Use-Cases-and-Examples.md) - Advanced analyses
- [Working with Financial Data](Working-with-Financial-Data.md) - Financial analysis deep dive

---

[← Back to Home](Home.md) | [Next: Data Dictionary →](Data-Dictionary.md)
