#' Canadian Map at Economic Region (ER) Level
#' @description This function aggregates the Census Divisions (CD) map
#' to provide the Economic Region (ER) map. The idea is to avoid providing
#' a dataset with map that can be obtained as an aggregation of another.
#' @param map which map to add, by default it takes the complete Census
#' Divisions (CD) map
#' @importFrom sf st_make_valid st_union
#' @importFrom dplyr as_tibble filter select left_join bind_rows distinct group_by summarise
#' @importFrom rlang sym syms
#' @return a tibble with economic regions, provinces and geometry
#' (multipolygon) fields.
#' @examples
#' get_economic_regions(
#'   census_divisions[census_divisions$prname == "Ontario", ]
#' )
#' @export
get_economic_regions <- function(map = census_divisions) {
  map <- map %>%
    filter(!!sym("cduid") != 3524) %>%
    left_join(matches_for_aggregation$cduid_eruid, by = "cduid")

  map <- map %>%
    bind_rows(
      matches_for_aggregation$halton_special_case %>%
        select(!!!syms(c("pruid", "prname", "eruid", "ername", "geometry")))
    )

  eruid_pruid <- map %>%
    as_tibble() %>%
    select(!!!syms(c("eruid", "ername", "pruid", "prname"))) %>%
    distinct()

  map <- map %>%
    mutate(geometry = st_make_valid(!!sym("geometry"))) %>%
    group_by(!!sym("eruid")) %>%
    summarise(geometry = st_union(!!sym("geometry")), do_union = TRUE) %>%
    as_tibble() %>%
    left_join(eruid_pruid, by = "eruid") %>%
    select(!!!syms(c("eruid", "ername", "pruid", "prname", "geometry")))

  return(map)
}
