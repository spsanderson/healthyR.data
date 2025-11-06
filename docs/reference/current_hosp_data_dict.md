# Download Hospital Data Dictionary

Download the Hospital Data Dictionary

## Usage

``` r
current_hosp_data_dict(.open_folder = FALSE)
```

## Arguments

- .open_folder:

  The default is FALSE. If set to TRUE then the folder where the file
  was saved to will be opened.

## Value

Downloads the current hospital data dictionary to a place specified by
the user.

## Details

This function will download the current Hospital Data Dictionary for the
official hospital data sets from the **CMS.gov** website. The function
makes use of
[`utils::choose.dir()`](https://rdrr.io/r/utils/choose.dir.html) and
will ask the user where to save the file.

## See also

<https://data.cms.gov/provider-data/topics/hospitals/>

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
if (FALSE) { # \dontrun{
  current_hosp_data_dict()
} # }
```
