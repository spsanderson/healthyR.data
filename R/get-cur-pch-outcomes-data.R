#' Get Current PCH Outcomes Data.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Get the current PCH Outcomes data.
#'
#' @details This function will obtain the current PCH Outcomes data
#' from the output of the [healthyR.data::current_hosp_data()] function, that is
#' the required input for the `.data` parameter. You can pass in a list of which
#' of those data sets you would like,
#'
#' @param .data The data that results from the `current_hosp_data()` function.
#' @param .data_sets The default is: c(Facility","National"), which will
#' bring back all of the data in the PCH HCAHPS data sets that
#' are in the file. You can choose from the following:
#' *  Facility
#' *  National
#'
#' You can also pass things like c("state","Nation") as behind the scenes only
#' the PCH Outcomes data sets are available to the function to choose
#' from and `grep` is used to find matches with `ignore.case = TRUE` set.
#'
#' @examples
#' \dontrun{
#' current_hosp_data() |>
#'   current_pch_outcomes_data(.data_sets = c("Facility", "National"))
#' }
#'
#' @return
#' Gets the current PCH Outcomes data from the current hospital data file.
#'
#' @name current_pch_outcomes_data
NULL

#' @export
#' @rdname current_pch_outcomes_data

current_pch_outcomes_data <- function(.data,
                                      .data_sets = c("Facility","National")) {

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
    file_names_vec <- c("pch_outcomes_hospital",
                        "pch_outcomes_national")

    asc_list <- l[names(l) %in% file_names_vec]
    names(asc_list)[1] <-  "pch_outcomes_facility"

    # Make sure there are no 0 length items
    asc_list <- asc_list[lengths(asc_list) > 0]

    # Only keep the names we want
    ret <- asc_list[grep(
        paste(ds, collapse = "|"),
        names(asc_list),
        ignore.case = TRUE
    )]

    # Return
    attr(ret, ".list_type") <- "pch_outcomes_list"
    class(ret) <- c("pch_outcomes_list", class(ret))

    return(ret)

}
