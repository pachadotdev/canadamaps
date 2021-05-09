#' Canadian Map at Province (ER) Level
#' @description This function aggregates the Census Divisions (CD) map
#' to provide the Province map. The idea is to avoid providing
#' a dataset with map that can be obtained as an aggregation of another.
#' @param map which map to add, by default it takes the complete Census
#' Divisions (CD) map
#' @importFrom rmapshaper ms_dissolve ms_simplify
#' @importFrom sf st_as_sf
#' @importFrom dplyr as_tibble filter select left_join
#' @importFrom magrittr %>%
#' @return a tibble with provinces and geometry (multipolygon) fields.
#' @examples
#' \dontrun{
#' get_provinces()
#' get_provinces(census_divisions %>% filter(prname == "Ontario"))
#' }
#' @export
get_provinces <- function(map = canadamaps::census_divisions) {
  cduid_pruid <- map %>%
    as_tibble() %>%
    select(pruid, prname) %>%
    distinct()

  map <- ms_dissolve(st_as_sf(map), field = "pruid") %>%
    as_tibble() %>%
    left_join(cduid_pruid, by = "pruid")

  map[, c("pruid", "prname", "geometry")]
}
