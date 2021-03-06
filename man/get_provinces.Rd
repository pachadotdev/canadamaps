% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_provinces.R
\name{get_provinces}
\alias{get_provinces}
\title{Canadian Map at Province (ER) Level}
\usage{
get_provinces(map = census_divisions)
}
\arguments{
\item{map}{which map to add, by default it takes the complete Census
Divisions (CD) map}
}
\value{
a tibble with provinces and geometry (multipolygon) fields.
}
\description{
This function aggregates the Census Divisions (CD) map
to provide the Province map. The idea is to avoid providing
a dataset with map that can be obtained as an aggregation of another.
}
\examples{
get_provinces(
 census_divisions[census_divisions$prname == "Ontario",]
)
}
