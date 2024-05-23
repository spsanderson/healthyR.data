#' Fetch Provider Data as Tibble or Download CSV
#'
#' @family Provider Data
#'
#' @seealso \code{\link[healthyR.data]{get_provider_meta_data}}
#'
#' @description
#' This function retrieves provider data from the provided link and returns it as a tibble
#' with cleaned names or downloads the data as a CSV file if the link ends in .csv. This function is intended to be used with the CMS provider data API.
#'
#' @param .data_link A character string containing the URL to fetch data from.
#'
#' @return A tibble containing the fetched data with cleaned names, or downloads a CSV file to the user-selected directory. If an error occurs, returns `NULL`.
#'
#' @details
#' The function sends a request to the provided URL using `httr2::request` and
#' `httr2::req_perform`. If the response status is not 200, it stops with an
#' error message indicating the failure. If the URL ends in .csv, it uses `utils::download.file`
#' to download the CSV file to a directory chosen by the user. Otherwise, the response body is parsed as JSON and
#' converted into a tibble using `dplyr::as_tibble`. The column names are cleaned
#' using `janitor::clean_names`, and any character columns are stripped of leading
#' and trailing whitespace using `stringr::str_squish`.
#'
#' @examples
#' library(dplyr)
#'
#' # Example usage:
#' data_url <- "069d-826b"
#'
#' df_tbl <- fetch_provider_data(data_url)
#'
#' df_tbl |>
#'  head(1) |>
#'  glimpse()
#'
#' bad_url <- "https://www.google.com"
#' fetch_provider_data(bad_url)
#'
#' @name fetch_provider_data
NULL
#'
#' @export
#' @rdname fetch_provider_data
fetch_provider_data <- function(.data_link) {
    data_link <- .data_link

    # Is valid url? If not then it should be treated as an identifier, this
    # will output TRUE or FALSE
    is_valid_url <- function(url) {
        parsed_url <- httr2::url_parse(url)
        # Check if the parsed URL has a scheme and a host
        if (is.null(parsed_url$scheme) || is.null(parsed_url$hostname)) {
            return(FALSE)
        } else {
            return(TRUE)
        }
    }
    url_valid <- is_valid_url(data_link)

    # If the link does not end with .csv AND does not start with
    # https://data.cms.gov AND is not a valid url then it is should be treated
    # as an identifier and then construct the API query URL
    if (
        (
            !grepl("\\.csv$", data_link) &
            !grepl("^https://data.cms.gov", data_link) &
            !url_valid
        )
    ) {
        data_link <- paste0(
            "https://data.cms.gov/provider-data/api/1/datastore/query/",
            data_link,
            "/0"
        )
    }

    # Check if the URL starts with the required prefix and is a valid URL
    if (!is.character(data_link) ||
        length(data_link) != 1 ||
        !grepl("^https://data.cms.gov/provider-data", data_link) ||
        !is_valid_url(data_link)
    ) {
        rlang::abort(
            message = "The provided data link is not valid or does not start with
            'https://data.cms.gov/provider-data'. Please first pull an
            appropriate data link from the CMS provider data API using the
            get_provider_meta_data() function.",
            use_cli_format = TRUE
        )
    }

    # If the link ends with .csv, download the file
    if (grepl("\\.csv$", data_link)) {
        tryCatch({
            dir_path <- utils::choose.dir()
            if (is.na(dir_path)) {
                stop("No directory selected.")
            }
            file_path <- file.path(dir_path, basename(data_link))
            utils::download.file(data_link, file_path)
            message("File downloaded to ", file_path)
            return(NULL)
        }, error = function(e) {
            message("An error occurred while downloading the file: ", e$message)
            return(NULL)
        })
    }

    # Otherwise, fetch and process the JSON data
    tryCatch({
        response <- httr2::request(data_link) |>
            httr2::req_perform()
        if (httr2::resp_status(response) != 200) {
            stop("Failed to retrieve data: HTTP status ", httr2::resp_status(response))
        }
        json_data <- httr2::resp_body_json(
            response, check_type = FALSE, simplifyVector = TRUE
        )
        json_data[["results"]] |>
            dplyr::as_tibble() |>
            janitor::clean_names() |>
            dplyr::mutate(dplyr::across(dplyr::where(is.character), stringr::str_squish))
    }, error = function(e) {
        message("An error occurred: ", e$message)
        return(NULL)
    })
}
