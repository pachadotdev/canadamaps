# federal electoral district ----

agricultural_divisions_rda <- "data/agricultural_divisions.rda"

if (!file.exists(agricultural_divisions_rda)) {
  xlsx <- "data_xlsx/Census Division - Census Agricultural Region.xlsx"
  names <- readxl::excel_sheets(xlsx)
  names <- names[!names %in% c("INSTRUCTIONS", "SPECIAL CASES")]

  agricultural_divisions <- purrr::map_df(
    names,
    function(s) {
      readxl::read_xlsx(xlsx, s)
    }
  )

  agricultural_divisions <- agricultural_divisions %>%
    clean_names() %>%
    mutate(
      cduid = as.integer(cduid),
      caruid = as.integer(caruid),
      pruid = as.integer(pruid)
    )

  use_data(agricultural_divisions, compress = "xz", overwrite = T)
} else {
  load(agricultural_divisions_rda)
}
