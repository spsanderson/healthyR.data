#' Fetch Data as Tibble
#'
#' @family CMS Data
#'
#' @seealso \code{\link[healthyR.data]{get_cms_meta_data}}
#'
#' @description
#' This function retrieves data from the provided link and returns it as a tibble
#' with cleaned names. This function is intended to be used with the CMS data API
#' function \code{\link[healthyR.data]{get_cms_meta_data}}.
#'
#' @param .data_link A character string containing the URL to fetch data from.
#'
#' @return A tibble containing the fetched data with cleaned names. If an error
#' occurs, returns `NULL`.
#'
#' @details
#' The function sends a request to the provided URL using `httr2::request` and
#' `httr2::req_perform`. If the response status is not 200, it stops with an
#' error message indicating the failure. The response body is parsed as JSON and
#' converted into a tibble using `dplyr::as_tibble`. The column names are cleaned
#' using `janitor::clean_names`, and any character columns are stripped of leading
#' and trailing whitespace using `stringr::str_squish`.
#'
#' @examples
#' library(dplyr)
#'
#' # Example usage:
#' base_url <- "https://data.cms.gov/data-api/v1/dataset/"
#' data_identifier <- "9767cb68-8ea9-4f0b-8179-9431abc89f11"
#' data_url <- paste0(base_url, data_identifier, "/data")
#'
#' df_tbl <- fetch_cms_data(data_url)
#'
#' df_tbl |>
#'  head(1) |>
#'  glimpse()
#'
#' @name fetch_cms_data
NULL
#'
#' @export
#' @rdname fetch_cms_data
fetch_cms_data <- function(.data_link) {
    data_link <- .data_link

    # Check if the URL is valid
    url_valid <- is_valid_url(data_link)
    if (!url_valid) {
        rlang::abort(
            message = "The provided data link is not a valid URL. Please provide a valid URL.",
            use_cli_format = TRUE
        )
    }

    # Check if the URL starts with the required prefix
    # API Call?
    if (startsWith(data_link, "https://data.cms.gov/data-api/v1")) {
        tryCatch({
            response <- httr2::request(data_link) |>
                httr2::req_perform()
            if (httr2::resp_status(response) != 200) {
                stop("Failed to retrieve data: HTTP status ", httr2::resp_status(response))
            }
            json_data <- httr2::resp_body_json(
                response, check_type = FALSE, simplifyVector = TRUE
            )
            dplyr::as_tibble(json_data) |>
                janitor::clean_names() |>
                dplyr::mutate(dplyr::across(dplyr::where(is.character), stringr::str_squish))
        }, error = function(e) {
            message("An error occurred: ", e$message)
            return(NULL)
        })
        # File Call?
    } else if (startsWith(data_link, "https://data.cms.gov/sites/default/files/")) {
        destfile <- utils::choose.dir()
        if (is.na(destfile)) {
            message("No directory chosen. Operation aborted.")
            return(NULL)
        }
        destfile <- file.path(destfile, basename(data_link))
        tryCatch({
            utils::download.file(data_link, destfile)
            message("File downloaded successfully to ", destfile)
            return(invisible(destfile))
        }, error = function(e) {
            message("An error occurred: ", e$message)
            return(NULL)
        })
    } else {
        rlang::abort(
            message = "The provided data link does not match the expected patterns.",
            use_cli_format = TRUE
        )
    }
}
