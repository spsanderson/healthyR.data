#' Retrieve Data Links from CMS Data URL
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/data.json}
#'
#' @description
#' This function sends a request to the specified CMS data URL, retrieves the JSON data,
#' and processes it to create a tibble with relevant information about the datasets.
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
#' \dontrun{
#' # Fetch and process data links from the CMS data URL
#' data_links <- get_cms_meta_data()
#' print(data_links)
#' }
#'
#' @name get_cms_meta_data
NULL
#' @rdname get_cms_meta_data
#' @export

get_cms_meta_data <- function() {
    # Make a request to the specified URL and retrieve the JSON data
    url <- "https://data.cms.gov/data.json"
    data_sets <- httr2::request(url) |>
        httr2::req_perform() |>
        httr2::resp_body_json(check_type = FALSE, simplifyVector = TRUE)

    # Create a tibble from the 'dataset' field of the JSON data
    data_tbl <- data_sets$dataset |>
        dplyr::tibble() |>
        dplyr::select(
            title, description, landingPage,
            modified, keyword, description,
            describedBy, contactPoint, identifier,
            temporal, references, distribution
        ) |>
        tidyr::unnest(cols = distribution, names_sep = "_") |>
        tidyr::unnest(cols = c(keyword, contactPoint, references)) |>
        janitor::clean_names() |>
        dplyr::select(-type, -distribution_type) |>
        dplyr::mutate(media_type = ifelse(is.na(distribution_format),
                                          distribution_media_type,
                                          distribution_format
        )) |>
        dplyr::mutate(data_link = ifelse(is.na(distribution_access_url),
                                         distribution_download_url,
                                         distribution_access_url
        )) |>
        dplyr::mutate(has_email = stringr::str_remove(has_email, "mailto:")) |>
        tidyr::separate(temporal,
                        into = c("start", "end"), sep = "/",
                        remove = TRUE
        ) |>
        tidyr::separate(distribution_temporal,
                        into = c("distribution_start", "distribution_end"), sep = "/",
                        remove = TRUE
        ) |>
        dplyr::mutate(dplyr::across(c(
            start, end, modified,
            distribution_modified, distribution_start,
            distribution_end
        ), as.Date)) |>
        dplyr::mutate(distribution_description = ifelse(is.na(distribution_description),
                                                        "old", distribution_description
        )) |>
        dplyr::mutate(distribution_title = stringr::str_remove_all(distribution_title, "[:|-]")) |>
        dplyr::mutate(distribution_title = stringr::str_remove_all(distribution_title, "[:number:]")) |>
        dplyr::select(
            -distribution_format, -distribution_media_type,
            -distribution_access_url, -distribution_download_url
        ) |>
        dplyr::mutate(dplyr::across(dplyr::where(is.character), stringr::str_squish))

    # Return the resulting tibble with data links
    return(data_tbl)
}
