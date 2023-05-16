matches_for_aggregation <- list(
  agricultural_divisions = agricultural_divisions,
  cduid_eruid = cduid_eruid,
  halton_special_case = halton_special_case
)

matches_for_aggregation$halton_special_case <- matches_for_aggregation$halton_special_case %>%
  st_as_sf() %>%
  st_transform("NAD83") %>%
  as_tibble()

use_data(matches_for_aggregation, compress = "xz", internal = T, overwrite = T)
