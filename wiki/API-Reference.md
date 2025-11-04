# API Reference

Technical reference for CMS data APIs and package internals.

## Table of Contents

- [CMS Data API](#cms-data-api)
- [CMS Provider API](#cms-provider-api)
- [Package API](#package-api)
- [Data Structures](#data-structures)
- [HTTP Methods](#http-methods)
- [Error Handling](#error-handling)

## CMS Data API

### Base URLs

**CMS Data Catalog**:
```
https://data.cms.gov/data.json
```

**CMS Data API**:
```
https://data.cms.gov/data-api/v1/dataset/{identifier}/data
```

**Provider Data API**:
```
https://data.cms.gov/provider-data/api/1/datastore/query/{identifier}/{index}
```

### Endpoints

#### Get Data Catalog

**URL**: `https://data.cms.gov/data.json`

**Method**: GET

**Response Format**: JSON

**Description**: Returns metadata for all available CMS datasets

**Example**:
```r
cms_meta <- get_cms_meta_data()
```

**Response Structure**:
```json
{
  "dataset": [
    {
      "title": "Dataset Title",
      "description": "Dataset description",
      "identifier": "unique-id",
      "modified": "2024-01-01",
      "distribution": [
        {
          "mediaType": "text/csv",
          "downloadURL": "https://..."
        }
      ]
    }
  ]
}
```

#### Fetch Dataset

**URL**: `https://data.cms.gov/data-api/v1/dataset/{identifier}/data`

**Method**: GET

**Parameters**:
- `identifier` - Dataset unique identifier
- `offset` - Starting record (optional)
- `size` - Number of records (optional)

**Response Format**: JSON

**Example**:
```r
data_link <- "https://data.cms.gov/data-api/v1/dataset/abc123/data"
data <- fetch_cms_data(data_link)
```

#### Query Provider Data

**URL**: `https://data.cms.gov/provider-data/api/1/datastore/query/{identifier}/{index}`

**Method**: GET

**Parameters**:
- `identifier` - Provider dataset identifier
- `index` - Index number
- `limit` - Max records to return
- `offset` - Starting record

**Example**:
```r
provider_data <- fetch_provider_data(
  .data_identifier = "069d-826b",
  .limit = 100
)
```

## CMS Provider API

### Authentication

No authentication required - all endpoints are public.

### Rate Limits

CMS may implement rate limiting:
- Recommended: 1 request per second
- Add delays between requests for bulk downloads

```r
# Good practice
for (link in data_links) {
  data <- fetch_cms_data(link)
  Sys.sleep(1)  # Wait 1 second
}
```

### Response Formats

- **JSON** - Default for API endpoints
- **CSV** - Available for download
- **Excel** - Some datasets
- **ZIP** - Bulk downloads

## Package API

### Core Functions

#### get_cms_meta_data()

**Signature**:
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
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `.title` | character | NULL | Search by title |
| `.modified_date` | character | NULL | Filter by date (YYYY-MM-DD) |
| `.keyword` | character | NULL | Search keyword |
| `.identifier` | character | NULL | Unique identifier |
| `.data_version` | character | "current" | "current", "archive", "all" |
| `.media_type` | character | "all" | "all", "csv", "API", "other" |

**Returns**: tibble with columns:
- `title` (character)
- `description` (character)
- `landing_page` (character)
- `modified` (Date)
- `keyword` (list)
- `identifier` (character)
- `media_type` (character)
- `data_link` (character)
- Additional metadata fields

---

#### fetch_cms_data()

**Signature**:
```r
fetch_cms_data(.data_link)
```

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `.data_link` | character | URL to CMS data |

**Returns**: tibble with cleaned column names

**Processing**:
1. Validates URL with `is_valid_url()`
2. Sends HTTP request with `httr2::request()`
3. Parses response (JSON, CSV, etc.)
4. Cleans column names with `janitor::clean_names()`
5. Trims whitespace from character columns

**Error Handling**:
- Returns NULL on error
- Provides informative error messages

---

#### fetch_provider_data()

**Signature**:
```r
fetch_provider_data(.data_identifier, .limit = 500)
```

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `.data_identifier` | character | - | Provider dataset ID |
| `.limit` | numeric | 500 | Max records (0 = all) |

**Returns**: tibble

---

#### is_valid_url()

**Signature**:
```r
is_valid_url(url)
```

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `url` | character | URL to validate |

**Returns**: logical (TRUE/FALSE)

**Validation checks**:
- URL format is valid
- Scheme is http or https
- Can establish connection

---

### Specific Data Functions

All follow pattern:
```r
current_[type]_data(all_hosp_data, .data_sets = NULL)
```

**Parameters**:
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `all_hosp_data` | list | - | Result from `current_hosp_data()` |
| `.data_sets` | character vector | NULL | Specific datasets to extract |

**Returns**: tibble or list of tibbles

**Available Functions**:
- `current_hcahps_data()`
- `current_hai_data()`
- `current_comp_death_data()`
- `current_unplanned_hospital_visits_data()`
- `current_maternal_data()`
- `current_hvbp_data()`
- `current_ipfqr_data()`
- `current_oqr_oas_cahps_data()`
- `current_timely_and_effective_care_data()`
- `current_outpatient_imaging_efficiency_data()`
- `current_payments_data()`
- `current_medicare_hospital_spending_data()`
- `current_asc_data()`
- `current_asc_oas_cahps_data()`
- `current_pch_hcahps_data()`
- `current_pch_hai_hospital_data()`
- `current_pch_outcomes_data()`
- `current_pch_oncology_measures_hospital_data()`
- `current_va_data()`

## Data Structures

### Metadata Structure

```r
tibble(
  title = character(),
  description = character(),
  landing_page = character(),
  modified = Date(),
  keyword = list(),
  described_by = character(),
  fn = character(),
  has_email = character(),
  identifier = character(),
  start = Date(),
  end = Date(),
  references = list(),
  distribution_description = character(),
  distribution_title = character(),
  distribution_modified = Date(),
  distribution_start = Date(),
  distribution_end = Date(),
  media_type = character(),
  data_link = character()
)
```

### healthyR_data Structure

```r
tibble(
  mrn = character(),
  visit_id = character(),
  visit_start_date_time = POSIXct(),
  visit_end_date_time = POSIXct(),
  total_charge_amount = numeric(),
  total_amount_due = numeric(),
  total_adjustment_amount = numeric(),
  payer_grouping = character(),
  total_payment_amount = numeric(),
  ip_op_flag = character(),
  service_line = character(),
  length_of_stay = numeric(),
  expected_length_of_stay = logical(),
  length_of_stay_threshold = logical(),
  los_outlier_flag = numeric(),
  readmit_flag = numeric(),
  readmit_expectation = logical()
)
```

## HTTP Methods

### Request Headers

Default headers used by package:

```
User-Agent: healthyR.data/1.2.0 (R package)
Accept: application/json, text/csv, */*
```

### Response Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process data |
| 400 | Bad Request | Check parameters |
| 404 | Not Found | Verify URL/identifier |
| 408 | Timeout | Retry request |
| 429 | Too Many Requests | Add delays |
| 500 | Server Error | Retry later |
| 503 | Service Unavailable | Retry later |

### Error Responses

Example error response:
```json
{
  "error": {
    "message": "Dataset not found",
    "code": 404,
    "details": "..."
  }
}
```

## Error Handling

### Package Error Classes

Custom error classes:

```r
# Invalid URL
rlang::abort(
  "The provided URL is not valid",
  class = "invalid_url_error"
)

# HTTP error
rlang::abort(
  paste("Request failed with status", status),
  class = "http_error"
)

# Data parsing error
rlang::abort(
  "Failed to parse response data",
  class = "parse_error"
)
```

### Catching Errors

```r
# Try-catch pattern
result <- tryCatch(
  {
    fetch_cms_data(data_link)
  },
  error = function(e) {
    message("Error fetching data: ", e$message)
    NULL
  }
)

# Check result
if (!is.null(result)) {
  # Process data
}
```

### Validation Functions

Internal validation:

```r
# URL validation
is_valid_url(url)

# Parameter validation
if (is.null(.data_link)) {
  rlang::abort(".data_link parameter is required")
}

# Response validation
if (!httr2::resp_is_error(response)) {
  # Process response
}
```

## Advanced Usage

### Custom Requests

For advanced users who need custom API calls:

```r
library(httr2)

# Custom request
response <- request("https://data.cms.gov/api/endpoint") %>%
  req_headers(
    "User-Agent" = "Custom Agent",
    "Accept" = "application/json"
  ) %>%
  req_perform()

# Parse response
data <- response %>%
  resp_body_json() %>%
  as_tibble()
```

### Pagination

Handle paginated responses:

```r
get_all_pages <- function(base_url, page_size = 1000) {
  all_data <- list()
  offset <- 0
  
  repeat {
    url <- paste0(base_url, "?offset=", offset, "&size=", page_size)
    page_data <- fetch_cms_data(url)
    
    if (nrow(page_data) == 0) break
    
    all_data <- append(all_data, list(page_data))
    offset <- offset + page_size
    
    Sys.sleep(1)  # Rate limiting
  }
  
  bind_rows(all_data)
}
```

### Caching Strategy

Implement caching for efficiency:

```r
# Cache metadata
cache_cms_meta <- function() {
  cache_file <- "cms_meta_cache.rds"
  
  if (file.exists(cache_file)) {
    # Check if cache is recent (< 1 day old)
    cache_age <- difftime(Sys.time(), file.info(cache_file)$mtime, units = "hours")
    if (cache_age < 24) {
      return(readRDS(cache_file))
    }
  }
  
  # Fetch fresh data
  cms_meta <- get_cms_meta_data()
  saveRDS(cms_meta, cache_file)
  return(cms_meta)
}
```

## Related Documentation

- [CMS Data Access Guide](CMS-Data-Access.md) - User-friendly guide
- [Function Reference](Function-Reference.md) - All functions
- [Troubleshooting](Troubleshooting.md) - Common issues

## External Resources

- [CMS Data Documentation](https://data.cms.gov/data)
- [CMS API Documentation](https://data.cms.gov/provider-data/api-docs)
- [httr2 Package Documentation](https://httr2.r-lib.org/)

---

[← Back to Home](Home.md) | [CMS Data Access →](CMS-Data-Access.md)
