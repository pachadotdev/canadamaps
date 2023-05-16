# census zone ----

census_divisions_rda <- "data/census_divisions.rda"

if (!file.exists(census_divisions_rda)) {
  census_divisions <- tidy_sf("data_shp/census_divisions/lcd_000b16a_e.shp")

  census_divisions <- census_divisions %>%
    mutate(cduid = as.integer(cduid), pruid = as.integer(pruid))

  census_divisions <- as_tibble(census_divisions)

  census_divisions <- census_divisions %>%
    mutate(cdname = gsub("--", " - ", cdname))

  # see https://stackoverflow.com/a/76265290/3720258
  census_divisions <- census_divisions %>%
    st_as_sf() %>%
    st_transform(4326) %>%
    as_tibble()

  use_data(census_divisions, compress = "xz", overwrite = T)
} else {
  load(census_divisions_rda)
}

# economic region ----

cduid_eruid_rda <- "data/cduid_eruid.rda"

if (!file.exists(cduid_eruid_rda)) {
  geographic_attributes <- read_csv("data_shp/geographic_attributes/2016_92-151_XBB.csv",
                                    locale = locale(encoding = "ISO-8859-1"))

  cduid_eruid <- geographic_attributes %>%
    select(cduid = `CDuid/DRidu`, eruid = `ERuid/REidu`, ername = `ERname/REnom`) %>%
    distinct() %>%
    mutate_if(is.double, as.integer) %>%
    # Halton belongs to two economic zones !
    filter(cduid != 3524)

  cduid_eruid <- cduid_eruid %>%
    mutate(ername = iconv(ername, from = "", to = "UTF-8"))

  cduid_eruid <- cduid_eruid %>%
    mutate(ername = gsub("--", " - ", ername))

  use_data(cduid_eruid, compress = "xz", overwrite = T)
} else {
  load(cduid_eruid_rda)
}

halton_special_case_rda <- "data/halton_special_case.rda"

if (!file.exists(halton_special_case_rda)) {
  economic_regions_2 <- tidy_sf("data_shp/economic_regions/ler_000b16a_e.shp")

  toronto <- economic_regions_2 %>% filter(ername == "Toronto")
  hamilton <- economic_regions_2 %>% filter(ername == "Hamilton--Niagara Peninsula")

  x <- sf::st_intersection(
    st_as_sf(census_divisions %>% filter(cdname == "Halton")),
    st_as_sf(toronto)
  )

  y <- sf::st_intersection(
    st_as_sf(census_divisions %>% filter(cdname == "Halton")),
    st_as_sf(hamilton)
  )

  ggplot(x) + geom_sf(aes(geometry = geometry))
  ggplot(y) + geom_sf(aes(geometry = geometry))

  y <- st_cast(y, "POLYGON")
  ggplot(y[1,]) + geom_sf(aes(geometry = geometry))
  y <- st_cast(y[1,], "MULTIPOLYGON")
  ggplot(y) + geom_sf(aes(geometry = geometry))

  halton_special_case <- bind_rows(x, y)

  halton_special_case <- halton_special_case %>%
    select(-pruid.1, -prname.1) %>%
    mutate(eruid = as.integer(eruid))

  ggplot(halton_special_case) + geom_sf(aes(geometry = geometry))

  use_data(halton_special_case, compress = "xz", overwrite = T)
} else {
  load(halton_special_case_rda)
}
