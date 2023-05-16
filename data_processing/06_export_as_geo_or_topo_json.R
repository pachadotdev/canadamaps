# install_github("pachadotdev/canadamaps")
library(canadamaps)

library(sf)
library(geojsonio)

try(dir.create("data_topojson"))

# Provinces ----

provinces <- get_provinces() %>%
  st_as_sf() %>%
  st_transform(4326)

topojson_write(provinces, file = "data_topojson/provinces.topojson", crs = 4326)

# Agricultural divisions ----

agricultural_divisions <- get_agricultural_divisions() %>%
  st_as_sf() %>%
  st_transform(4326)

topojson_write(agricultural_divisions, file = "data_topojson/agricultural_divisions.topojson", crs = 4326)

# Economic regions ----

economic_regions <- get_economic_regions() %>%
  st_as_sf() %>%
  st_transform(4326)

topojson_write(economic_regions, file = "data_topojson/economic_regions.topojson", crs = 4326)

# Census divisions ----

census_divisions <- census_divisions %>%
  st_as_sf() %>%
  st_transform(4326)

topojson_write(census_divisions, file = "data_topojson/census_divisions.topojson", crs =4326)

# Federal electoral districts ----

federal_electoral_districts <- federal_electoral_districts %>%
  st_as_sf() %>%
  st_transform(4326)

topojson_write(federal_electoral_districts, file = "data_topojson/federal_electoral_districts.topojson", crs = 4326)
