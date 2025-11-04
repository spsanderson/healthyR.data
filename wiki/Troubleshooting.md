# Troubleshooting Guide

Solutions to common issues when using the healthyR.data package.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Data Loading Issues](#data-loading-issues)
- [CMS Data Access Issues](#cms-data-access-issues)
- [Performance Issues](#performance-issues)
- [Data Quality Issues](#data-quality-issues)
- [Common Error Messages](#common-error-messages)

## Installation Issues

### Error: R version is too old

**Error Message**:
```
ERROR: this R is version 4.0.5, package 'healthyR.data' requires R >= 4.1.0
```

**Solution**:
Update R to version 4.1.0 or higher.

```r
# Check your R version
R.version.string

# Download latest R from:
# https://cran.r-project.org/
```

**Steps**:
1. Download R 4.1.0+ from CRAN
2. Install new R version
3. Reinstall packages
4. Retry package installation

---

### Error: Package dependencies not found

**Error Message**:
```
ERROR: dependency 'httr2' is not available for package 'healthyR.data'
```

**Solution**:
Install missing dependencies manually.

```r
# Install specific dependency
install.packages("httr2")

# Or install all dependencies
install.packages(c("dplyr", "rlang", "janitor", "httr2", "stringr", "tidyr"))

# Then retry
install.packages("healthyR.data")
```

---

### Error: Installation from GitHub fails

**Error Message**:
```
Error: Failed to install 'healthyR.data' from GitHub
```

**Solutions**:

**Option 1**: Increase timeout
```r
options(timeout = 300)  # 5 minutes
devtools::install_github("spsanderson/healthyR.data")
```

**Option 2**: Check internet connection
```r
# Test connection
capabilities("http/ftp")
```

**Option 3**: Use HTTPS
```r
# Ensure using HTTPS
devtools::install_github("spsanderson/healthyR.data", 
                         force = TRUE)
```

---

### Error: libcurl not found (Linux)

**Error Message**:
```
Configuration failed because libcurl was not found
```

**Solution**:
Install system dependencies.

**Ubuntu/Debian**:
```bash
sudo apt-get update
sudo apt-get install libcurl4-openssl-dev libssl-dev libxml2-dev
```

**Fedora/CentOS/RHEL**:
```bash
sudo yum install libcurl-devel openssl-devel libxml2-devel
```

**Then retry**:
```r
install.packages("healthyR.data")
```

---

## Data Loading Issues

### Error: Object 'healthyR_data' not found

**Error Message**:
```
Error: object 'healthyR_data' not found
```

**Solution**:
Load the package first.

```r
# Load package
library(healthyR.data)

# Now data is available
head(healthyR_data)
```

**Note**: The data is automatically available after loading the package. No need to call `data(healthyR_data)`.

---

### Error: Data not loading / Empty dataset

**Symptoms**:
- `healthyR_data` appears empty
- `nrow(healthyR_data)` returns 0

**Solutions**:

**Option 1**: Restart R session
```r
# Restart R
.rs.restartR()  # RStudio

# Or close and reopen R
```

**Option 2**: Reinstall package
```r
# Remove and reinstall
remove.packages("healthyR.data")
install.packages("healthyR.data")
library(healthyR.data)
```

**Option 3**: Load explicitly
```r
data("healthyR_data", package = "healthyR.data")
```

---

### Error: Namespace conflict / Function masked

**Error Message**:
```
The following objects are masked from 'package:dplyr':
    filter, lag
```

**This is normal!** It's just a notification, not an error.

**Solutions**:

**Option 1**: Use explicit namespacing
```r
# Use dplyr's filter explicitly
dplyr::filter(healthyR_data, ip_op_flag == "I")

# Use stats' filter
stats::filter(data, filter_spec)
```

**Option 2**: Load packages in specific order
```r
# Load conflicting packages first
library(dplyr)
library(healthyR.data)  # Load last to prioritize its functions
```

---

## CMS Data Access Issues

### Error: Invalid URL

**Error Message**:
```
Error: The provided URL is not valid
```

**Solutions**:

**Option 1**: Refresh metadata
```r
# Get fresh metadata
cms_meta <- get_cms_meta_data(
  .keyword = "your_search",
  .data_version = "current"
)

# Extract updated link
data_link <- cms_meta$data_link[1]
```

**Option 2**: Validate URL first
```r
# Check if URL is valid
if (is_valid_url(data_link)) {
  data <- fetch_cms_data(data_link)
} else {
  message("URL is not valid, refresh metadata")
}
```

---

### Error: HTTP request failed / Timeout

**Error Message**:
```
Error: Request failed with status 408 (Request Timeout)
Error: Timeout was reached
```

**Solutions**:

**Option 1**: Retry the request
```r
# Sometimes transient, just retry
data <- fetch_cms_data(data_link)
```

**Option 2**: Try different media type
```r
# Use CSV instead of API
cms_meta <- get_cms_meta_data(
  .keyword = "quality",
  .media_type = "csv"  # Try CSV instead of API
)
```

**Option 3**: Check internet connection
```r
# Test connection
url_valid <- is_valid_url("https://data.cms.gov")
```

**Option 4**: Add delay between requests
```r
# For multiple requests, add delays
for (i in seq_along(links)) {
  data <- fetch_cms_data(links[i])
  Sys.sleep(2)  # Wait 2 seconds between requests
}
```

---

### Error: No results found

**Error Message**:
```
# get_cms_meta_data returns 0 rows
```

**Solutions**:

**Option 1**: Broaden search
```r
# Less specific keyword
cms_meta <- get_cms_meta_data(.keyword = "hospital")

# Include all versions
cms_meta <- get_cms_meta_data(
  .keyword = "quality",
  .data_version = "all"  # Include archive
)

# All media types
cms_meta <- get_cms_meta_data(
  .keyword = "quality",
  .media_type = "all"
)
```

**Option 2**: Check spelling
```r
# Verify keyword spelling
cms_meta <- get_cms_meta_data(.keyword = "readmission")  # Correct
# Not: "readmisions" or "re-admission"
```

---

### Error: API rate limiting

**Error Message**:
```
Error: Too Many Requests (429)
```

**Solutions**:

**Option 1**: Add delays
```r
# Wait between requests
Sys.sleep(5)  # Wait 5 seconds
```

**Option 2**: Cache results
```r
# Save data locally
data <- fetch_cms_data(link)
saveRDS(data, "cms_data_cache.rds")

# Load from cache
data <- readRDS("cms_data_cache.rds")
```

**Option 3**: Use CSV downloads
```r
# CSV files aren't rate limited
cms_meta <- get_cms_meta_data(
  .media_type = "csv"
)
```

---

### Error: JSON parsing error

**Error Message**:
```
Error: lexical error: invalid char in json text
```

**Solutions**:

**Option 1**: Retry request
```r
# May be transient data issue
data <- fetch_cms_data(data_link)
```

**Option 2**: Try different dataset
```r
# Get alternative dataset
cms_meta <- get_cms_meta_data(.keyword = "quality")
data_link <- cms_meta$data_link[2]  # Try second result
data <- fetch_cms_data(data_link)
```

---

## Performance Issues

### Issue: Slow data loading

**Symptoms**:
- `healthyR_data` takes long to load
- First use is slow

**Solutions**:

**Option 1**: This is normal for first load
```r
# First load can take a few seconds
# Subsequent access is fast due to lazy loading
```

**Option 2**: Use data.table for speed
```r
library(data.table)
dt <- as.data.table(healthyR_data)
```

**Option 3**: Filter early
```r
# Only load what you need
inpatients <- healthyR_data %>%
  filter(ip_op_flag == "I")
```

---

### Issue: Large CMS downloads are slow

**Symptoms**:
- `current_hosp_data()` takes very long
- `fetch_cms_data()` times out

**Solutions**:

**Option 1**: Use specific datasets
```r
# Download all data first (one time)
all_data <- current_hosp_data()

# Then extract only what you need
hcahps <- current_hcahps_data(all_data, .data_sets = c("State"))
```

**Option 2**: Download in parts
```r
# Get metadata
cms_meta <- get_cms_meta_data(.keyword = "quality")

# Download one at a time
data1 <- fetch_cms_data(cms_meta$data_link[1])
saveRDS(data1, "cms_data1.rds")

Sys.sleep(5)

data2 <- fetch_cms_data(cms_meta$data_link[2])
saveRDS(data2, "cms_data2.rds")
```

**Option 3**: Check file size first
```r
# Preview metadata to see size
cms_meta %>%
  select(title, media_type, distribution_title)
```

---

### Issue: Memory issues with large datasets

**Error Message**:
```
Error: cannot allocate vector of size XXX Mb
```

**Solutions**:

**Option 1**: Increase memory (if possible)
```r
# Check current memory limit
memory.limit()  # Windows only

# Increase limit (Windows)
memory.limit(size = 16000)  # 16 GB
```

**Option 2**: Use sampling
```r
# Work with sample
sample_data <- healthyR_data %>%
  slice_sample(n = 10000)
```

**Option 3**: Process in chunks
```r
# Split by year
data_2010 <- healthyR_data %>%
  filter(year(visit_start_date_time) == 2010)

# Analyze separately
results_2010 <- analyze_data(data_2010)
```

**Option 4**: Use data.table or dtplyr
```r
library(data.table)
dt <- as.data.table(healthyR_data)

# Or use dtplyr for dplyr syntax with data.table speed
library(dtplyr)
lazy_dt <- lazy_dt(healthyR_data)
```

---

## Data Quality Issues

### Issue: Missing values (NA)

**Symptoms**:
- `expected_length_of_stay` is mostly NA
- `readmit_expectation` is NA

**This is expected!** These fields are sparse by design to mimic real data.

**Solutions**:

**Option 1**: Filter out NAs
```r
# Remove rows with NA in specific column
complete_data <- healthyR_data %>%
  filter(!is.na(expected_length_of_stay))
```

**Option 2**: Use functions that handle NAs
```r
# Use na.rm = TRUE
mean(healthyR_data$length_of_stay, na.rm = TRUE)

# Or with dplyr
healthyR_data %>%
  summarise(avg_los = mean(length_of_stay, na.rm = TRUE))
```

---

### Issue: Unexpected zeros

**Symptoms**:
- `length_of_stay` is 0
- This is not missing data!

**Explanation**:
Zero length of stay is valid for outpatients.

**Solution**:
Filter by patient type:

```r
# For LOS analysis, use inpatients only
inpatients <- healthyR_data %>%
  filter(
    ip_op_flag == "I",
    length_of_stay > 0
  )

avg_los <- mean(inpatients$length_of_stay)
```

---

### Issue: Negative dollar amounts

**Symptoms**:
- `total_payment_amount` is negative
- `total_adjustment_amount` is negative

**This is correct!** Healthcare accounting uses:
- Positive for charges (debits)
- Negative for payments/adjustments (credits)

**Solution**:
Use absolute values for summation:

```r
# Calculate total payments
total_paid <- sum(abs(healthyR_data$total_payment_amount))

# Calculate average payment
avg_payment <- mean(abs(healthyR_data$total_payment_amount))
```

---

## Common Error Messages

### "argument is of length zero"

**Cause**: Operating on empty or NULL vector

**Solution**:
```r
# Check before operating
if (length(data_link) > 0 && !is.na(data_link)) {
  data <- fetch_cms_data(data_link)
}
```

---

### "subscript out of bounds"

**Cause**: Trying to access element that doesn't exist

**Solution**:
```r
# Check length first
if (nrow(cms_meta) > 0) {
  data_link <- cms_meta$data_link[1]
} else {
  message("No results found")
}
```

---

### "object of type 'closure' is not subsettable"

**Cause**: Trying to subset a function instead of data

**Solution**:
```r
# Wrong: treating function as data
result <- mean[1]

# Correct: call function
result <- mean(data$column)
```

---

### "could not find function"

**Cause**: Package not loaded or function doesn't exist

**Solution**:
```r
# Load package
library(healthyR.data)

# Or use explicit namespace
healthyR.data::fetch_cms_data(link)

# Check if function exists
exists("fetch_cms_data")
```

---

## Getting Additional Help

### Checklist Before Asking for Help

1. ✅ Read error message carefully
2. ✅ Check this troubleshooting guide
3. ✅ Search existing [GitHub Issues](https://github.com/spsanderson/healthyR.data/issues)
4. ✅ Try with minimal reproducible example
5. ✅ Check package version (`packageVersion("healthyR.data")`)
6. ✅ Check R version (`R.version.string`)

### How to Create a Reproducible Example

```r
library(healthyR.data)
library(dplyr)

# Use small subset
sample_data <- healthyR_data %>%
  slice_sample(n = 100)

# Show what you tried
result <- sample_data %>%
  filter(ip_op_flag == "I")

# Show error
# Error message here
```

### Where to Get Help

1. **GitHub Issues**: [Report a bug](https://github.com/spsanderson/healthyR.data/issues/new)
2. **Package Documentation**: `?function_name`
3. **Wiki**: This documentation
4. **Stack Overflow**: Tag with `r` and `healthyr`

### Information to Include

When reporting issues, include:
- R version
- Package version
- Operating system
- Error message (complete)
- Reproducible example
- What you expected vs what happened

```r
# Get session info
sessionInfo()

# Or better
library(devtools)
session_info()
```

---

[← Back to Home](Home.md) | [FAQ →](FAQ.md)
