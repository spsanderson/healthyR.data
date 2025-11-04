# Contributing Guide

Thank you for considering contributing to healthyR.data! This guide will help you get started.

## Table of Contents

- [Ways to Contribute](#ways-to-contribute)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Code of Conduct](#code-of-conduct)

## Ways to Contribute

You can contribute to healthyR.data in several ways:

### 1. Report Bugs

Found a bug? [Open an issue](https://github.com/spsanderson/healthyR.data/issues/new) with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Your R version and package version
- Reproducible example (if possible)

### 2. Suggest Features

Have an idea? [Open an issue](https://github.com/spsanderson/healthyR.data/issues/new) with:
- Clear description of the feature
- Use case / motivation
- Example of how it would work
- Any relevant examples from other packages

### 3. Improve Documentation

- Fix typos or unclear explanations
- Add examples to function documentation
- Improve wiki pages
- Create vignettes or tutorials

### 4. Write Code

- Fix bugs
- Implement new features
- Improve performance
- Add new CMS data access functions

### 5. Help Others

- Answer questions in issues
- Help troubleshoot problems
- Share your use cases

## Getting Started

### Prerequisites

- R >= 4.1.0
- Git
- GitHub account
- RStudio (recommended)

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:

```bash
git clone https://github.com/YOUR_USERNAME/healthyR.data.git
cd healthyR.data
```

3. **Add upstream remote**:

```bash
git remote add upstream https://github.com/spsanderson/healthyR.data.git
```

4. **Install dependencies**:

```r
# Install development dependencies
install.packages("devtools")
devtools::install_dev_deps()
```

## Development Workflow

### 1. Create a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/my-new-feature
# or
git checkout -b fix/bug-description
```

**Branch naming conventions**:
- `feature/` for new features
- `fix/` for bug fixes
- `docs/` for documentation
- `test/` for test improvements

### 2. Make Changes

Edit files as needed. For R code:
- Follow the code standards (see below)
- Add documentation with roxygen2
- Write tests for new functionality

### 3. Test Your Changes

```r
# Load package
devtools::load_all()

# Run tests
devtools::test()

# Check package
devtools::check()
```

### 4. Document Your Changes

```r
# Update documentation
devtools::document()

# Build README (if changed)
rmarkdown::render("README.Rmd")
```

### 5. Commit Your Changes

```bash
git add .
git commit -m "Brief description of changes"
```

**Commit message guidelines**:
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Fix bug" not "Fixes bug")
- Reference issues: "Fix #123: Description"
- Keep first line under 50 characters
- Add detailed description after blank line if needed

### 6. Push to Your Fork

```bash
git push origin feature/my-new-feature
```

### 7. Create Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your branch
4. Fill in the PR template
5. Submit!

## Code Standards

### R Code Style

Follow the [tidyverse style guide](https://style.tidyverse.org/):

```r
# Good
calculate_average <- function(data, column) {
  data %>%
    summarise(avg = mean({{ column }}, na.rm = TRUE))
}

# Bad
calculateAverage<-function(data,column){
data%>%summarise(avg=mean(column,na.rm=T))
}
```

**Key points**:
- Use snake_case for function and variable names
- Use 2 spaces for indentation (no tabs)
- Limit lines to ~80 characters
- Use spaces around operators (`x + y` not `x+y`)
- Use `<-` for assignment, not `=`

### Code Formatting

Use `styler` package:

```r
# Format a file
styler::style_file("R/my_function.R")

# Format entire package
styler::style_pkg()
```

### Function Documentation

Use roxygen2 for documentation:

```r
#' Short Title
#'
#' @family Family Name
#'
#' @description
#' Detailed description of what the function does.
#'
#' @param param1 Description of parameter 1
#' @param param2 Description of parameter 2
#'
#' @return Description of return value
#'
#' @examples
#' # Example usage
#' result <- my_function(param1 = "value")
#'
#' @export
my_function <- function(param1, param2 = NULL) {
  # Function code here
}
```

### Error Handling

Use rlang for consistent error messages:

```r
# Good
if (!is_valid_url(url)) {
  rlang::abort(
    "Invalid URL provided",
    class = "invalid_url_error"
  )
}

# Also acceptable
if (missing(required_param)) {
  stop("required_param is missing with no default", call. = FALSE)
}
```

## Testing

### Writing Tests

Use `testthat` for unit tests:

```r
# tests/testthat/test-my-function.R

test_that("my_function works with valid input", {
  result <- my_function("test")
  expect_equal(result, "expected_output")
})

test_that("my_function handles errors", {
  expect_error(
    my_function(NULL),
    "Invalid input"
  )
})
```

### Running Tests

```r
# Run all tests
devtools::test()

# Run specific test file
devtools::test_active_file()

# Run tests with coverage
covr::package_coverage()
```

### Test Guidelines

- Test normal use cases
- Test edge cases
- Test error conditions
- Use descriptive test names
- Keep tests independent
- Don't test external APIs directly (use mocking if needed)

## Documentation

### Function Documentation

- Every exported function needs documentation
- Include description, parameters, return value
- Provide at least one example
- Use `@family` tag to group related functions

### README

- Keep README.md up to date
- Edit README.Rmd (not README.md directly)
- Include working examples
- Show package features

### Vignettes

For new major features, consider adding a vignette:

```r
# Create vignette
usethis::use_vignette("my-feature")
```

### NEWS

Add entries to NEWS.md:

```markdown
# healthyR.data (development version)

## New Features
* Added `new_function()` for doing X (#issue_number)

## Bug Fixes
* Fixed issue with `existing_function()` when... (#issue_number)
```

## Pull Request Process

### Before Submitting

Checklist:
- [ ] Code follows style guidelines
- [ ] All tests pass (`devtools::check()`)
- [ ] Documentation is updated
- [ ] NEWS.md is updated (for user-facing changes)
- [ ] Examples work correctly
- [ ] Commit messages are clear

### PR Description

Include in your PR:
- What changes were made
- Why these changes are needed
- How to test the changes
- Related issues (use "Fixes #123" to auto-close)
- Any breaking changes

### Review Process

1. Maintainer will review your PR
2. Address any requested changes
3. Push updates to same branch
4. PR will be merged when approved

### After Merge

```bash
# Update your local main
git checkout main
git pull upstream main

# Delete feature branch
git branch -d feature/my-new-feature
```

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on what's best for the community
- Show empathy towards others
- Accept constructive criticism gracefully

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information
- Other unprofessional conduct

### Enforcement

Violations can be reported to the package maintainer. All reports will be reviewed and investigated.

## Development Tips

### Useful Commands

```r
# Load package for testing
devtools::load_all()

# Run examples
devtools::run_examples()

# Check package
devtools::check()

# Update documentation
devtools::document()

# Install locally
devtools::install()

# Check spelling
spelling::spell_check_package()
```

### IDE Setup

**RStudio**:
- Use RStudio projects
- Enable "Use devtools package development"
- Configure Code > Diagnostics for linting

**VS Code**:
- Install R extension
- Use R Language Server
- Enable linting

### Debugging

```r
# Add browser() to pause execution
my_function <- function(x) {
  browser()  # Execution pauses here
  result <- process(x)
  return(result)
}

# Or use debug mode
debug(my_function)
my_function(test_data)
undebug(my_function)
```

## Questions?

- **General questions**: [Open an issue](https://github.com/spsanderson/healthyR.data/issues/new)
- **Security issues**: Email the maintainer directly
- **Package maintainer**: Steven P. Sanderson II, MPH (spsanderson@gmail.com)

## Recognition

Contributors will be:
- Listed in package contributors
- Acknowledged in NEWS.md
- Mentioned in release notes (for significant contributions)

## Resources

- [R Packages Book](https://r-pkgs.org/) by Hadley Wickham
- [Tidyverse Style Guide](https://style.tidyverse.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Writing R Extensions](https://cran.r-project.org/doc/manuals/R-exts.html)

---

Thank you for contributing to healthyR.data! 🎉

[← Back to Home](Home.md)
