# healthyR.data Wiki

Welcome to the healthyR.data package wiki! This comprehensive documentation provides everything you need to use the package effectively.

## Quick Links

### Essential Pages
- **[Home](Home.md)** - Overview and navigation
- **[Installation Guide](Installation-Guide.md)** - How to install the package
- **[Getting Started](Getting-Started.md)** - Your first steps
- **[FAQ](FAQ.md)** - Frequently asked questions

### Core Documentation
- **[Built-in Dataset](Built-in-Dataset.md)** - Complete healthyR_data documentation
- **[Data Dictionary](Data-Dictionary.md)** - Variable reference guide
- **[CMS Data Access](CMS-Data-Access.md)** - Working with CMS hospital data
- **[Function Reference](Function-Reference.md)** - All functions organized by category

### Advanced Topics
- **[Use Cases and Examples](Use-Cases-and-Examples.md)** - Real-world applications
- **[API Reference](API-Reference.md)** - Technical API details
- **[Troubleshooting](Troubleshooting.md)** - Solutions to common issues

### Contributing
- **[Contributing Guide](Contributing-Guide.md)** - How to contribute to the project

## About healthyR.data

**healthyR.data** is an R package that provides:

1. **Built-in Healthcare Data**: A comprehensive synthetic dataset with 187,721 hospital visit records
2. **CMS Data Access**: Functions to fetch and work with current CMS hospital quality data
3. **Healthcare Analytics Tools**: Utilities for analyzing healthcare administrative data

## Quick Start

```r
# Install from CRAN
install.packages("healthyR.data")

# Load package
library(healthyR.data)

# Use built-in data
data <- healthyR_data
head(data)

# Access CMS data
cms_meta <- get_cms_meta_data(.keyword = "quality")
```

## Documentation Structure

### For Beginners
1. Start with [Installation Guide](Installation-Guide.md)
2. Read [Getting Started](Getting-Started.md)
3. Explore [Built-in Dataset](Built-in-Dataset.md)
4. Check [FAQ](FAQ.md) for common questions

### For Analysts
1. Review [Data Dictionary](Data-Dictionary.md)
2. Study [Use Cases and Examples](Use-Cases-and-Examples.md)
3. Learn [CMS Data Access](CMS-Data-Access.md)
4. Reference [Function Reference](Function-Reference.md)

### For Developers
1. Read [Contributing Guide](Contributing-Guide.md)
2. Study [API Reference](API-Reference.md)
3. Check [Function Reference](Function-Reference.md)
4. Review package source code

## Key Features

### Built-in Dataset
- 187,721 hospital visit records
- 17 comprehensive variables
- Synthetic/de-identified data
- Realistic patterns for analytics

### CMS Data Functions
- Search CMS data catalog
- Fetch current hospital data
- 20+ specific dataset functions
- Provider data access

### Use Cases
- Healthcare analytics development
- Education and training
- Research prototyping
- Package testing
- Quality improvement analysis

## External Resources

- **Package Website**: https://www.spsanderson.com/healthyR.data/
- **GitHub Repository**: https://github.com/spsanderson/healthyR.data
- **CRAN Page**: https://cran.r-project.org/package=healthyR.data
- **Report Issues**: https://github.com/spsanderson/healthyR.data/issues

## Getting Help

1. Check the [FAQ](FAQ.md)
2. Review [Troubleshooting](Troubleshooting.md)
3. Search [existing issues](https://github.com/spsanderson/healthyR.data/issues)
4. Ask in R community forums
5. [Open a new issue](https://github.com/spsanderson/healthyR.data/issues/new)

## Citation

If you use this package in your research:

```r
citation("healthyR.data")
```

## License

MIT License - See [LICENSE.md](https://github.com/spsanderson/healthyR.data/blob/master/LICENSE.md)

## Author

Steven P. Sanderson II, MPH  
Email: spsanderson@gmail.com  
ORCID: [0009-0006-7661-8247](https://orcid.org/0009-0006-7661-8247)

---

*Last updated: 2025-11-04*
