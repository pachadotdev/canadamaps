
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/pachadotdev/canadamaps/workflows/R-CMD-check/badge.svg)](https://github.com/pachadotdev/canadamaps/actions)
<!-- badges: end -->

# canadamaps

## General idea

The idea is to avoid “duplications”, for example instead of adding a
provinces map or others, we provide functions to sum Census Divisions in
all possible cases.

``` r
library(ggplot2)
library(canadamaps)

ggplot(data = census_divisions) + 
  geom_sf(aes(geometry = geometry)) +
  labs(title = "Canada's Census Divisions")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
# same idea as the same plot, different aggregation
#
# ggplot(data = get_agricultural_divisions()) + 
#   geom_sf(aes(geometry = geometry)) +
#   labs(title = "Canada's Census Agricultural Regions")
# 
# ggplot(data = get_economic_regions()) + 
#   geom_sf(aes(geometry = geometry)) +
#   labs(title = "Canada's Economic Regions")
# 
# ggplot(data = federal_electoral_districts) + 
#   geom_sf(aes(geometry = geometry)) +
#   labs(title = "Canada's Federal Electoral Districts")
# 
# ggplot(data = get_provinces()) + 
#   geom_sf(aes(geometry = geometry)) +
#   labs(title = "Canada's Provinces")
```

## Using real data

Example (after loading the packages above): Let’s say I want to
replicate the map from
<https://health-infobase.canada.ca/covid-19/vaccination-coverage/>,
which was checked on 2021-10-23 and was updated up to 2021-10-16.

``` r
library(readr)
library(dplyr)

url <- "https://health-infobase.canada.ca/src/data/covidLive/vaccination-coverage-map.csv"
csv <- paste0("data_processing/", gsub(".*/", "", url))
if (!file.exists(csv)) download.file(url, csv)

colours <- c("#efefa2", "#c2e699", "#78c679", "#31a354", "#006837")

vaccination <- read_csv(csv) %>% 
  filter(week_end == as.Date("2021-10-16"), pruid != 1) %>% 
  select(pruid, proptotal_atleast1dose)

vaccination <- vaccination %>% 
  left_join(get_provinces(), by = "pruid") %>% # canadamaps in action
  mutate(
    label = paste(gsub(" /.*", "", prname),
                  paste0(proptotal_atleast1dose, "%"), sep = "\n"),
  )

# devtools::install_github("yutannihilation/ggsflabel")

vaccination %>% 
  ggplot() +
  geom_sf(aes(fill = proptotal_atleast1dose, geometry = geometry)) +
  # geom_sf_label(aes(label = label, geometry = geometry)) +
  # improve label positioning with
  ggsflabel::geom_sf_label_repel(aes(label = label, geometry = geometry)) +
  scale_fill_gradientn(colours = colours, name = "Cumulative percent") +
  labs(title = "Cumulative percent of the population who have received at least 1 dose of a COVID-19 vaccine") +
  theme_minimal(base_size = 13)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

## Units of aggregation

### Census Division

The finest division in this package is the Census Division (CDs) which
can be of the next types (reference:
<https://www.statcan.gc.ca/en/subjects/standard/sgc/2011/sgc-tab-d>).

| Language form of CD type | Abbreviation for English language publications | Title for English language publications | Abbreviation for French language publications | Title for French language publications | Abbreviation for bilingual publications | Title for bilingual publications          |
|--------------------------|------------------------------------------------|-----------------------------------------|-----------------------------------------------|----------------------------------------|-----------------------------------------|-------------------------------------------|
| Bilingual                | CDR                                            | Census division                         | CDR                                           | Division de recensement                | CDR                                     | Census division / Division de recensement |
| Bilingual                | CT                                             | County                                  | CT                                            | Comté                                  | CT                                      | County / Comté                            |
| English only             | CTY                                            | County                                  | CTY                                           | County                                 | CTY                                     | County                                    |
| English only             | DIS                                            | District                                | DIS                                           | District                               | DIS                                     | District                                  |
| English only             | DM                                             | District municipality                   | DM                                            | District municipality                  | DM                                      | District municipality                     |
| French only              | MRC                                            | Municipalité régionale de comté         | MRC                                           | Municipalité régionale de comté        | MRC                                     | Municipalité régionale de comté           |
| English only             | RD                                             | Regional district                       | RD                                            | Regional district                      | RD                                      | Regional district                         |
| English only             | REG                                            | Region                                  | REG                                           | Region                                 | REG                                     | Region                                    |
| English only             | RM                                             | Regional municipality                   | RM                                            | Regional municipality                  | RM                                      | Regional municipality                     |
| French only              | TÉ                                             | Territoire équivalent                   | TÉ                                            | Territoire équivalent                  | TÉ                                      | Territoire équivalent                     |
| Bilingual                | TER                                            | Territory                               | TER                                           | Territoire                             | TER                                     | Territory / Territoire                    |
| English only             | UC                                             | United counties                         | UC                                            | United counties                        | UC                                      | United counties                           |

The division type is specified in the `census_divisions` table.

### Census Agricultural Regions

Census Agricultural Regions (CARs) can be obtained as sums of CDs.
Excluding some special cases for Northwestern Territories, Nunavur and
Yukon that we clarified over email communication, the source to match
CDs to CARs was obtained from [Census of Agriculture Reference
Maps](https://www150.statcan.gc.ca/n1/pub/95-630-x/95-630-x2017000-eng.htm)
and manually organized in a spreadsheet
(<https://github.com/pachadotdev/canadamaps/tree/main/data_xlsx>).

### Economic Regions

Economic Regions (ERs) can be obtained as sums of CDs. The only special
case is the Halton, which belongs to two economic zones and it’s the
only CD that has to be carefully separated (i.e. see
<https://github.com/pachadotdev/canadamaps/blob/main/data_processing/02_census_divisions_and_derivatives.R>).

### Federal Electoral Districts

These cannot be obtained as sums of CDs, therefore these are stored in
their own table `federal_electoral_districts`.
