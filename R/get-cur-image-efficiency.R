#' Get Current Imaging Efficiency Data.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Get the current Imaging Efficiency data.
#'
#' @details This function will obtain the current Imaging Efficiency data
#' from the output of the [healthyR.data::current_hosp_data()] function, that is
#' the required input for the `.data` parameter. You can pass in a list of which
#' of those data sets you would like,
#'
#' @param .data The data that results from the `current_hosp_data()` function.
#' @param .data_sets The default is: c("Claim","Facility","State","National"), which will
#' bring back all of the data in the Imaging Efficiency data sets that
#' are in the file. You can choose from the following:
#' *  Facility
#' *  National
#' *  State
#'
#' You can also pass things like c("state","Nation") as behind the scenes only
#' the Imaging Efficiency data sets are available to the function to choose
#' from and `grep` is used to find matches with `ignore.case = TRUE` set.
#'
#' @examples
#' \dontrun{
#' current_hosp_data() |>
#'   current_outpatient_imaging_efficiency_data(.data_sets = c("State","National"))
#' }
#'
#' @return
#' Gets the current Imaging Efficiency data from the current hospital data file.
#'
#' @name current_outpatient_imaging_efficiency_data
NULL

#' @export
#' @rdname current_outpatient_imaging_efficiency_data

current_outpatient_imaging_efficiency_data <- function(.data,
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
    file_names_vec <- c("outpatient_imaging_efficiency_hospital",
                        "outpatient_imaging_efficiency_national",
                        "outpatient_imaging_efficiency_state" )

    asc_list <- l[names(l) %in% file_names_vec]
    names(asc_list)[1] <-  "outpatient_imaging_efficiency_facility"

    # Make sure there are no 0 length items
    asc_list <- asc_list[lengths(asc_list) > 0]

    # Only keep the names we want
    ret <- asc_list[grep(
        paste(ds, collapse = "|"),
        names(asc_list),
        ignore.case = TRUE
    )]

    # Return\
    attr(ret, ".list_type") <- "current_imaging_efficiency_list"
    class(ret) <- c("current_imaging_efficiency_list", class(ret))

    return(ret)

}
