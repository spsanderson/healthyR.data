#' Get Current Medicare Hospital Spending Data.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Get the current Medicare Hospital Spending data.
#'
#' @details This function will obtain the current Medicare Hospital Spending data
#' from the output of the [healthyR.data::current_hosp_data()] function, that is
#' the required input for the `.data` parameter. You can pass in a list of which
#' of those data sets you would like,
#'
#' @param .data The data that results from the `current_hosp_data()` function.
#' @param .data_sets The default is: c("Claim","Facility","State","National"), which will
#' bring back all of the data in the Medicare Hospital Spending data sets that
#' are in the file. You can choose from the following:
#' *  Claim
#' *  Facility
#' *  National
#' *  State
#'
#' You can also pass things like c("state","Nation") as behind the scenes only
#' the Medicare Hospital Spending data sets are available to the function to choose
#' from and `grep` is used to find matches with `ignore.case = TRUE` set.
#'
#' @examples
#' \dontrun{
#' current_hosp_data() |>
#'   current_maternal_data(.data_sets = c("State","National"))
#' }
#'
#' @return
#' Gets the current Medicare Hospital Spending data from the current hospital data file.
#'
#' @name current_medicare_hospital_spending_data
NULL

#' @export
#' @rdname current_medicare_hospital_spending_data

current_medicare_hospital_spending_data <- function(.data,
                                  .data_sets = c("Claim","Facility","State","National")) {

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
    file_names_vec <- c("medicare_hospital_spending_by_claim",
                        "medicare_hospital_spending_per_patient_hospital",
                        "medicare_hospital_spending_per_patient_national",
                        "medicare_hospital_spending_per_patient_state")

    asc_list <- l[names(l) %in% file_names_vec]
    names(asc_list)[2] <-  "medicare_hospital_spending_per_patient_facility"

    # Make sure there are no 0 length items
    asc_list <- asc_list[lengths(asc_list) > 0]

    # Only keep the names we want
    ret <- asc_list[grep(
        paste(ds, collapse = "|"),
        names(asc_list),
        ignore.case = TRUE
    )]

    # Return\
    attr(ret, ".list_type") <- "current_medicare_spending_list"
    class(ret) <- c("current_medicare_spending_list", class(ret))

    return(ret)

}
