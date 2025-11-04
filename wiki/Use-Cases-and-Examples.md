# Use Cases and Examples

Real-world applications and comprehensive examples for using healthyR.data in healthcare analytics.

## Table of Contents

- [Overview](#overview)
- [Healthcare Analytics](#healthcare-analytics)
- [Quality Improvement](#quality-improvement)
- [Financial Analysis](#financial-analysis)
- [Research and Education](#research-and-education)
- [Benchmarking](#benchmarking)
- [Package Development](#package-development)

## Overview

This guide provides practical use cases and complete working examples for the healthyR.data package across various healthcare analytics scenarios.

## Healthcare Analytics

### Use Case 1: Emergency Department Analysis

**Goal**: Analyze ED visit patterns and costs

```r
library(healthyR.data)
library(dplyr)
library(lubridate)
library(ggplot2)

# Load data
df <- healthyR_data

# Filter ED visits (typically short outpatient stays)
ed_visits <- df %>%
  filter(
    ip_op_flag == "O",
    service_line %in% c("Chest Pain", "Emergency Department", "General Outpatient")
  )

# Analyze by time of day
ed_analysis <- ed_visits %>%
  mutate(
    hour = hour(visit_start_date_time),
    day_of_week = wday(visit_start_date_time, label = TRUE),
    time_period = case_when(
      hour >= 6 & hour < 12 ~ "Morning",
      hour >= 12 & hour < 18 ~ "Afternoon",
      hour >= 18 & hour < 24 ~ "Evening",
      TRUE ~ "Night"
    )
  ) %>%
  group_by(time_period, day_of_week) %>%
  summarise(
    visits = n(),
    avg_charge = mean(total_charge_amount),
    .groups = "drop"
  )

# Visualize patterns
ed_analysis %>%
  ggplot(aes(x = day_of_week, y = visits, fill = time_period)) +
  geom_col(position = "dodge") +
  labs(
    title = "ED Visit Patterns by Day and Time",
    x = "Day of Week",
    y = "Number of Visits",
    fill = "Time Period"
  ) +
  theme_minimal()
```

### Use Case 2: Service Line Performance

**Goal**: Compare performance across service lines

```r
# Comprehensive service line analysis
service_performance <- df %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    # Volume metrics
    total_admissions = n(),
    unique_patients = n_distinct(mrn),
    
    # Length of stay
    avg_los = mean(length_of_stay, na.rm = TRUE),
    median_los = median(length_of_stay, na.rm = TRUE),
    
    # Financial metrics
    avg_charge = mean(total_charge_amount),
    total_revenue = sum(abs(total_payment_amount)),
    
    # Quality metrics
    los_outlier_rate = mean(los_outlier_flag, na.rm = TRUE) * 100,
    readmit_rate = mean(readmit_flag, na.rm = TRUE) * 100,
    
    .groups = "drop"
  ) %>%
  arrange(desc(total_admissions))

# Display top service lines
print(service_performance, n = 15)

# Identify high-risk service lines
high_risk <- service_performance %>%
  filter(readmit_rate > 12 | los_outlier_rate > 8) %>%
  arrange(desc(readmit_rate))

print(high_risk)
```

### Use Case 3: Patient Journey Analysis

**Goal**: Track patient encounters over time

```r
# Identify patients with multiple visits
frequent_patients <- df %>%
  group_by(mrn) %>%
  summarise(
    visit_count = n(),
    first_visit = min(visit_start_date_time),
    last_visit = max(visit_start_date_time),
    days_span = as.numeric(difftime(last_visit, first_visit, units = "days")),
    total_charges = sum(total_charge_amount),
    readmissions = sum(readmit_flag)
  ) %>%
  filter(visit_count >= 3) %>%
  arrange(desc(visit_count))

# Analyze visit patterns for frequent users
visit_patterns <- df %>%
  semi_join(frequent_patients %>% filter(visit_count >= 5), by = "mrn") %>%
  arrange(mrn, visit_start_date_time) %>%
  group_by(mrn) %>%
  mutate(
    visit_number = row_number(),
    days_since_last = as.numeric(
      difftime(visit_start_date_time, lag(visit_start_date_time), units = "days")
    )
  )

# Summarize re-admission patterns
readmit_patterns <- visit_patterns %>%
  filter(!is.na(days_since_last)) %>%
  group_by(readmit_flag) %>%
  summarise(
    avg_days_between = mean(days_since_last, na.rm = TRUE),
    median_days_between = median(days_since_last, na.rm = TRUE)
  )
```

## Quality Improvement

### Use Case 4: Readmission Reduction Initiative

**Goal**: Identify opportunities to reduce readmissions

```r
# Analyze readmissions by service line
readmit_analysis <- df %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    total_discharges = n(),
    readmissions = sum(readmit_flag),
    readmit_rate = mean(readmit_flag) * 100,
    avg_los = mean(length_of_stay),
    avg_los_readmit = mean(length_of_stay[readmit_flag == 1]),
    avg_los_no_readmit = mean(length_of_stay[readmit_flag == 0]),
    .groups = "drop"
  ) %>%
  filter(total_discharges >= 100) %>%
  arrange(desc(readmit_rate))

# Top opportunities (high volume + high rate)
opportunities <- readmit_analysis %>%
  mutate(
    opportunity_score = (readmit_rate / 100) * total_discharges
  ) %>%
  arrange(desc(opportunity_score))

print(opportunities, n = 10)

# Analyze by payer to identify socioeconomic factors
readmit_by_payer <- df %>%
  filter(ip_op_flag == "I") %>%
  group_by(payer_grouping) %>%
  summarise(
    discharges = n(),
    readmit_rate = mean(readmit_flag) * 100,
    .groups = "drop"
  ) %>%
  arrange(desc(readmit_rate))
```

### Use Case 5: Length of Stay Optimization

**Goal**: Identify LOS outliers and improvement opportunities

```r
# Analyze LOS outliers
los_analysis <- df %>%
  filter(
    ip_op_flag == "I",
    length_of_stay > 0
  ) %>%
  group_by(service_line) %>%
  summarise(
    admissions = n(),
    mean_los = mean(length_of_stay),
    median_los = median(length_of_stay),
    p90_los = quantile(length_of_stay, 0.90),
    outliers = sum(los_outlier_flag),
    outlier_rate = mean(los_outlier_flag) * 100,
    outlier_excess_days = sum(
      (length_of_stay - median_los) * los_outlier_flag
    ),
    .groups = "drop"
  ) %>%
  filter(admissions >= 50) %>%
  arrange(desc(outlier_excess_days))

# Calculate potential savings
los_analysis <- los_analysis %>%
  mutate(
    potential_reduction_days = outlier_excess_days * 0.20,  # 20% improvement
    est_cost_per_day = 2000,
    potential_savings = potential_reduction_days * est_cost_per_day
  )

print(los_analysis, n = 15)
```

## Financial Analysis

### Use Case 6: Revenue Cycle Analysis

**Goal**: Analyze payment patterns and collection rates

```r
# Comprehensive revenue cycle metrics
revenue_analysis <- df %>%
  group_by(payer_grouping, ip_op_flag) %>%
  summarise(
    # Volume
    encounters = n(),
    
    # Financial metrics
    gross_charges = sum(total_charge_amount),
    total_adjustments = sum(abs(total_adjustment_amount)),
    total_payments = sum(abs(total_payment_amount)),
    total_due = sum(total_amount_due),
    
    # Rates
    adjustment_rate = total_adjustments / gross_charges * 100,
    collection_rate = total_payments / gross_charges * 100,
    
    # Per encounter
    avg_charge = mean(total_charge_amount),
    avg_payment = mean(abs(total_payment_amount)),
    
    .groups = "drop"
  ) %>%
  arrange(desc(encounters))

# Identify collection issues
collection_issues <- revenue_analysis %>%
  filter(collection_rate < 30 | total_due > 100000) %>%
  arrange(desc(total_due))

# Calculate net revenue
net_revenue <- revenue_analysis %>%
  mutate(
    net_revenue = gross_charges - total_adjustments,
    net_collection_rate = total_payments / net_revenue * 100
  )
```

### Use Case 7: Payer Mix Optimization

**Goal**: Understand payer mix and reimbursement patterns

```r
# Payer mix analysis
payer_mix <- df %>%
  group_by(payer_grouping) %>%
  summarise(
    volume = n(),
    volume_pct = n() / nrow(df) * 100,
    avg_charge = mean(total_charge_amount),
    avg_payment = mean(abs(total_payment_amount)),
    payment_to_charge_ratio = avg_payment / avg_charge * 100,
    total_revenue = sum(abs(total_payment_amount)),
    revenue_pct = total_revenue / sum(df$total_payment_amount %>% abs()) * 100,
    .groups = "drop"
  ) %>%
  arrange(desc(volume))

# Visualize payer mix
library(ggplot2)

payer_mix %>%
  top_n(10, volume) %>%
  ggplot(aes(x = reorder(payer_grouping, volume), y = volume)) +
  geom_col(aes(fill = payment_to_charge_ratio)) +
  coord_flip() +
  scale_fill_gradient(low = "red", high = "green") +
  labs(
    title = "Top 10 Payers by Volume",
    subtitle = "Colored by Payment-to-Charge Ratio",
    x = "Payer",
    y = "Number of Encounters",
    fill = "Payment Rate %"
  ) +
  theme_minimal()
```

### Use Case 8: Charge Master Analysis

**Goal**: Analyze charge patterns across services

```r
# Charge analysis by service line
charge_analysis <- df %>%
  group_by(service_line, ip_op_flag) %>%
  summarise(
    encounters = n(),
    # Charge metrics
    avg_charge = mean(total_charge_amount),
    median_charge = median(total_charge_amount),
    sd_charge = sd(total_charge_amount),
    cv_charge = sd_charge / avg_charge,  # Coefficient of variation
    # Payment metrics
    avg_payment = mean(abs(total_payment_amount)),
    # Efficiency
    payment_variance = sd(abs(total_payment_amount)) / avg_payment,
    .groups = "drop"
  ) %>%
  arrange(desc(encounters))

# Identify high variability services
high_variance <- charge_analysis %>%
  filter(encounters >= 100, cv_charge > 0.5) %>%
  arrange(desc(cv_charge))
```

## Research and Education

### Use Case 9: Teaching Healthcare Analytics

**Goal**: Create educational examples for students

```r
# Example 1: Introduction to healthcare data
intro_analysis <- df %>%
  summarise(
    total_encounters = n(),
    unique_patients = n_distinct(mrn),
    date_range = paste(
      as.Date(min(visit_start_date_time)), 
      "to", 
      as.Date(max(visit_start_date_time))
    ),
    inpatient_pct = mean(ip_op_flag == "I") * 100,
    outpatient_pct = mean(ip_op_flag == "O") * 100,
    avg_charge = mean(total_charge_amount),
    total_revenue = sum(abs(total_payment_amount))
  )

# Example 2: Statistical analysis - hypothesis testing
# Test if charges differ by patient type
t_test_result <- t.test(
  total_charge_amount ~ ip_op_flag,
  data = df
)

# Example 3: Predictive modeling prep
model_data <- df %>%
  filter(ip_op_flag == "I") %>%
  select(
    readmit_flag,
    length_of_stay,
    total_charge_amount,
    payer_grouping,
    service_line
  ) %>%
  na.omit()

# Simple logistic regression
model <- glm(
  readmit_flag ~ length_of_stay + total_charge_amount + payer_grouping,
  data = model_data,
  family = binomial
)

summary(model)
```

### Use Case 10: Research Data Preparation

**Goal**: Prepare data for research analysis

```r
# Create research dataset with derived variables
research_data <- df %>%
  filter(ip_op_flag == "I") %>%
  mutate(
    # Temporal variables
    year = year(visit_start_date_time),
    quarter = quarter(visit_start_date_time),
    month = month(visit_start_date_time),
    
    # Financial derived variables
    net_revenue = total_charge_amount + total_adjustment_amount + total_payment_amount,
    payment_rate = abs(total_payment_amount) / total_charge_amount * 100,
    
    # Clinical categories
    los_category = case_when(
      length_of_stay <= 2 ~ "Short",
      length_of_stay <= 5 ~ "Medium",
      length_of_stay <= 10 ~ "Long",
      TRUE ~ "Extended"
    ),
    
    # Service grouping
    service_group = case_when(
      service_line %in% c("Medical", "Surgical") ~ "Medical/Surgical",
      service_line %in% c("COPD", "CHF", "Pneumonia") ~ "Respiratory/Cardiac",
      TRUE ~ "Other"
    ),
    
    # Quality indicators
    quality_flag = ifelse(
      los_outlier_flag == 0 & readmit_flag == 0,
      "Good",
      "Needs Improvement"
    )
  )

# Summary statistics for publication
summary_table <- research_data %>%
  group_by(service_group) %>%
  summarise(
    n = n(),
    mean_los = mean(length_of_stay),
    sd_los = sd(length_of_stay),
    mean_charge = mean(total_charge_amount),
    sd_charge = sd(total_charge_amount),
    readmit_rate = mean(readmit_flag) * 100,
    .groups = "drop"
  )
```

## Benchmarking

### Use Case 11: Hospital Performance Benchmarking

**Goal**: Compare performance against CMS national data

```r
# Calculate internal metrics
internal_metrics <- df %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(
    admissions = n(),
    avg_los = mean(length_of_stay),
    readmit_rate = mean(readmit_flag) * 100,
    outlier_rate = mean(los_outlier_flag) * 100,
    .groups = "drop"
  )

# Fetch CMS comparison data
cms_meta <- get_cms_meta_data(
  .keyword = "readmission",
  .data_version = "current",
  .media_type = "API"
)

# Get national benchmarks
if (nrow(cms_meta) > 0) {
  national_data <- fetch_cms_data(cms_meta$data_link[1])
  
  # Calculate national averages
  national_benchmarks <- national_data %>%
    group_by(measure_id) %>%
    summarise(
      national_avg = mean(as.numeric(score), na.rm = TRUE)
    )
}

# Compare to benchmarks
comparison <- internal_metrics %>%
  mutate(
    performance_category = case_when(
      readmit_rate < 10 ~ "Above Average",
      readmit_rate < 12 ~ "Average",
      TRUE ~ "Below Average"
    )
  )
```

## Package Development

### Use Case 12: Testing Healthcare Analytics Functions

**Goal**: Use healthyR_data to test custom functions

```r
# Example: Create a function to calculate case mix
calculate_case_mix <- function(data) {
  data %>%
    group_by(service_line) %>%
    summarise(
      volume = n(),
      avg_los = mean(length_of_stay, na.rm = TRUE),
      avg_charge = mean(total_charge_amount, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    mutate(
      volume_pct = volume / sum(volume) * 100,
      charge_weight = avg_charge / mean(avg_charge)
    )
}

# Test the function
case_mix_result <- calculate_case_mix(healthyR_data)

# Validate results
stopifnot(
  sum(case_mix_result$volume_pct) > 99,  # Should sum to ~100%
  nrow(case_mix_result) > 0
)
```

## Related Documentation

- [Built-in Dataset](Built-in-Dataset.md) - Dataset details
- [CMS Data Access](CMS-Data-Access.md) - Working with CMS data
- [Function Reference](Function-Reference.md) - All functions
- [Getting Started](Getting-Started.md) - Basic examples

---

[← Back to Home](Home.md) | [Function Reference →](Function-Reference.md)
