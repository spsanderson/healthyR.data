#' Download Current Hospital Data Files.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Download the Hospital Data Dictionary
#'
#' @details This function will download the current Hospital Data Dictionary for
#' the official hospital data sets from the __CMS.gov__ website. The function
#' makes use of a temporary directory and file to save and unzip the data. This
#' will grab the current Hospital Data Files, unzip them and return a list of
#' tibbles with each tibble named after the data file.
#'
#' @examples
#' \dontrun{
#'   current_hosp_data()
#' }
#'
#' @return
#' Downloads the current hospital data dictionary to a place specified by the user.
#'
#' @name current_hosp_data
NULL

#' @export
#' @rdname current_hosp_data

# Create the workflow set object

current_hosp_data <- function() {

    # Create a temporary file to store the zip file
    tmp <- tempfile()
    tmp_dir <- tempdir()

    # Download the zip file to the temporary location
    utils::download.file(
        url = "https://data.cms.gov/provider-data/sites/default/files/archive/Hospitals/current/hospitals_current_data.zip",
        destfile = tmp
    )

    # Unzip the file
    utils::unzip(tmp, exdir = tempdir())

    # Read the csv files into a list
    csv_file_list <- list.files(
        path = tempdir(),
        pattern = "\\.csv$",
        full.names = TRUE
    )

    # Process CSV Files
    parse_csv_file <- function(file) {
        # Normalize the path to use C:/path/to/file structure
        normalizePath(file, "/") |>
            # read in the csv file and use check.names = FALSE because some of
            # the names are very long
            utils::read.csv(check.names = FALSE) |>
            # clean the field names
            janitor::clean_names()
        }

    csv_file_tbl <- lapply(csv_file_list, parse_csv_file)

    # Get File Names
    # Get the tmp_dir in normal form C:/path/to/file
    path_remove <- paste0(normalizePath(tmp_dir, "/"),"/")

    # Get csv names function
    get_csv_names <- function(file) {
        # Process the path to normal form
        normalizePath(file, "/") |>
            # remove the tmp_dir from the full file string
            gsub(pattern = path_remove, replacement = "") |>
            # change all - to _
            gsub(pattern = "-", replacement = "_")
        }
    # Get the names
    file_names <- lapply(csv_file_list, get_csv_names)
    # apply the names
    names(csv_file_tbl) <- file_names

    # Make the result a tibble for each file.
    csv_file_tbl <- lapply(csv_file_tbl, dplyr::as_tibble)

    unlink(tmp_dir, recursive = TRUE)

    # Return the tibbles
    return(csv_file_tbl)
}
