## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning=FALSE, message=FALSE--------------------------------------
library(findSVI)
library(dplyr)

## ----get_census_data, eval=FALSE----------------------------------------------
#  data <- get_census_data(2018, "zcta", "RI")
#  data[1:10, 1:10]

## ----RI_2018raw, echo=FALSE---------------------------------------------------
load(system.file("extdata", "ri_zcta_raw2018.rda", package = "findSVI"))
ri_zcta_raw2018[1:10, 1:10]

## ----get_svi, eval=FALSE------------------------------------------------------
#  result <- get_svi(2018, data)
#  glimpse(result)

## ----RI_result2018, echo=FALSE------------------------------------------------
load(system.file("extdata", "ri_zcta_svi2018.rda", package = "findSVI"))
glimpse(ri_zcta_svi2018)

## ----find_svi, eval=FALSE-----------------------------------------------------
#  onestep_result <- find_svi(2018, "RI", "zcta")
#  onestep_result %>% head(10)

## ----RI_result_RPL, echo=FALSE------------------------------------------------
ri_zcta_svi2018 %>% 
  select(GEOID, contains("RPL_theme")) %>% 
  mutate(year = 2018,
    state = "RI") %>% 
  head(10)

## ----find_svi_vector, eval=FALSE----------------------------------------------
#  summarise_results <- find_svi(
#    year = c(2017, 2018),
#    state = c("NJ", "PA"),
#    geography = "county"
#  )
#  
#  summarise_results %>%
#    group_by(year, state) %>%
#    slice_head(n = 5)

## ----summarise_results_RPL, echo=FALSE----------------------------------------
load(system.file("extdata", "summarise_results.rda", package = "findSVI"))
summarise_results %>% 
  group_by(year, state) %>% 
  slice_head(n = 5)

## ----info_table, echo=FALSE---------------------------------------------------
year <- c(2017,2018, 2014, 2018, 2013, 2020)
state <- c("AZ", "FL", "FL", "PA", "MA", "KY")
info_table <- data.frame(year, state)
info_table

## ----column_find_svi, eval=FALSE----------------------------------------------
#  all_results <- find_svi(
#    year = info_table$year,
#    state = info_table$state,
#    geography = "county"
#  )
#  
#  all_results %>%
#    group_by(year, state) %>%
#    slice_head(n = 3)

## ----echo=FALSE---------------------------------------------------------------
load(system.file("extdata", "slice_all_results.rda", package = "findSVI"))
slice_all_results

## ----eval=FALSE---------------------------------------------------------------
#  cz_svi2020 <- find_svi_x(
#    year = 2020,
#    geography = "county",
#    xwalk = cty_cz_2020_xwalk #county-commuting zone crosswalk
#  )
#  
#  cz_svi2020 %>%
#    select(GEOID, contains("RPL")) %>%
#    head(10)

## ----echo=FALSE---------------------------------------------------------------
load(system.file("extdata","cz_svi2020.rda",package = "findSVI"))
cz_svi2020

