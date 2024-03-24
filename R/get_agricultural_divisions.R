#' Canadian Map at Census Agricultural Region (CAR) Level
#' @description This function aggregates the Census Divisions (CD) map
#' to provide the Census Agricultural Region (CAR) map. The idea is to avoid
#' providing a dataset with map that can be obtained as an aggregation of
#' another.
#' @param map which map to add, by default it takes the complete Census
#' Divisions (CD) map
#' @importFrom sf st_make_valid st_union
#' @importFrom dplyr as_tibble select left_join distinct mutate case_when group_by summarise
#'  case_when
#' @importFrom rlang sym syms
#' @return a tibble with economic regions, provinces and geometry
#' (multipolygon) fields.
#' @examples
#' get_agricultural_divisions(
#'   census_divisions[census_divisions$prname == "Ontario", ]
#' )
#' @export
get_agricultural_divisions <- function(map = census_divisions) {
  map <- map %>%
    mutate(cdname2 = gsub("\\s+", " ", !!sym("cdname"))) %>%
    left_join(
      matches_for_aggregation$agricultural_divisions %>%
        select(!!!syms(c("cdname", "caruid", "carname"))),
      by = c("cdname2" = "cdname")
    ) %>%
    select(-!!sym("cdname2"))

  # this comes from email communication (see the XLSX in data_xlsx/)
  map <- map %>%
    mutate(
      caruid = case_when(
        pruid == 60L ~ 1L,
        pruid == 61L ~ 1L,
        pruid == 62L ~ 1L,
        TRUE ~ caruid
      ),
      carname = case_when(
        pruid == 60L ~ "Yukon",
        pruid == 61L ~ "Northwest Territories",
        pruid == 62L ~ "Nunavut",
        TRUE ~ carname
      )
    )

  # special cases due to added french names
  map <- map %>%
    mutate(
      caruid = case_when(
        cdname == "Greater Sudbury / Grand Sudbury" ~ 5L,
        cdname == "Minganie - Le Golfe-du-Saint-Laurent" ~ 2L,
        cdname == "Sept-Rivi\u00e8res - Caniapiscau" ~ 2L,
        TRUE ~ caruid
      ),
      carname = case_when(
        cdname == "Greater Sudbury / Grand Sudbury" ~ "Northern Ontario Region",
        cdname == "Minganie - Le Golfe-du-Saint-Laurent" ~ "Saguenay - Lac-Saint-Jean - C\u00f4te-Nord",
        cdname == "Sept-Rivi\u00e8res - Caniapiscau" ~ "Saguenay - Lac-Saint-Jean - C\u00f4te-Nord",
        TRUE ~ carname
      )
    )

  prnames <- map %>%
    select(!!!syms(c("caruid", "carname", "pruid", "prname"))) %>%
    distinct()

  map <- map %>%
    mutate(geometry = st_make_valid(!!sym("geometry"))) %>%
    group_by(!!sym("caruid")) %>%
    summarise(geometry = st_union(!!sym("geometry")), do_union = TRUE) %>%
    as_tibble() %>%
    left_join(prnames, by = "caruid") %>%
    select(!!!syms(c("caruid", "carname", "pruid", "prname", "geometry")))

  return(map)
}
