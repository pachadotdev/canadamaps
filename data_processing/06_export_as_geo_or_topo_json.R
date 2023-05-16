# install_github("pachadotdev/canadamaps")
library(canadamaps)

library(sf)
library(geojsonio)

# Provinces ----

provinces <- get_provinces()
provinces <- st_as_sf(provinces)

try(dir.create("data_geojson"))
try(dir.create("data_topojson"))

geojson_write(provinces, file = "data_geojson/provinces.geojson")

provinces2 <- readLines("data_geojson/provinces.geojson")
provinces2 <- geo2topo(provinces2, object_name = "provinces")
writeLines(provinces2, "data_topojson/provinces.topojson")

# Agricultural divisions ----

# agricultural_divisions <- get_agricultural_divisions()
# agricultural_divisions <- st_as_sf(agricultural_divisions)
#
# geojson_write(agricultural_divisions, file = "data_geojson/agricultural_divisions.geojson")
#
# agricultural_divisions2 <- readLines("data_geojson/agricultural_divisions.geojson")
# agricultural_divisions2 <- geo2topo(agricultural_divisions2, object_name = "agricultural_divisions")
# writeLines(agricultural_divisions2, "data_topojson/agricultural_divisions.topojson")

# Economic regions ----

economic_regions <- get_economic_regions()
economic_regions <- st_as_sf(economic_regions)

geojson_write(economic_regions, file = "data_geojson/economic_regions.geojson")

economic_regions2 <- readLines("data_geojson/economic_regions.geojson")
economic_regions2 <- geo2topo(economic_regions2, object_name = "economic_regions")
writeLines(economic_regions2, "data_topojson/economic_regions.topojson")

# Census divisions ----

census_divisions <- st_as_sf(census_divisions)

geojson_write(census_divisions, file = "data_geojson/census_divisions.geojson")

census_divisions2 <- readLines("data_geojson/census_divisions.geojson")
census_divisions2 <- geo2topo(census_divisions2, object_name = "census_divisions")
writeLines(census_divisions2, "data_topojson/census_divisions.topojson")

# Federal electoral districts ----

federal_electoral_districts <- st_as_sf(federal_electoral_districts)

geojson_write(federal_electoral_districts, file = "data_geojson/federal_electoral_districts.geojson")

federal_electoral_districts2 <- readLines("data_geojson/federal_electoral_districts.geojson")
federal_electoral_districts2 <- geo2topo(federal_electoral_districts2, object_name = "federal_electoral_districts")
writeLines(federal_electoral_districts2, "data_topojson/federal_electoral_districts.topojson")
