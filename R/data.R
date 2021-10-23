#' census_divisions
#'
#' Geometries for each Census Division (CD)
#'
#' @section Variables:
#'
#' \itemize{
#'  \item \code{cduid}: Census division number.
#'  \item \code{cdname}: Census division name.
#'  \item \code{cdname}: Census division type (i.e. see
#'   the README in the GitHub repository).
#'  \item \code{pruid}: Province number.
#'  \item \code{prname}: Province name.
#'  \item \code{geometry}: Census division shape.
#' }
#'
#' @docType data
#' @name census_divisions
#' @usage census_divisions
#' @format A \code{data frame} with 293 observations and 6 variables.
#' @source Adapted from official Canadian Census shapefiles.
"census_divisions"

#' federal_electoral_districts
#'
#' Geometries for each Federal Electoral District (FED)
#'
#' @section Variables:
#'
#' \itemize{
#'  \item \code{feduid}: Census division number.
#'  \item \code{fedname}: Federal electoral district name.
#'  \item \code{pruid}: Province number.
#'  \item \code{prname}: Province name.
#'  \item \code{geometry}: Federal electoral district shape.
#' }
#'
#' @docType data
#' @name federal_electoral_districts
#' @usage federal_electoral_districts
#' @format A \code{data frame} with 338 observations and 5 variables.
#' @source Adapted from official Canadian Census shapefiles.
"federal_electoral_districts"
