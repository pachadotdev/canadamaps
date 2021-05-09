try(dir.create("data_shp"))

links <- list(
  provinces_territories = "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lpr_000b16a_e.zip",
  federal_electoral_districts = "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lfed000b16a_e.zip",
  economic_regions = "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/ler_000b16a_e.zip",
  census_divisions = "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lcd_000b16a_e.zip",
  geographic_attributes = "https://www12.statcan.gc.ca/census-recensement/2016/geo/ref/gaf/files-fichiers/2016_92-151_XBB_csv.zip"
)

for (i in names(links)) {
  fout <- paste0("data_shp/", i, ".zip")
  if (!file.exists(fout)) {
    download.file(links[[i]], fout, method = "curl")
  }

  if (!dir.exists(paste0("data_shp/", i))) {
    unzip(fout, exdir = paste0("data_shp/", i))
  }
}
