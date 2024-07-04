#' Check if a URL is valid
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details The function uses the `httr2::url_parse` function to parse the URL
#' and checks if the parsed URL contains a scheme and a hostname. If either
#' is missing, the URL is considered invalid.
#'
#' @description
#' This function validates a URL by checking the presence of a scheme and a
#' hostname in the parsed URL.
#'
#' @param url A character string representing the URL to be checked.
#'
#' @return A logical value: `TRUE` if the URL is valid, `FALSE` otherwise.
#'
#' @examples
#' is_valid_url("https://www.example.com") # TRUE
#' is_valid_url("not_a_url") # FALSE
#'
#' @name is_valid_url
NULL

#' @rdname is_valid_url
#' @export
is_valid_url <- function(url) {
    parsed_url <- httr2::url_parse(url)
    # Check if the parsed URL has a scheme and a host
    if (is.null(parsed_url$scheme) || is.null(parsed_url$hostname)) {
        return(FALSE)
    } else {
        return(TRUE)
    }
}
