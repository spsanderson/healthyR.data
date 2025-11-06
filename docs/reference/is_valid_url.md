# Check if a URL is valid

This function validates a URL by checking the presence of a scheme and a
hostname in the parsed URL.

## Usage

``` r
is_valid_url(url)
```

## Arguments

- url:

  A character string representing the URL to be checked.

## Value

A logical value: `TRUE` if the URL is valid, `FALSE` otherwise.

## Details

The function uses the
[`httr2::url_parse`](https://httr2.r-lib.org/reference/url_parse.html)
function to parse the URL and checks if the parsed URL contains a scheme
and a hostname. If either is missing, the URL is considered invalid.

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
is_valid_url("https://www.example.com") # TRUE
#> [1] TRUE
is_valid_url("not_a_url") # FALSE
#> [1] FALSE
```
