# install_github("pachadotdev/canadamaps")
library(canadamaps)

library(sf)
library(geojsonio)

try(dir.create("data_topojson"))

# Provinces ----

provinces <- get_provinces() %>%
  st_as_sf()

topojson_write(provinces, file = "data_topojson/provinces.topojson", object_name = "provinces")

# Agricultural divisions ----

agricultural_divisions <- get_agricultural_divisions() %>%
  st_as_sf()

topojson_write(agricultural_divisions, file = "data_topojson/agricultural_divisions.topojson", object_name = "agricultural_divisions")

# Economic regions ----

economic_regions <- get_economic_regions() %>%
  st_as_sf()

topojson_write(economic_regions, file = "data_topojson/economic_regions.topojson", object_name = "economic_regions")

# Census divisions ----

census_divisions <- census_divisions %>%
  st_as_sf()

topojson_write(census_divisions, file = "data_topojson/census_divisions.topojson", object_name = "census_divisions")

# Federal electoral districts ----

federal_electoral_districts <- federal_electoral_districts %>%
  st_as_sf()

topojson_write(federal_electoral_districts, file = "data_topojson/federal_electoral_districts.topojson", object_name = "federal_electoral_districts")
