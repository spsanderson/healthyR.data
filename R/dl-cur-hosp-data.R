#' Download Current Hospital Data Files.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Download the current Hospital Data Sets.
#'
#' @details This function will download the current and the official hospital
#' data sets from the __CMS.gov__ website.
#'
#' The function makes use of a temporary directory and file to save and unzip
#' the data. This will grab the current Hospital Data Files, unzip them and
#' return a list of tibbles with each tibble named after the data file.
#'
#' The function returns a list object with all of the current hospital data as a
#' tibble. It does not save the data anywhere so if you want to save it you will
#' have to do that manually.
#'
#' This also means that you would have to store the data as a variable in order
#' to access the data later on. It does have a given attributes and a class so
#' that it can be piped into other functions.
#'
#' @param path The location to download and unzip the files. By default this
#' will go to a temporary directory
#'
#' @inheritDotParams utils::unzip -zipfile -exdir
#'
#' @examples
#' \dontrun{
#'   current_hosp_data()
#' }
#'
#' @return
#' Downloads the current hospital data sets.
#'
#' @name current_hosp_data
NULL

#' @export
#' @rdname current_hosp_data

current_hosp_data <- function(path = tempdir(), ...) {

    # URL for file
    url <- "https://data.cms.gov/provider-data/sites/default/files/archive/Hospitals/current/hospitals_current_data.zip"

    # Set up directory to process the zip file
    download_location <- file.path(path, "download.zip")
    extract_location <- file.path(path, "extract")

    dir.create(extract_location, showWarnings = FALSE)

    # Download the zip file to the specified location
    utils::download.file(
        url = url,
        destfile = download_location
    )

    # Unzip the file
    utils::unzip(download_location, exdir = extract_location, ...)

    # Read the csv files into a list
    csv_file_list <- list.files(
        path = extract_location,
        pattern = "\\.csv$",
        full.names = TRUE
    )

    # make named list
    csv_names <-
        stats::setNames(
            object = csv_file_list,
            nm =
                csv_file_list |>
                basename() |>
                gsub(pattern = "\\.csv$", replacement = "") |>
                janitor::make_clean_names()
        )

    # Process CSV Files
    parse_csv_file <- function(file) {
        # Normalize the path to use C:/path/to/file structure
        normalizePath(file, "/") |>
            # read in the csv file and use check.names = FALSE because some of
            # the names are very long
            utils::read.csv(check.names = FALSE) |>
            dplyr::as_tibble() |>
            # clean the field names
            janitor::clean_names()
    }

    list_of_tables <- lapply(csv_names, parse_csv_file)

    # unlink temporary directory if used
    if (path == tempdir()) {
        unlink(path, recursive = TRUE)
    }

    # Return the tibbles
    # Add and attribute and a class type to the object
    attr(list_of_tables, ".list_type") <- "current_hosp_data"
    class(list_of_tables) <- c("current_hosp_data", class(list_of_tables))

    list_of_tables
}
