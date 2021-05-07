# census by commune ----

census_divisions_rda <- "data/census_divisions.rda"

if (!file.exists(census_divisions_rda)) {
  census_divisions <- tidy_sf("data_shp/census_divisions/lcd_000b16a_e.shp")
  use_data(census_divisions, compress = "xz")
} else {
  load(census_divisions_rda)
}
