if (!require("pacman")) { install.packages("pacman") }
pacman::p_load(sf, rmapshaper, readr, dplyr, janitor, ggplot2, usethis)

# geodata custom functions ------------------------------------------------

tidy_sf <- function(x, simplify = TRUE, keep = 0.05) {
  d <- sf::read_sf(x)

  if (simplify == TRUE) {
    d <- rmapshaper::ms_simplify(d, keep = keep)
  }

  d <- clean_names(d)

  return(d)
}

aggregate_census_divisions <- function(x, field = NULL) {
  d <- rmapshaper::ms_dissolve(x, field)
  return(d)
}

