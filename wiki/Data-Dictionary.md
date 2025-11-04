# Data Dictionary

Quick reference guide for all variables in the `healthyR_data` dataset.

## Quick Reference Table

| Variable | Type | Description | Example | Notes |
|----------|------|-------------|---------|-------|
| **mrn** | Character | Medical Record Number | "86069614" | Patient identifier (not unique per row) |
| **visit_id** | Character | Unique visit identifier | "3519249247" | Primary key |
| **visit_start_date_time** | POSIXct | Visit start datetime | 2010-01-04 05:00:00 | UTC timezone |
| **visit_end_date_time** | POSIXct | Visit end datetime | 2010-01-04 | Can be same day for outpatients |
| **total_charge_amount** | Numeric | Total charges (USD) | 25983.88 | Gross charges |
| **total_amount_due** | Numeric | Amount still owed (USD) | 0.00 | Often zero |
| **total_adjustment_amount** | Numeric | Total adjustments (USD) | -20799.61 | Usually negative |
| **payer_grouping** | Character | Insurance type | "Medicare B" | Multiple categories |
| **total_payment_amount** | Numeric | Total payments (USD) | -5184.27 | Usually negative |
| **ip_op_flag** | Character | Patient type | "I" or "O" | I=Inpatient, O=Outpatient |
| **service_line** | Character | Clinical service | "Medical" | Hospital service line |
| **length_of_stay** | Numeric | Days admitted | 5 | 0 for outpatients |
| **expected_length_of_stay** | Logical | Expected LOS | NA | Mostly missing |
| **length_of_stay_threshold** | Logical | LOS outlier threshold | NA | Mostly missing |
| **los_outlier_flag** | Numeric | LOS outlier indicator | 0 or 1 | Binary flag |
| **readmit_flag** | Numeric | 30-day readmission | 0 or 1 | Binary flag |
| **readmit_expectation** | Logical | Expected readmit rate | NA | Mostly missing |

## Detailed Variable Descriptions

### Patient Identifiers

#### mrn
- **Full Name**: Medical Record Number
- **Purpose**: Unique patient identifier
- **Data Type**: Character (8 digits)
- **Cardinality**: ~100,000+ unique patients
- **Sample Values**: "86069614", "60856527", "80673110"
- **Usage**: Link multiple visits for same patient
- **Note**: One patient can have multiple visits

```r
# Count visits per patient
healthyR_data %>%
  count(mrn) %>%
  arrange(desc(n))
```

#### visit_id
- **Full Name**: Visit Identifier
- **Purpose**: Unique identifier for each hospital visit
- **Data Type**: Character (10 digits)
- **Cardinality**: 187,721 (one per row)
- **Sample Values**: "3519249247", "3602225015"
- **Usage**: Primary key for the dataset
- **Note**: Every visit has unique ID

```r
# Verify uniqueness
n_distinct(healthyR_data$visit_id) == nrow(healthyR_data)
```

### Temporal Variables

#### visit_start_date_time
- **Purpose**: When the visit began
- **Data Type**: POSIXct datetime
- **Format**: YYYY-MM-DD HH:MM:SS
- **Range**: 2010-01-04 to 2020-12-31
- **Timezone**: UTC
- **Missing**: None
- **Usage**: Time series analysis, trend identification

```r
# Extract date components
library(lubridate)
healthyR_data %>%
  mutate(
    year = year(visit_start_date_time),
    month = month(visit_start_date_time, label = TRUE),
    day_of_week = wday(visit_start_date_time, label = TRUE),
    hour = hour(visit_start_date_time)
  )
```

#### visit_end_date_time
- **Purpose**: When the visit ended
- **Data Type**: POSIXct datetime
- **Format**: YYYY-MM-DD HH:MM:SS
- **Missing**: None
- **Note**: For outpatients, often same date as start
- **Usage**: Calculate visit duration

```r
# Calculate visit duration
healthyR_data %>%
  mutate(
    visit_duration_hours = as.numeric(
      difftime(visit_end_date_time, visit_start_date_time, units = "hours")
    )
  )
```

### Financial Variables

#### total_charge_amount
- **Purpose**: Gross charges for the visit
- **Data Type**: Numeric (double)
- **Units**: US Dollars
- **Range**: $0 to $500,000+
- **Missing**: None
- **Mean**: ~$12,000
- **Median**: ~$6,000
- **Note**: Charges before any adjustments or payments

```r
# Charge statistics
summary(healthyR_data$total_charge_amount)
```

