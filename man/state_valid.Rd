% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/state_valid.R
\docType{data}
\name{state_valid}
\alias{state_valid}
\title{Table of valid full names/abbreviations/FIPS codes of 52 states}
\format{
\subsection{A data frame with 3 columns and 52 rows:}{

\describe{
\item{st_abbr}{2-letter abbreviation for states.}
\item{state}{State full name.}
\item{fips_code}{Federal Information Processing System (FIPS) Codes for states.}

}
}
}
\source{
County-state reference file 2020
https://www.census.gov/programs-surveys/popest/geographies/reference-files.html
}
\usage{
state_valid
}
\description{
A reference table for valid input for \code{state} in \code{get_census_data()} and
\code{find_svi()}. In addition, \code{state = "US"} or \code{state = NULL} is also accepted
for nation-level data.
}
\keyword{datasets}
