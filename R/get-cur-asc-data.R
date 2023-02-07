#' Get Current Ambulatory Surgery Center Data.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Get the current Ambulatory Surgery Center data.
#'
#' @details This function will obtain the current Ambulatory Surgery Center data
#' from the output of the [healthyR.data::current_hosp_data()] function, that is
#' the required input for the `.data` parameter. You can pass in a list of which
#' of those data sets you would like,
#'
#' @param .data The data that results from the `current_hosp_data()` function.
#' @param .data_sets The default is: c("Facility","State","National"), which will
#' bring back all of the data in the Ambulatory Surgery Center data sets that
#' are in the file. You can choose from the following:
#' *  Facility
#' *  National
#' *  State
#'
#' You can also pass things like c("state","Nation") as behind the scense only
#' the Ambulatory Surgery Center datasets are available to the function to choose
#' from and `grep` is used to find matches with `ignore.case = TRUE` set.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' current_hosp_data() %>%
#'   current_asc_data(.data_sets = c("State","National"))
#' }
#'
#' @return
#' Gets the current ASC data from the current hospital data file.
#'
#' @name current_asc_data
NULL

#' @export
#' @rdname current_asc_data

current_asc_data <- function(.data,
                             .data_sets = c("Facility","State","National")) {

    # Variables
    ds <- .data_sets
    l <- .data

    # Checks
    if (!inherits(l, "current_hosp_data")){
        rlang::abort(
            message = "'.data' must come from the function 'current_hosp_data()",
            use_cli_format = TRUE
        )
    }

    # Manipulations
    # Get the exact files necessary to the ASC
    file_names_vec <- c("ASC_Facility.csv","ASC_National.csv","ASC_State.csv")
    asc_list <- l[names(l) %in% file_names_vec]

    # Make sure there are no 0 length items
    asc_list <- asc_list[lengths(asc_list) > 0]

    # Only keep the names we want
    ret <- asc_list[grep(
        paste(ds, collapse = "|"),
        names(asc_list),
        ignore.case = TRUE
        )]

    # Return\
    attr(ret, ".list_type") <- "current_asc_list"
    class(ret) <- c("current_asc_list", class(ret))

    return(ret)

}
