# Welcome to the healthyR.data Wiki

<img src="https://raw.githubusercontent.com/spsanderson/healthyR.data/master/man/figures/logo.png" width="147" height="170" align="right" />

Welcome to the comprehensive wiki for **healthyR.data**, an R package that provides healthcare administrative datasets and tools for accessing CMS (Centers for Medicare & Medicaid Services) hospital data.

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/healthyR.data)](https://cran.r-project.org/package=healthyR.data)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html##stable)

## What is healthyR.data?

**healthyR.data** is a comprehensive R package that serves two primary purposes:

1. **Built-in Healthcare Data**: Provides a rich, realistic administrative dataset (`healthyR_data`) with 187,721 rows covering hospital visits, patient demographics, charges, payments, and quality metrics
2. **CMS Data Access**: Offers a suite of functions to fetch, download, and work with current CMS hospital data, including quality measures, outcomes, and provider information

## Quick Navigation

### Getting Started
- [Installation Guide](Installation-Guide.md) - How to install healthyR.data
- [Getting Started](Getting-Started.md) - Your first steps with the package
- [Quick Start Examples](Quick-Start-Examples.md) - Common use cases and examples

### Core Features
- [Built-in Dataset](Built-in-Dataset.md) - Details about the healthyR_data dataset
- [CMS Data Access](CMS-Data-Access.md) - Fetching live CMS hospital data
- [Data Dictionary](Data-Dictionary.md) - Complete variable reference

### Function Reference
- [Function Reference by Category](Function-Reference.md) - All functions organized by purpose
- [Meta Data Functions](Meta-Data-Functions.md) - Searching CMS datasets
- [Data Download Functions](Data-Download-Functions.md) - Fetching CMS data
- [Specific Hospital Data Functions](Specific-Hospital-Data-Functions.md) - Targeted data extraction
- [Utility Functions](Utility-Functions.md) - Helper functions

### Advanced Topics
- [Use Cases and Examples](Use-Cases-and-Examples.md) - Real-world applications
- [Working with Financial Data](Working-with-Financial-Data.md) - Analyzing charges and payments
- [Quality Metrics Analysis](Quality-Metrics-Analysis.md) - Hospital performance indicators
- [API Reference](API-Reference.md) - Technical API details

### Support and Contributing
- [FAQ](FAQ.md) - Frequently asked questions
- [Troubleshooting](Troubleshooting.md) - Common issues and solutions
- [Contributing Guide](Contributing-Guide.md) - How to contribute to the project

## Package Information

- **Version**: 1.2.0.9000 (development)
- **License**: MIT + file LICENSE
- **Author**: Steven P. Sanderson II, MPH
- **ORCID**: [0009-0006-7661-8247](https://orcid.org/0009-0006-7661-8247)
- **R Version Required**: >= 4.1.0

## Key Features at a Glance

### Built-in Administrative Dataset
- 187,721 hospital visit records
- 17 comprehensive variables
- Patient demographics and visit information
- Financial data (charges, payments, adjustments)
- Clinical metrics (length of stay, service lines)
- Quality indicators (readmissions, outlier flags)
- Synthetic/de-identified data for safe use

### CMS Data Access
- Search CMS data catalog with `get_cms_meta_data()`
- Fetch current hospital data with `current_hosp_data()`
- Access 20+ specific CMS datasets
- Provider data via API
- Data dictionaries available
- URL validation utilities

## Use Cases

**healthyR.data** is ideal for:

- **Healthcare Analytics**: Test and develop healthcare analytics functions
- **Education**: Teach health informatics and data analysis courses
- **Research**: Prototype healthcare research analyses
- **Package Development**: Test healthcare R packages
- **Quality Improvement**: Analyze hospital quality metrics
- **Financial Analysis**: Study healthcare billing patterns
- **Benchmarking**: Compare against national hospital data

## Quick Example

```r
library(healthyR.data)
library(dplyr)

# Load the built-in dataset
df <- healthyR_data

# Analyze service lines by patient type
df %>% 
  count(ip_op_flag, service_line) %>%
  arrange(ip_op_flag, desc(n)) %>%
  head(10)
```

## External Resources

- [Package Website](https://www.spsanderson.com/healthyR.data/)
- [GitHub Repository](https://github.com/spsanderson/healthyR.data)
- [CRAN Package Page](https://cran.r-project.org/package=healthyR.data)
- [Report Issues](https://github.com/spsanderson/healthyR.data/issues)

## Related Packages

- [healthyR](https://github.com/spsanderson/healthyR) - Hospital data analysis workflow tools
- [healthyverse](https://github.com/spsanderson/healthyverse) - Meta-package for healthcare analytics

## Citation

If you use this package in your research, please cite:

```r
citation("healthyR.data")
```

---

**Note**: The built-in `healthyR_data` dataset contains synthetic/de-identified data for demonstration and testing purposes. When working with CMS data functions, you're accessing real, publicly available CMS hospital data.

*Last updated: 2025-11-04*
