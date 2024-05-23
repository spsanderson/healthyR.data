#' Retrieve CMS Metadata Links from CMS
#'
#' @family Meta Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/data.json}
#'
#' @description
#' This function sends a request to the specified CMS data URL, retrieves the JSON data,
#' and processes it to create a tibble with relevant information about the datasets.
#'
#' @param .title This can be a title that is used to search the data.
#' @param .modified_date This can be a date in the format of "YYYY-MM-DD"
#' @param .keyword This can be a keyword that is used to search the data.
#' @param .identifier This can be an identifier that is used to search the data.
#' @param .data_version This can be one of three different choices: "current",
#' "archive", or "all". The default is "current" and if you make a choice that
#' does not exist then it will default to "current".
#' @param .media_type This can be one of three different choices: "all", "csv",
#' "API", or "other". The default is "all" and if you make a choice that does not
#' exist then it will default to "all".
#'
#' @details
#' The function fetches JSON data from the CMS data URL and extracts relevant fields to
#' create a tidy tibble. It selects specific columns, handles nested lists by unnesting them,
#' cleans column names, and processes dates and media types to make the data more useful for analysis.
#' The columns in the returned tibble are:
#' \itemize{
#'   \item \code{title}
#'   \item \code{description}
#'   \item \code{landing_page}
#'   \item \code{modified}
#'   \item \code{keyword}
#'   \item \code{described_by}
#'   \item \code{fn}
#'   \item \code{has_email}
#'   \item \code{identifier}
#'   \item \code{start}
#'   \item \code{end}
#'   \item \code{references}
#'   \item \code{distribution_description}
#'   \item \code{distribution_title}
#'   \item \code{distribution_modified}
#'   \item \code{distribution_start}
#'   \item \code{distribution_end}
#'   \item \code{media_type}
#'   \item \code{data_link}
#' }
#'
#' @return A tibble with data links and relevant metadata about the datasets.
#'
#' @examples
#' library(dplyr)
#'
#' # Fetch and process metadata from the CMS data URL
#' get_cms_meta_data(
#'   .keyword = "nation",
#'   .title = "Market Saturation & Utilization State-County"
#' ) |>
#'   glimpse()
#'
#' @name get_cms_meta_data
NULL
#' @rdname get_cms_meta_data
#' @export

get_cms_meta_data <- function(.title = NULL, .modified_date = NULL, .keyword = NULL,
                              .identifier = NULL, .data_version = "current",
                               .media_type = "all") {

    # URL to fetch the CMS data
    url = "https://data.cms.gov/data.json"

    # Variable to store the modified date
    modified_date <- as.Date(.modified_date, format = "%Y-%m-%d")

    # Helper function to perform the HTTP request and retrieve JSON data
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
    process_data <- function(data_sets) {
        data_sets$dataset |>
            dplyr::tibble() |>
            dplyr::select(
                title, description, landingPage, modified, keyword, describedBy,
                contactPoint, identifier, temporal, references, distribution
            ) |>
            tidyr::unnest(cols = distribution, names_sep = "_") |>
            #tidyr::unnest(cols = c(keyword, contactPoint, references)) |>
            tidyr::unnest(cols = c(contactPoint, references)) |>
            janitor::clean_names() |>
            dplyr::select(-type, -distribution_type) |>
            dplyr::mutate(media_type = ifelse(is.na(distribution_format),
                                              distribution_media_type,
                                              distribution_format)) |>
            dplyr::mutate(data_link = ifelse(is.na(distribution_access_url),
                                             distribution_download_url,
                                             distribution_access_url)) |>
            dplyr::mutate(has_email = stringr::str_remove(has_email, "mailto:")) |>
            tidyr::separate(temporal, into = c("start", "end"), sep = "/", remove = TRUE) |>
            tidyr::separate(distribution_temporal, into = c("distribution_start", "distribution_end"), sep = "/", remove = TRUE) |>
            dplyr::mutate(
                dplyr::across(
                    c(
                        start, end, modified, distribution_modified,
                        distribution_start, distribution_end
                    ),
                    as.Date)
                ) |>
            dplyr::mutate(distribution_description = ifelse(
                is.na(distribution_description),
                "old",
                distribution_description
                )
            ) |>
            dplyr::mutate(distribution_title = stringr::str_remove_all(distribution_title, "[:|-]")) |>
            dplyr::mutate(distribution_title = stringr::str_remove_all(distribution_title, "[:number:]")) |>
            dplyr::select(
                -distribution_format, -distribution_media_type,
                -distribution_access_url, -distribution_download_url
                ) |>
            dplyr::mutate(dplyr::across(dplyr::where(is.character), stringr::str_squish))
    }

    # Main function body
    data_sets <- get_json_data(url)
    if (is.null(data_sets)) {
        return(NULL)
    }

    data_tbl <- process_data(data_sets)

    # Filters
    if (!is.null(.title)) {
        data_tbl <- data_tbl[grep(.title, data_tbl$title, ignore.case = TRUE),]
    }

    if (!is.null(.modified_date)) {
        data_tbl <- dplyr::filter(data_tbl, modified == modified_date)
    }

    if (!is.null(.keyword)) {
        data_tbl <- data_tbl[grep(
            pattern = .keyword,
            x = unname(data_tbl$keyword),
            ignore.case = TRUE
        ),]
        data_tbl <- data_tbl[!is.na(data_tbl$title),]
    }

    if (!is.null(.identifier)) {
        data_tbl <- data_tbl[grep(.identifier, data_tbl$identifier, ignore.case = TRUE),]
    }

    if (.data_version == "archive") {
        data_tbl <- dplyr::filter(
            data_tbl,
            stringr::str_detect(distribution_description, "old")
        )
    } else if (.data_version == "all") {
        data_tbl <- data_tbl
    } else {
        data_tbl <- dplyr::filter(
            data_tbl,
            stringr::str_detect(distribution_description, "latest")
        )
    }

    if (.media_type != "all") {
        data_tbl <- dplyr::filter(data_tbl, media_type == .media_type)
    }

    # Add metadata to the tibble
    class(data_tbl) <- c("cms_meta_data", class(data_tbl))
    attr(data_tbl, "url") <- url
    attr(data_tbl, "date_retrieved") <- Sys.time()
    attr(data_tbl, "parameters") <- list(
        .data_version = .data_version,
        .media_type = .media_type,
        .title = .title,
        .modified_date = .modified_date,
        .keyword = .keyword,
        .identifier = .identifier
    )

    # Final Return
    return(data_tbl)
}