#### total_amount_due
- **Purpose**: Outstanding balance still owed
- **Data Type**: Numeric (double)
- **Units**: US Dollars
- **Range**: $0 to several thousand
- **Missing**: None
- **Typical**: Often $0 (fully paid)
- **Usage**: Accounts receivable analysis

```r
# Accounts with balance
healthyR_data %>%
  filter(total_amount_due > 0) %>%
  summarise(
    count = n(),
    total_due = sum(total_amount_due),
    avg_due = mean(total_amount_due)
  )
```

#### total_adjustment_amount
- **Purpose**: Write-offs and contractual adjustments
- **Data Type**: Numeric (double)
- **Units**: US Dollars
- **Sign**: Typically negative (reduces charges)
- **Missing**: None
- **Types**: Contractual adjustments, write-offs, discounts
- **Usage**: Calculate net revenue

```r
# Adjustment rate
healthyR_data %>%
  mutate(
    adj_rate = abs(total_adjustment_amount) / total_charge_amount * 100
  ) %>%
  summarise(mean_adj_rate = mean(adj_rate, na.rm = TRUE))
```

#### total_payment_amount
- **Purpose**: Total payments received
- **Data Type**: Numeric (double)
- **Units**: US Dollars
- **Sign**: Typically negative (credits to account)
- **Missing**: None
- **Sources**: Insurance payments, patient payments, other
- **Usage**: Revenue analysis, collection rates

```r
# Collection rate
healthyR_data %>%
  mutate(
    collection_rate = abs(total_payment_amount) / total_charge_amount * 100
  ) %>%
  group_by(payer_grouping) %>%
  summarise(avg_collection_rate = mean(collection_rate, na.rm = TRUE))
```

### Classification Variables

#### payer_grouping
- **Purpose**: Insurance classification
- **Data Type**: Character (categorical)
- **Categories**: Multiple insurance types
- **Missing**: None
- **Common Values**:
  - Medicare B (largest group)
  - HMO
  - Medicare HMO
  - Blue Cross
  - Self Pay
  - Commercial
  - PPO
  - Medicaid
  - DHCP
  - Medicare A
- **Usage**: Payer mix analysis, reimbursement analysis

```r
# Payer distribution
healthyR_data %>%
  count(payer_grouping) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  arrange(desc(n))
```

#### ip_op_flag
- **Purpose**: Patient type indicator
- **Data Type**: Character (binary)
- **Values**:
  - "I" = Inpatient (admitted to hospital)
  - "O" = Outpatient (not admitted)
- **Missing**: None
- **Distribution**: ~57% Inpatient, ~43% Outpatient
- **Usage**: Separate inpatient and outpatient analyses

```r
# Distribution
healthyR_data %>%
  count(ip_op_flag) %>%
  mutate(percentage = n / sum(n) * 100)
```

#### service_line
- **Purpose**: Clinical service or diagnosis category
- **Data Type**: Character (categorical)
- **Categories**: Multiple clinical services
- **Missing**: None
- **Top Values**:
  - Medical (largest for inpatients)
  - General Outpatient (largest for outpatients)
  - Surgical
  - COPD
  - CHF
  - Pneumonia
  - Cellulitis
  - Chest Pain
- **Usage**: Clinical analysis, service line performance

```r
# Service line by patient type
healthyR_data %>%
  count(ip_op_flag, service_line) %>%
  group_by(ip_op_flag) %>%
  slice_max(n, n = 5)
```

### Clinical Variables

#### length_of_stay
- **Purpose**: Number of days patient was admitted
- **Data Type**: Numeric (double)
- **Units**: Days
- **Range**: 0 (outpatients) to 100+ days
- **Missing**: None
- **Zero**: Normal for outpatients
- **Mean (Inpatients)**: ~5 days
- **Median (Inpatients)**: ~4 days
- **Usage**: Efficiency analysis, capacity planning

```r
# LOS statistics by service line (inpatients only)
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    avg_los = mean(length_of_stay),
    median_los = median(length_of_stay),
    max_los = max(length_of_stay)
  ) %>%
  arrange(desc(avg_los))
```

#### expected_length_of_stay
- **Purpose**: Benchmark expected LOS
- **Data Type**: Logical
- **Missing**: Most records (NA)
- **Usage**: Compare actual vs expected
- **Note**: Sparse data limits usefulness

#### length_of_stay_threshold
- **Purpose**: Threshold defining LOS outlier
- **Data Type**: Logical
- **Missing**: Most records (NA)
- **Usage**: Outlier determination
- **Note**: Sparse data

### Quality Indicators

#### los_outlier_flag
- **Purpose**: Indicates if LOS exceeded threshold
- **Data Type**: Numeric (binary)
- **Values**:
  - 0 = Normal length of stay
  - 1 = Outlier (exceeded threshold)
