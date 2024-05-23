#' Fetch Data as Tibble
#'
#' @family Hospital Data
#'
#' @seealso \code{\link[healthyR.data]{get_cms_meta_data}}
#'
#' @author Steven P. Sanderson II, MPH
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
#' fetch_cms_data("https://www.google.com")
#'
#' @name fetch_cms_data
NULL
#'
#' @export
#' @rdname fetch_cms_data
fetch_cms_data <- function(.data_link) {
    data_link <- .data_link

    # Check if the URL is valid and starts with the required prefix
    if (!is.character(data_link) || length(data_link) != 1 || !grepl("^https://data.cms.gov/data-api/v1/dataset/", data_link)) {
        rlang::abort(
            message = "The provided data link is not valid or does not start with
            'https://data.cms.gov/data-api/v1/dataset/'. Please first pull an
            appropriate data link from the CMS data API using the function
            get_cms_meta_data()",
            use_cli_format = TRUE
        )
    }

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
}
