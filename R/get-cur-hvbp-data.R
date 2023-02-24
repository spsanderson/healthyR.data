#' Get Current Hospital Value Based Purchasing Data.
#'
#' @family Hospital Data
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Get the current hospital hospital value based purchasing data.
#'
#' @details This function will obtain the current hospital VBP data
#' from the output of the [healthyR.data::current_hosp_data()] function, that is
#' the required input for the `.data` parameter. You can pass in a list of which
#' of those data sets you would like,
#'
#' @param .data The data that results from the `current_hosp_data()` function.
#' @param .data_sets The default is: c("Outcomes","TPS"), which
#' will bring back all of the data sets that are in the hospital VBP
#' data sets. You can choose from the following:
#' *  Outcomes
#' *  Efficiency
#' *  Engagement
#' *  Safety
#' *  TPS
#'
#' You can also pass things like c("tps","Safety") as behind the scenes only
#' the hospital vbp data sets are available to the function to choose
#' from and `grep` is used to find matches with `ignore.case = TRUE` set.
#'
#' @examples
#' \dontrun{
#' current_hosp_data() |>
#'   current_hvbp_data(.data_sets = c("Outcomes","Safety"))
#' }
#'
#' @return
#' Gets the current hospital vbp data from the current hospital data file.
#'
#' @name current_hvbp_data
NULL

#' @export
#' @rdname current_hvbp_data

current_hvbp_data <- function(.data,
                             .data_sets = c("Outcomes","Efficiency","Engagement",
                                            "Safety","TPS")) {

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
    file_names_vec <- c("hvbp_clinical_outcomes",
                        "hvbp_efficiency_and_cost_reduction",
                        "hvbp_person_and_community_engagement",
                        "hvbp_safety",
                        "hvbp_")

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
    attr(ret, ".list_type") <- "current_hvbp_list"
    class(ret) <- c("current_hvbp_list", class(ret))

    return(ret)

}
