#' Download Hospital Data Dictionary
#'
#' @family Data Dictionary
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @seealso \url{https://data.cms.gov/provider-data/topics/hospitals/}
#'
#' @description Download the Hospital Data Dictionary
#'
#' @details This function will download the current Hospital Data Dictionary for
#' the official hospital data sets from the __CMS.gov__ website. The function
#' makes use of [utils::choose.dir()] and will ask the user where to save the
#' file.
#'
#' @examples
#' \dontrun{
#'   current_hosp_data_dict()
#' }
#'
#' @return
#' Downloads the current hospital data dictionary to a place specified by the user.
#'
#' @name current_hosp_data_dict
NULL

#' @export
#' @rdname current_hosp_data_dict

# Create the workflow set object

current_hosp_data_dict <- function() {

    # Create a temporary file to store the zip file
    file_path <- utils::choose.dir()
    destfile <- paste0(file_path, "\\Hospital_Data_Dictionary.pdf")

    # Download the zip file to the temporary location
    url <- "https://data.cms.gov/provider-data/sites/default/files/data_dictionaries/hospital/HOSPITAL_Data_Dictionary.pdf"
    utils::download.file(
        url = url,
        destfile = destfile,
        mode = "wb"
    )

    # Return the tibbles
    rlang::inform(
        message = paste0(
            "The Hospital Data Dictionary has been downloaded to: ",
            file_path,
            "\\",
            basename(url)
        ),
        use_cli_format = TRUE
    )
}
