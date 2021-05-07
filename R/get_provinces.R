#' Mapa de Canada a nivel provincial - WRITE IN ENGLISH !!!!
#' @description Este mapa es calculado a partir
#' del mapa censal para no recargar el volumen de datos del paquete.
#' @param mapa mapa a agregar, por defecto es todo el mapa nacional
#' @importFrom rmapshaper ms_dissolve
#' @importFrom sf st_as_sf
#' @importFrom dplyr as_tibble
#' @importFrom magrittr %>%
#' @return Un objeto de clase sf y data.frame.
#' @examples
#' get_provinces()
#' @export
get_provinces <- function(map = canadamaps::census_divisions) {
  ms_dissolve(st_as_sf(map), field = "prname") %>%
    as_tibble()
}
