# federal electoral district ----

federal_electoral_districts_rda <- "data/federal_electoral_districts.rda"

if (!file.exists(federal_electoral_districts_rda)) {
  federal_electoral_districts <- tidy_sf("data_shp/federal_electoral_districts/lfed000b16a_e.shp")

  federal_electoral_districts <- federal_electoral_districts %>%
    mutate(feduid = as.integer(feduid), pruid = as.integer(pruid))

  federal_electoral_districts <- as_tibble(federal_electoral_districts)

  federal_electoral_districts <- federal_electoral_districts %>%
    select(-c(fedename, fedfname))

  use_data(federal_electoral_districts, compress = "xz", overwrite = T)
} else {
  load(federal_electoral_districts_rda)
}
