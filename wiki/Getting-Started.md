# Getting Started with healthyR.data

This guide will help you take your first steps with the healthyR.data package.

## Table of Contents

- [Your First Session](#your-first-session)
- [Loading the Package](#loading-the-package)
- [Understanding the Built-in Dataset](#understanding-the-built-in-dataset)
- [Basic Data Exploration](#basic-data-exploration)
- [Simple Analyses](#simple-analyses)
- [Accessing CMS Data](#accessing-cms-data)
- [Next Steps](#next-steps)

## Your First Session

### 1. Load Required Packages

```r
# Load healthyR.data
library(healthyR.data)

# Load companion packages for data manipulation
library(dplyr)
library(ggplot2)  # Optional, for visualization
```

### 2. Check Package Version

```r
# Verify installation
packageVersion("healthyR.data")

# View package information
packageDescription("healthyR.data")
```

## Loading the Package

The healthyR.data package automatically loads the main dataset when you load the package.

```r
# Load the package
library(healthyR.data)

# The healthyR_data dataset is now available
# No need to call data(healthyR_data) explicitly
```

## Understanding the Built-in Dataset

### Dataset Overview

The `healthyR_data` dataset contains:
- **187,721 rows** (hospital visits)
- **17 columns** (variables)
- Synthetic/de-identified data for safe use

### Quick Look at the Data

```r
# View first few rows
head(healthyR_data)

# View structure
str(healthyR_data)

# Get summary statistics
summary(healthyR_data)

# Check dimensions
dim(healthyR_data)
```

### Column Overview

```r
# List all column names
names(healthyR_data)

# View with dplyr's glimpse for better formatting
library(dplyr)
glimpse(healthyR_data)
```

Expected output:
```
Rows: 187,721
Columns: 17
$ mrn                      <chr> "86069614", "60856527", ...
$ visit_id                 <chr> "3519249247", "3602225015", ...
$ visit_start_date_time    <dttm> 2010-01-04 05:00:00, ...
$ visit_end_date_time      <dttm> 2010-01-04, ...
$ total_charge_amount      <dbl> 25983.88, 22774.05, ...
$ total_amount_due         <dbl> 0.00, 0.00, ...
$ total_adjustment_amount  <dbl> -20799.61, -12978.37, ...
$ payer_grouping           <chr> "Medicare B", "Medicare HMO", ...
$ total_payment_amount     <dbl> -5184.27, -9795.68, ...
$ ip_op_flag               <chr> "O", "O", ...
$ service_line             <chr> "General Outpatient", ...
$ length_of_stay           <dbl> 0, 0, ...
$ expected_length_of_stay  <lgl> NA, NA, ...
$ length_of_stay_threshold <lgl> NA, NA, ...
$ los_outlier_flag         <dbl> 0, 0, ...
$ readmit_flag             <dbl> 0, 0, ...
$ readmit_expectation      <lgl> NA, NA, ...
```

## Basic Data Exploration

### Explore Patient Types

```r
# Count inpatient vs outpatient visits
healthyR_data %>%
  count(ip_op_flag) %>%
  mutate(percentage = n / sum(n) * 100)
```

### Explore Service Lines

```r
# Top 10 service lines
healthyR_data %>%
  count(service_line) %>%
  arrange(desc(n)) %>%
  head(10)
```

### Explore Payer Types

```r
# Distribution of payer groupings
healthyR_data %>%
  count(payer_grouping) %>%
  arrange(desc(n))
```

## Simple Analyses

### Example 1: Average Charges by Patient Type

```r
# Calculate average charges
healthyR_data %>%
  group_by(ip_op_flag) %>%
  summarise(
    visits = n(),
    avg_charge = mean(total_charge_amount, na.rm = TRUE),
    median_charge = median(total_charge_amount, na.rm = TRUE),
    .groups = "drop"
  )
```

### Example 2: Service Line Analysis for Inpatients

```r
# Analyze inpatient service lines
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    total_visits = n(),
    avg_los = mean(length_of_stay, na.rm = TRUE),
    avg_charge = mean(total_charge_amount, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(total_visits)) %>%
  head(10)
```

### Example 3: Payer Mix Analysis

```r
# Analyze charges and payments by payer
healthyR_data %>%
  group_by(payer_grouping) %>%
  summarise(
    visits = n(),
    total_charges = sum(total_charge_amount, na.rm = TRUE),
    total_payments = sum(abs(total_payment_amount), na.rm = TRUE),
    avg_payment_rate = mean(
      abs(total_payment_amount) / total_charge_amount, 
      na.rm = TRUE
    ) * 100,
    .groups = "drop"
  ) %>%
  arrange(desc(visits))
```

### Example 4: Quality Metrics

```r
# Calculate readmission and outlier rates
healthyR_data %>%
  filter(ip_op_flag == "I") %>%  # Inpatient only
  summarise(
    total_inpatient_visits = n(),
    readmission_rate = mean(readmit_flag, na.rm = TRUE) * 100,
    los_outlier_rate = mean(los_outlier_flag, na.rm = TRUE) * 100,
    avg_length_of_stay = mean(length_of_stay, na.rm = TRUE)
  )
```

## Accessing CMS Data

### Search for Available Datasets

```r
# Search for hospital quality data
cms_meta <- get_cms_meta_data(
  .keyword = "quality",
  .data_version = "current"
)

# View available datasets
cms_meta %>%
  select(title, modified, media_type) %>%
  head(10)
```

### Fetch Specific CMS Data

```r
# Get metadata for a specific dataset
readmission_meta <- get_cms_meta_data(
  .keyword = "readmission",
  .data_version = "current",
  .media_type = "API"
)

# Extract the data link
data_link <- readmission_meta$data_link[1]

# Fetch the actual data
readmission_data <- fetch_cms_data(data_link)

# Explore the data
glimpse(readmission_data)
```

### Download Complete Hospital Data

```r
# Download all current hospital data files
# Note: This will prompt you to select a directory
all_hosp_data <- current_hosp_data()

# View what was downloaded
names(all_hosp_data)

# The result is a list of tibbles
# Extract specific dataset
first_dataset <- all_hosp_data[[1]]
glimpse(first_dataset)
```

## Common Workflows

### Workflow 1: Financial Analysis

```r
# Complete financial analysis workflow
financial_summary <- healthyR_data %>%
  group_by(payer_grouping, ip_op_flag) %>%
  summarise(
    visits = n(),
    total_charges = sum(total_charge_amount),
    total_payments = sum(abs(total_payment_amount)),
    total_adjustments = sum(abs(total_adjustment_amount)),
    total_due = sum(total_amount_due),
    collection_rate = total_payments / total_charges * 100,
    .groups = "drop"
  ) %>%
  arrange(desc(visits))

# View results
print(financial_summary)
```

### Workflow 2: Quality Metrics Dashboard

```r
# Create quality metrics by service line
quality_metrics <- healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    total_visits = n(),
    avg_los = round(mean(length_of_stay, na.rm = TRUE), 2),
    los_outlier_rate = round(mean(los_outlier_flag, na.rm = TRUE) * 100, 2),
    readmission_rate = round(mean(readmit_flag, na.rm = TRUE) * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(total_visits))

# View top service lines
head(quality_metrics, 15)
```

### Workflow 3: Time Series Analysis

```r
# Analyze trends over time
library(lubridate)

monthly_trends <- healthyR_data %>%
  mutate(
    month = floor_date(visit_start_date_time, "month")
  ) %>%
  group_by(month, ip_op_flag) %>%
  summarise(
    visits = n(),
    avg_charge = mean(total_charge_amount),
    .groups = "drop"
  ) %>%
  arrange(month)

# View trends
head(monthly_trends, 20)
```

## Best Practices

### 1. Always Check Data Quality

```r
# Check for missing values
healthyR_data %>%
  summarise(across(everything(), ~ sum(is.na(.))))

# Check for duplicates
healthyR_data %>%
  group_by(visit_id) %>%
  filter(n() > 1) %>%
  nrow()
```

### 2. Use Filters Wisely

```r
# Filter for relevant data before analysis
inpatient_medical <- healthyR_data %>%
  filter(
    ip_op_flag == "I",
    service_line == "Medical",
    total_charge_amount > 0
  )
```

### 3. Handle Dates Properly

```r
# Convert and work with dates
healthyR_data %>%
  mutate(
    visit_date = as.Date(visit_start_date_time),
    visit_year = year(visit_start_date_time),
    visit_month = month(visit_start_date_time, label = TRUE)
  )
```

### 4. Save Your Results

```r
# Save analysis results
summary_results <- healthyR_data %>%
  group_by(service_line) %>%
  summarise(visits = n())

# Export to CSV
write.csv(summary_results, "service_line_summary.csv", row.names = FALSE)

# Save as RDS for R-specific format
saveRDS(summary_results, "service_line_summary.rds")
```

## Next Steps

Now that you're familiar with the basics, explore these topics:

1. **[Built-in Dataset](Built-in-Dataset.md)** - Detailed information about healthyR_data
2. **[Data Dictionary](Data-Dictionary.md)** - Complete variable reference
3. **[CMS Data Access](CMS-Data-Access.md)** - Working with live CMS data
4. **[Use Cases and Examples](Use-Cases-and-Examples.md)** - Real-world applications
5. **[Function Reference](Function-Reference.md)** - Complete function documentation

## Quick Reference Card

```r
# Essential commands for daily use

# Load package
library(healthyR.data)

# View data
glimpse(healthyR_data)

# Count records
healthyR_data %>% count(variable_name)

# Filter and analyze
healthyR_data %>%
  filter(condition) %>%
  group_by(grouping_variable) %>%
  summarise(metric = function(variable))

# Search CMS data
get_cms_meta_data(.keyword = "search_term")

# Fetch CMS data
fetch_cms_data(data_link)
```

## Getting Help

- Run `?healthyR_data` for dataset documentation
- Run `?function_name` for function help
- Visit the [FAQ](FAQ.md) for common questions
- Check [Troubleshooting](Troubleshooting.md) for issues

---

[← Back to Home](Home.md) | [Next: Built-in Dataset →](Built-in-Dataset.md)
