#' Retrieve Provider Metadata from CMS
#'
#' @family Meta Data
#'
#' @seealso \url{https://data.cms.gov/provider-data/api/1/metastore/schemas/dataset/items}
#'
#' @description
#' This function sends a request to the specified CMS metadata URL, retrieves the JSON data,
#' and processes it to create a tibble with relevant information about the datasets.
#'
#' @param .identifier A dataset identifier to filter the data.
#' @param .title A title to filter the data.
#' @param .description A description to filter the data.
#' @param .keyword A keyword to filter the data.
#' @param .issued A date when the dataset was issued to filter the data.
#' @param .modified A date when the dataset was modified to filter the data.
#' @param .released A date when the dataset was released to filter the data.
#' @param .theme A theme to filter the data.
#' @param .media_type A media type to filter the data.
#'
#' @details
#' The function fetches JSON data from the CMS metadata URL and extracts relevant fields to
#' create a tidy tibble. It selects specific columns, handles nested lists by unnesting them,
#' cleans column names, and processes dates and media types to make the data more useful for analysis.
#' The columns in the returned tibble are:
#' \itemize{
#'   \item \code{identifier}
#'   \item \code{title}
#'   \item \code{description}
#'   \item \code{keyword}
#'   \item \code{issued}
#'   \item \code{modified}
#'   \item \code{released}
#'   \item \code{theme}
#'   \item \code{media_type}
#'   \item \code{download_url}
#'   \item \code{contact_fn}
#'   \item \code{contact_email}
#'   \item \code{publisher_name}
#' }
#'
#' @return A tibble with metadata about the datasets.
#'
#' @examples
#' library(dplyr)
#'
#' # Fetch and process metadata from the CMS data URL
#' get_provider_meta_data(.identifier = "3614-1eef") |>
#'   glimpse()
#'
#' @name get_provider_meta_data
NULL
#' @rdname get_provider_meta_data
#' @export

get_provider_meta_data <- function(.identifier = NULL, .title = NULL,
                                   .description = NULL, .keyword = NULL,
                                   .issued = NULL, .modified = NULL,
                                   .released = NULL, .theme = NULL,
                                   .media_type = NULL) {
    url_meta_data <- paste0('https://data.cms.gov/',
                            'provider-data/api/1/metastore/',
                            'schemas/dataset/items'
    )

    # Helper function to perform the
    get_json_data <- function(url) {
        tryCatch({
            httr2::request(url) |>
                httr2::req_perform() |>
                httr2::resp_body_json(check_type = FALSE, simplifyVector = TRUE)
        }, error = function(e) {
            message("Error retrieving JSON data: ", e)
            NULL
        })
    }

    # Helper function to clean and process the data
    process_data <- function(response) {
        response |>
            dplyr::select(-bureauCode, -`@type`, -programCode) |>
            dplyr::mutate(contact_fn = contactPoint$fn) |>
            dplyr::mutate(contact_email = contactPoint$hasEmail |>
                              stringr::str_remove("mailto:")) |>
            dplyr::mutate(publisher_name = publisher$name) |>
            dplyr::mutate(download_url = distribution[[1]]$downloadURL) |>
            dplyr::mutate(media_type = distribution[[3]]$mediaType) |>
            dplyr::select(-contactPoint, -publisher, -distribution) |>
            dplyr::mutate(dplyr::across(c(issued, modified, released), as.Date)) |>
            dplyr::tibble() |>
            janitor::clean_names()
    }

    # Main function body
    response <- get_json_data(url_meta_data)
    if (is.null(response)) {
        return(NULL)
    }

    data_tbl <- process_data(response)

    # Filtering based on parameters
    if (!is.null(.identifier)) {
        data_tbl <- data_tbl[grep(
            pattern = .identifier,
            x = data_tbl$identifier,
            ignore.case = TRUE
        ),]
    }

    if (!is.null(.title)) {
        data_tbl <- data_tbl[grep(
            pattern = .title,
            x = data_tbl$title,
            ignore.case = TRUE
        ),]
    }

    if (!is.null(.description)) {
        data_tbl <- data_tbl[grep(
            pattern = .description,
            x = data_tbl$description,
            ignore.case = TRUE
        ),]
    }

    if (!is.null(.keyword)) {
        data_tbl <- data_tbl[
            grep(
                pattern = .keyword,
                x = unname(data_tbl$keyword),
                ignore.case = TRUE
            ),]
        data_tbl <- data_tbl[!is.na(data_tbl$identifier),]
    }

    if (!is.null(.issued)) {
        data_tbl <- data_tbl |>
            dplyr::filter(issued == as.Date(.issued))
    }

    if (!is.null(.modified)) {
        data_tbl <- data_tbl |>
            dplyr::filter(modified == as.Date(.modified))
    }

    if (!is.null(.released)) {
        data_tbl <- data_tbl |>
            dplyr::filter(released == as.Date(.released))
    }

    if (!is.null(.theme)) {
        data_tbl <- data_tbl[grep(
            pattern = .theme,
            x = unname(data_tbl$theme),
            ignore.case = TRUE
            ),]
        data_tbl <- data_tbl[!is.na(data_tbl$theme),]
    }

    if (!is.null(.media_type)) {
        data_tbl <- data_tbl[grep(.media_type, data_tbl$media_type, ignore.case = TRUE),]
    }

    # Add metadata to the tibble
    class(data_tbl) <- c("provider_meta_data", class(data_tbl))
    attr(data_tbl, "url") <- url_meta_data
    attr(data_tbl, "date_retrieved") <- Sys.time()
    attr(data_tbl, "parameters") <- list(
        .identifier = .identifier,
        .title = .title,
        .description = .description,
        .keyword = .keyword,
        .issued = .issued,
        .modified = .modified,
        .released = .released,
        .theme = .theme,
        .media_type = .media_type
        )

    # Final Return
    return(data_tbl)
}
