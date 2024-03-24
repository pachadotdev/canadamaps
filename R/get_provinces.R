#' Canadian Map at Province (ER) Level
#' @description This function aggregates the Census Divisions (CD) map
#' to provide the Province map. The idea is to avoid providing
#' a dataset with map that can be obtained as an aggregation of another.
#' @param map which map to add, by default it takes the complete Census
#' Divisions (CD) map
#' @importFrom sf st_make_valid st_union
#' @importFrom dplyr as_tibble select left_join distinct mutate group_by summarise
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @return a tibble with provinces and geometry (multipolygon) fields.
#' @examples
#' get_provinces(
#'   census_divisions[census_divisions$prname == "Ontario", ]
#' )
#' @export
get_provinces <- function(map = census_divisions) {
  cduid_pruid <- map %>%
    as_tibble() %>%
    select(!!!syms(c("pruid", "prname"))) %>%
    distinct()

  map <- map %>%
    mutate(geometry = st_make_valid(!!sym("geometry"))) %>%
    group_by(!!sym("pruid")) %>%
    summarise(geometry = st_union(!!sym("geometry")), do_union = TRUE) %>%
    as_tibble() %>%
    left_join(cduid_pruid, by = "pruid") %>%
    select(!!!syms(c("pruid", "prname", "geometry")))

  return(map)
}
