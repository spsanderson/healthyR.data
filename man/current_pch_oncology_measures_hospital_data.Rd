% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-cur-pch-oncology-data.R
\name{current_pch_oncology_measures_hospital_data}
\alias{current_pch_oncology_measures_hospital_data}
\title{Get Current PCH Oncology Measures Data.}
\usage{
current_pch_oncology_measures_hospital_data(.data)
}
\arguments{
\item{.data}{The data that results from the \code{current_hosp_data()} function.}
}
\value{
Gets the current PCH Oncology Measures Hospital data from the current hospital data file.
}
\description{
Get the current PCH Oncology Measures data.
}
\details{
This function will obtain the current PCH Oncology Measures data
from the output of the \code{\link[=current_hosp_data]{current_hosp_data()}} function, that is
the required input for the \code{.data} parameter. This function only returns a single
object.
}
\examples{
\dontrun{
current_hosp_data() |>
  current_pch_oncology_measures_hospital_data()
}

}
\seealso{
\url{https://data.cms.gov/provider-data/topics/hospitals/}

Other Hospital Data: 
\code{\link{current_asc_data}()},
\code{\link{current_asc_oas_cahps_data}()},
\code{\link{current_comp_death_data}()},
\code{\link{current_hai_data}()},
\code{\link{current_hcahps_data}()},
\code{\link{current_hosp_data}()},
\code{\link{current_hvbp_data}()},
\code{\link{current_ipfqr_data}()},
\code{\link{current_maternal_data}()},
\code{\link{current_medicare_hospital_spending_data}()},
\code{\link{current_oqr_oas_cahps_data}()},
\code{\link{current_outpatient_imaging_efficiency_data}()},
\code{\link{current_payments_data}()},
\code{\link{current_pch_hai_hospital_data}()},
\code{\link{current_pch_hcahps_data}()},
\code{\link{current_pch_outcomes_data}()},
\code{\link{current_timely_and_effective_care_data}()},
\code{\link{current_unplanned_hospital_visits_data}},
\code{\link{current_va_data}()}
}
\author{
Steven P. Sanderson II, MPH
}
\concept{Hospital Data}
