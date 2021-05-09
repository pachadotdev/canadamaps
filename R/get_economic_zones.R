#' Mapa de Canada a nivel zona economica - WRITE IN ENGLISH !!!!
#' @description Este mapa es calculado a partir
#' del mapa censal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @importFrom sf st_as_sf
#' @importFrom dplyr as_tibble filter select left_join
#' @importFrom magrittr %>%
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' get_provinces()
#' @export
get_economic_zones <- function(map = census_divisions) {
  map <- map %>%
    filter(cduid != 3524) %>%
    left_join(canadamaps::cduid_eruid, by = "cduid")

  eruid_pruid <- map %>%
    as_tibble() %>%
    select(eruid, ername, pruid, prname) %>%
    distinct()

  map <- ms_dissolve(st_as_sf(map), field = "eruid")

  map <- map %>%
    bind_rows(
      halton_special_case %>% select(eruid, geometry)
    )

  map <- ms_dissolve(st_as_sf(map), field = "eruid")

  map <- map %>%
    as_tibble() %>%
    left_join(eruid_pruid, by = "eruid")

  map[, c("eruid", "ername", "pruid", "prname", "geometry")]
}
