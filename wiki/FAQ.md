# Frequently Asked Questions (FAQ)

Common questions and answers about the healthyR.data package.

## Table of Contents

- [General Questions](#general-questions)
- [Data Questions](#data-questions)
- [CMS Data Questions](#cms-data-questions)
- [Technical Questions](#technical-questions)
- [Usage Questions](#usage-questions)

## General Questions

### What is healthyR.data?

healthyR.data is an R package that provides:
1. A built-in synthetic healthcare administrative dataset (healthyR_data) with 187,721 records
2. Functions to access current CMS (Centers for Medicare & Medicaid Services) hospital data
3. Tools for healthcare analytics and research

### Who should use this package?

- Healthcare analysts and data scientists
- Health informatics students and educators
- Healthcare researchers
- R package developers building healthcare tools
- Quality improvement professionals
- Hospital administrators

### Is the data real?

The **built-in healthyR_data dataset** contains synthetic/de-identified data created for demonstration and testing purposes.

The **CMS data functions** provide access to real, publicly available CMS hospital data.

### What is the license?

MIT License - the package is free and open source. See [LICENSE.md](https://github.com/spsanderson/healthyR.data/blob/master/LICENSE.md) for details.

### How do I cite this package?

```r
citation("healthyR.data")
```

Or manually:
> Sanderson SP (2024). healthyR.data: Data Only Package to 'healthyR'. R package version 1.2.0.

## Data Questions

### How many records are in healthyR_data?

187,721 records (hospital visits) with 17 variables.

```r
dim(healthyR_data)
# [1] 187721     17
```

### What time period does the data cover?

The built-in data spans from January 2010 to December 2020.

```r
range(healthyR_data$visit_start_date_time)
```

### Can I use this data for publications?

Yes! The built-in data is synthetic and safe to use in:
- Research papers
- Educational materials
- Blog posts
- Presentations
- Package vignettes

Always cite the package appropriately.

### Is PHI (Protected Health Information) included?

No. The built-in healthyR_data contains NO real patient data. All identifiers are synthetic.

### Why are some variables mostly NA?

Some quality metric fields (like `expected_length_of_stay`, `readmit_expectation`) are sparse in the synthetic dataset to mimic real-world data where these benchmarks may not be available for all encounters.

### What's the difference between inpatient and outpatient?

- **Inpatient (I)**: Patient was formally admitted to the hospital, has length of stay > 0
- **Outpatient (O)**: Patient was not admitted, length of stay = 0, includes ED visits, procedures, observations

```r
healthyR_data %>%
  count(ip_op_flag)
```

### Why are financial amounts negative?

In healthcare accounting:
- **Charges** are positive (amount billed)
- **Payments** are typically negative (credits to account)
- **Adjustments** are typically negative (reductions to charges)

This follows standard accounting practices where debits and credits have opposite signs.

### What payer types are included?

```r
healthyR_data %>%
  count(payer_grouping) %>%
  arrange(desc(n))
```

Common payers include:
- Medicare B (largest)
- HMO
- Medicare HMO
- Blue Cross
- Self Pay
- Commercial
- PPO
- Medicaid

### How is readmission defined?

The `readmit_flag` indicates whether a patient was readmitted within 30 days of discharge. It's a binary flag (0 = no, 1 = yes).

## CMS Data Questions

### What CMS data can I access?

The package provides access to 20+ CMS hospital quality datasets including:
- Hospital Compare data
- HCAHPS (patient satisfaction)
- Healthcare-associated infections (HAI)
- Readmission rates
- Payment data
- Quality measures
- And more

See [CMS Data Access](CMS-Data-Access.md) for complete list.

### Is CMS data real?

Yes! When you use the CMS data functions, you're accessing real, publicly available data from CMS.

### How current is the CMS data?

CMS data is updated regularly (typically quarterly). Use `.data_version = "current"` to get the latest available data.

```r
cms_meta <- get_cms_meta_data(.data_version = "current")
```

Check the `modified` date in the metadata to see when specific datasets were last updated.

### Do I need an API key?

No! All CMS data accessible through this package is publicly available and does not require authentication.

### Can I download CMS data for offline use?

Yes! Use `current_hosp_data()` to download all current hospital data files, or `fetch_cms_data()` to get specific datasets and save them locally.

```r
# Fetch and save
cms_data <- fetch_cms_data(data_link)
saveRDS(cms_data, "cms_data.rds")

# Load later
cms_data <- readRDS("cms_data.rds")
```

### Why is CMS data download slow?

CMS datasets can be large (millions of records). Factors affecting speed:
- Dataset size
- Internet connection speed
- CMS server load
- Media type (API vs CSV)

**Tips**:
- Use `.media_type = "csv"` for large datasets
- Download once and cache locally
- Use `.data_sets` parameter to fetch only needed subsets

### Can I access historical CMS data?

Yes! Use `.data_version = "archive"` to access archived datasets.

```r
cms_archive <- get_cms_meta_data(.data_version = "archive")
```

## Technical Questions

### What R version do I need?

R >= 4.1.0

Check your version:
```r
R.version.string
```

### What packages does healthyR.data depend on?

Core dependencies:
- dplyr (data manipulation)
- rlang (language features)
- janitor (data cleaning)
- httr2 (HTTP requests)
- stringr (string operations)
- tidyr (data tidying)
- stats, utils (base R utilities)

### Can I use healthyR.data with tidyverse?

Absolutely! The package is designed to work seamlessly with tidyverse packages.

```r
library(healthyR.data)
library(tidyverse)

healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  group_by(service_line) %>%
  summarise(avg_los = mean(length_of_stay))
```

### Does it work with data.table?

Yes! Convert to data.table if desired:

```r
library(data.table)
dt <- as.data.table(healthyR_data)
```

### Can I use it in Shiny apps?

Yes! The built-in data and CMS functions work great in Shiny applications.

```r
library(shiny)
library(healthyR.data)

# Use in server function
server <- function(input, output) {
  output$table <- renderTable({
    healthyR_data %>%
      filter(service_line == input$service) %>%
      head(100)
  })
}
```

### Does it work with RMarkdown/Quarto?

Yes! Perfect for:
- Reports
- Dashboards
- Presentations
- Notebooks

### Can I use it in production?

The package is stable and suitable for production use. However:
- Built-in data is synthetic (for testing/development)
- CMS data fetching depends on internet connectivity
- Cache CMS data for production systems to avoid repeated API calls

## Usage Questions

### How do I load the data?

```r
library(healthyR.data)

# Data is automatically available
df <- healthyR_data
```

### How do I search for specific CMS datasets?

Use keywords:

```r
# Search by keyword
cms_meta <- get_cms_meta_data(.keyword = "readmission")

# Search by title
cms_meta <- get_cms_meta_data(.title = "Unplanned Hospital Visits")

# View results
cms_meta %>% select(title, modified)
```

### How do I fetch actual CMS data?

```r
# Step 1: Get metadata
cms_meta <- get_cms_meta_data(
  .keyword = "quality",
  .media_type = "API"
)

# Step 2: Extract link
data_link <- cms_meta$data_link[1]

# Step 3: Fetch data
data <- fetch_cms_data(data_link)
```

### Can I filter the built-in data?

Yes! Use standard dplyr verbs:

```r
# Filter for inpatients only
inpatients <- healthyR_data %>%
  filter(ip_op_flag == "I")

# Filter for specific service line
medical <- healthyR_data %>%
  filter(service_line == "Medical")

# Multiple conditions
recent_readmits <- healthyR_data %>%
  filter(
    ip_op_flag == "I",
    readmit_flag == 1,
    year(visit_start_date_time) >= 2018
  )
```

### How do I calculate custom metrics?

Use dplyr's `mutate()` and `summarise()`:

```r
# Calculate collection rate
healthyR_data %>%
  mutate(
    collection_rate = abs(total_payment_amount) / total_charge_amount * 100
  )

# Calculate summary statistics
healthyR_data %>%
  group_by(service_line) %>%
  summarise(
    avg_los = mean(length_of_stay),
    readmit_rate = mean(readmit_flag) * 100
  )
```

### Can I export results?

Yes! Multiple options:

```r
# CSV
write.csv(results, "results.csv", row.names = FALSE)

# Excel (requires openxlsx or writexl)
library(writexl)
write_xlsx(results, "results.xlsx")

# RDS (R-specific format)
saveRDS(results, "results.rds")
```

### How do I join with my own data?

Use dplyr joins:

```r
# Assuming your data has a common key
my_data <- read.csv("my_hospital_data.csv")

combined <- healthyR_data %>%
  inner_join(my_data, by = c("visit_id" = "encounter_id"))
```

### Can I use SQL with this data?

Yes! Use sqldf package:

```r
library(sqldf)

result <- sqldf("
  SELECT service_line, 
         COUNT(*) as visits,
         AVG(length_of_stay) as avg_los
  FROM healthyR_data
  WHERE ip_op_flag = 'I'
  GROUP BY service_line
")
```

### How do I create visualizations?

Use ggplot2:

```r
library(ggplot2)

# Bar chart
healthyR_data %>%
  count(service_line) %>%
  top_n(10, n) %>%
  ggplot(aes(x = reorder(service_line, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 10 Service Lines", x = "", y = "Count")

# Time series
healthyR_data %>%
  mutate(month = floor_date(visit_start_date_time, "month")) %>%
  count(month) %>%
  ggplot(aes(x = month, y = n)) +
  geom_line() +
  labs(title = "Visit Volume Over Time", x = "Month", y = "Visits")
```

### Can I build predictive models?

Yes! Example with logistic regression:

```r
# Prepare data
model_data <- healthyR_data %>%
  filter(ip_op_flag == "I") %>%
  select(readmit_flag, length_of_stay, total_charge_amount, payer_grouping) %>%
  na.omit()

# Build model
model <- glm(
  readmit_flag ~ length_of_stay + total_charge_amount + payer_grouping,
  data = model_data,
  family = binomial
)

# Summary
summary(model)

# Predictions
predictions <- predict(model, model_data, type = "response")
```

## Getting More Help

### Where can I get help?

1. **Documentation**:
   - This wiki
   - `?function_name` in R
   - [Package website](https://www.spsanderson.com/healthyR.data/)

2. **Issues**:
   - [GitHub Issues](https://github.com/spsanderson/healthyR.data/issues)
   - Search existing issues first
   - Provide reproducible example

3. **Community**:
   - R4DS Slack community
   - Stack Overflow (tag with `r` and `healthyr`)

### How do I report a bug?

1. Check if it's already reported: [GitHub Issues](https://github.com/spsanderson/healthyR.data/issues)
2. Create a minimal reproducible example
3. Open a new issue with:
   - Description of the problem
   - Reproducible example
   - Expected vs actual behavior
   - Your R version and package version
   - Error messages (if any)

### How can I contribute?

See the [Contributing Guide](Contributing-Guide.md) for:
- Code contributions
- Documentation improvements
- Bug reports
- Feature requests

### Where do I find more examples?

- [Getting Started](Getting-Started.md) - Basic examples
- [Use Cases and Examples](Use-Cases-and-Examples.md) - Real-world applications
- [Package vignettes](https://www.spsanderson.com/healthyR.data/) (when available)
- [GitHub repository examples](https://github.com/spsanderson/healthyR.data/tree/master/examples)

---

[← Back to Home](Home.md) | [Troubleshooting →](Troubleshooting.md)
