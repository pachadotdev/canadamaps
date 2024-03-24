#' Project an sf object to the Lambert Conformal Conic projection
#'
#' @param tbl an sf object
#' @param crs_string a character string specifying the projection
#' @importFrom sf st_transform
#' @return an sf object
#' @export
lambert_projection <- function(tbl, crs_string = NULL) {
  if (is.null(crs_string)) {
    crs_string <- "+proj=lcc +lat_1=49 +lat_2=77 +lon_0=-91.52 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"
  }

  if (!any(names(tbl) == "geometry")) {
    stop("The input object does not have a geometry field.")
  }

  tbl$geometry <- st_transform(tbl$geometry, crs = crs_string)
  return(tbl)
}
