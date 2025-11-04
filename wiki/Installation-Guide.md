# Installation Guide

This guide provides detailed instructions for installing the healthyR.data package.

## Table of Contents

- [System Requirements](#system-requirements)
- [Installing from CRAN](#installing-from-cran)
- [Installing Development Version](#installing-development-version)
- [Installing Dependencies](#installing-dependencies)
- [Verifying Installation](#verifying-installation)
- [Updating the Package](#updating-the-package)
- [Troubleshooting Installation](#troubleshooting-installation)

## System Requirements

### R Version
- **Minimum R version**: 4.1.0 or higher
- Check your R version: `R.version.string`

### Operating Systems
The package works on:
- Windows 10/11
- macOS (all recent versions)
- Linux (all major distributions)

### Dependencies

The package automatically installs these dependencies:

- **Core dependencies**:
  - `dplyr` - Data manipulation
  - `rlang` - Language features
  - `utils` - Utility functions
  - `janitor` - Data cleaning
  - `stats` - Statistical functions

- **Data access dependencies**:
  - `httr2` - HTTP requests for CMS data
  - `stringr` - String manipulation
  - `tidyr` - Data tidying

## Installing from CRAN

The easiest way to install healthyR.data is from CRAN (Comprehensive R Archive Network).

### Basic Installation

```r
# Install from CRAN
install.packages("healthyR.data")
```

### Loading the Package

```r
# Load the package
library(healthyR.data)

# Check package version
packageVersion("healthyR.data")
```

## Installing Development Version

To get the latest development features, install directly from GitHub.

### Prerequisites

First, install the `devtools` package if you don't have it:

```r
install.packages("devtools")
```

Or use `remotes` (lighter alternative):

```r
install.packages("remotes")
```

### Installation from GitHub

**Using devtools:**

```r
devtools::install_github("spsanderson/healthyR.data")
```

**Using remotes:**

```r
remotes::install_github("spsanderson/healthyR.data")
```

### Installing Specific Versions

**Install a specific release:**

```r
devtools::install_github("spsanderson/healthyR.data@v1.2.0")
```

**Install from a specific branch:**

```r
devtools::install_github("spsanderson/healthyR.data@development")
```

## Installing Dependencies

### Manual Dependency Installation

If you need to manually install dependencies:

```r
# Install all dependencies at once
install.packages(c(
  "dplyr", 
  "rlang", 
  "utils", 
  "janitor", 
  "httr2", 
  "stringr", 
  "tidyr", 
  "stats"
))
```

### Installing with All Dependencies

To ensure all suggested packages are also installed:

```r
install.packages("healthyR.data", dependencies = TRUE)
```

## Verifying Installation

### Basic Verification

```r
# Load the package
library(healthyR.data)

# Check if the main dataset loads
data(healthyR_data)
head(healthyR_data)

# Verify dataset dimensions
dim(healthyR_data)
# Should show: [1] 187721     17
```

### Function Verification

```r
# Test a meta data function
cms_data <- get_cms_meta_data(
  .keyword = "hospital",
  .data_version = "current"
)

# Check if data was fetched
nrow(cms_data) > 0
```

### Complete System Check

```r
# Check package information
packageDescription("healthyR.data")

# List all functions in the package
ls("package:healthyR.data")

# Check for any conflicts
conflicts(detail = TRUE)
```

## Updating the Package

### Update from CRAN

```r
# Update to the latest CRAN version
update.packages("healthyR.data")
```

### Update from GitHub

```r
# Reinstall from GitHub to get latest development version
devtools::install_github("spsanderson/healthyR.data", force = TRUE)
```

### Check for Updates

```r
# Check if a newer version is available on CRAN
old.packages()[, "Package"] %in% "healthyR.data"
```

## Troubleshooting Installation

### Common Issues and Solutions

#### Issue: R Version Too Old

**Error**: `requires R (>= 4.1.0)`

**Solution**: Update R to version 4.1.0 or higher:
- Download from [CRAN](https://cran.r-project.org/)
- Follow installation instructions for your OS

#### Issue: Dependency Installation Failures

**Error**: `package 'xyz' is not available`

**Solution**: Install missing dependencies manually:

```r
# For Bioconductor packages (if any)
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    
# Install specific dependency
install.packages("package_name")
```

#### Issue: Permission Errors (Linux/macOS)

**Error**: `Permission denied`

**Solution**: Install to user library:

```r
# Set user library path
.libPaths(new = "~/R/library")

# Then install
install.packages("healthyR.data")
```

#### Issue: httr2 Installation Problems

**Error**: Issues installing `httr2`

**Solution**: Ensure you have curl development libraries:

**Ubuntu/Debian:**
```bash
sudo apt-get install libcurl4-openssl-dev
```

**Fedora/CentOS:**
```bash
sudo yum install libcurl-devel
```

**macOS (with Homebrew):**
```bash
brew install curl
```

#### Issue: GitHub Installation Timeout

**Error**: `timeout of 60 seconds was reached`

**Solution**: Increase timeout:

```r
options(timeout = 300)  # 5 minutes
devtools::install_github("spsanderson/healthyR.data")
```

#### Issue: Package Loading Conflicts

**Error**: `object 'xyz' is masked from 'package:abc'`

**Solution**: Use explicit namespacing:

```r
# Instead of: filter()
# Use: dplyr::filter()

# Or detach conflicting package
detach("package:conflicting_package", unload = TRUE)
```

### Getting Additional Help

If you continue to experience installation issues:

1. **Check Package Status**: Visit the [CRAN package page](https://cran.r-project.org/package=healthyR.data)
2. **Search Existing Issues**: Check [GitHub Issues](https://github.com/spsanderson/healthyR.data/issues)
3. **Report New Issue**: [Create a new issue](https://github.com/spsanderson/healthyR.data/issues/new) with:
   - Your R version (`R.version`)
   - Your operating system
   - Error messages (full text)
   - Steps to reproduce

## Uninstalling

To remove the package:

```r
# Remove the package
remove.packages("healthyR.data")
```

To completely clean up:

```r
# Remove package and clear workspace
remove.packages("healthyR.data")
rm(list = ls(all.names = TRUE))
```

## Next Steps

After successful installation:

1. Read the [Getting Started](Getting-Started.md) guide
2. Explore the [Built-in Dataset](Built-in-Dataset.md)
3. Try the [Quick Start Examples](Quick-Start-Examples.md)
4. Review the [Function Reference](Function-Reference.md)

---

[← Back to Home](Home.md) | [Next: Getting Started →](Getting-Started.md)