- **Missing**: None
- **Rate**: ~4-8% for inpatients
- **Usage**: Quality monitoring, case management

```r
# Outlier rate by service line
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    total_visits = n(),
    outlier_count = sum(los_outlier_flag),
    outlier_rate = mean(los_outlier_flag) * 100
  ) %>%
  arrange(desc(outlier_rate))
```

#### readmit_flag
- **Purpose**: Indicates 30-day readmission
- **Data Type**: Numeric (binary)
- **Values**:
  - 0 = Not readmitted within 30 days
  - 1 = Readmitted within 30 days
- **Missing**: None
- **Rate**: ~8-12% for inpatients
- **Usage**: Quality measurement, care coordination

```r
# Readmission rate analysis
healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    total_discharges = n(),
    readmissions = sum(readmit_flag),
    readmit_rate = mean(readmit_flag) * 100
  ) %>%
  arrange(desc(readmit_rate))
```

#### readmit_expectation
- **Purpose**: Expected readmission rate from benchmark
- **Data Type**: Logical
- **Missing**: Most records (NA)
- **Usage**: Compare actual vs expected readmissions
- **Note**: Sparse data

## Data Relationships

### Primary Key
- **visit_id**: Uniquely identifies each record

### Foreign Keys (Conceptual)
- **mrn**: Links visits for the same patient
- No formal foreign key constraints

### Common Grouping Variables
- **ip_op_flag**: Separate inpatient/outpatient
- **service_line**: Clinical grouping
- **payer_grouping**: Financial grouping
- **visit_start_date_time**: Temporal grouping

## Value Ranges and Constraints

| Variable | Min | Max | Typical | Special Values |
|----------|-----|-----|---------|----------------|
| total_charge_amount | $0 | $500K+ | $5K-$15K | None |
| total_amount_due | $0 | $50K+ | $0 | Often zero |
| total_adjustment_amount | -$400K | $0 | -$5K to -$10K | Negative |
| total_payment_amount | -$300K | $0 | -$2K to -$8K | Negative |
| length_of_stay | 0 | 100+ | 4-5 (IP) | 0 for OP |
| los_outlier_flag | 0 | 1 | 0 | Binary |
| readmit_flag | 0 | 1 | 0 | Binary |

## Missing Data Patterns

| Variable | Missing Rate | Notes |
|----------|--------------|-------|
| Core fields (IDs, dates, amounts) | 0% | Complete |
| expected_length_of_stay | >95% | Sparse |
| length_of_stay_threshold | >95% | Sparse |
| readmit_expectation | >95% | Sparse |

## Common Calculations

### Financial Metrics

```r
# Net revenue
healthyR_data %>%
  mutate(
    net_revenue = total_charge_amount + total_adjustment_amount + total_payment_amount
  )

# Collection rate
healthyR_data %>%
  mutate(
    collection_rate = abs(total_payment_amount) / total_charge_amount * 100
  )

# Adjustment rate
healthyR_data %>%
  mutate(
    adjustment_rate = abs(total_adjustment_amount) / total_charge_amount * 100
  )
```

### Clinical Metrics

```r
# LOS variance (actual vs expected)
healthyR_data %>%
  filter(!is.na(expected_length_of_stay)) %>%
  mutate(
    los_variance = length_of_stay - expected_length_of_stay
  )

# Average daily charge
healthyR_data %>%
  filter(ip_op_flag == "I", length_of_stay > 0) %>%
  mutate(
    daily_charge = total_charge_amount / length_of_stay
  )
```

## Data Quality Checks

```r
# Check for duplicates
healthyR_data %>%
  group_by(visit_id) %>%
  filter(n() > 1)

# Check for negative charges
healthyR_data %>%
  filter(total_charge_amount < 0)

# Check LOS consistency
healthyR_data %>%
  filter(ip_op_flag == "O", length_of_stay > 0)

# Validate financial relationships
healthyR_data %>%
  mutate(
    balance_check = total_charge_amount + 
                    total_adjustment_amount + 
                    total_payment_amount - 
                    total_amount_due
  ) %>%
  filter(abs(balance_check) > 0.01)  # Allow small rounding errors
```

## Related Documentation

- [Built-in Dataset](Built-in-Dataset.md) - Comprehensive dataset documentation
- [Getting Started](Getting-Started.md) - Basic usage
- [Use Cases and Examples](Use-Cases-and-Examples.md) - Applied examples

---

[← Back to Home](Home.md) | [Built-in Dataset](Built-in-Dataset.md)
