
<!-- README.md is generated from README.Rmd. Please edit that file -->

# findSVI <a href="https://heli-xu.github.io/findSVI/"><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/heli-xu/findSVI/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/heli-xu/findSVI/actions/workflows/R-CMD-check.yaml)

[![DOI](https://joss.theoj.org/papers/10.21105/joss.06525/status.svg)](https://doi.org/10.21105/joss.06525)

<!-- badges: end -->

The goal of findSVI is to calculate regional CDC/ATSDR Social
Vulnerability Index (SVI) (former site:
www.atsdr.cdc.gov/placeandhealth/svi/index.html) at a geographic level
of interest using US census data from American Community Survey.

## Overview

CDC/ATSDR releases SVI biannually at the counties/census tracts level
for US or an individual state. findSVI aims to support more flexible and
specific SVI analysis with additional options for years (2012-2022) and
geographic levels (e.g., ZCTA/places, combining multiple states).

To find SVI for one or multiple year-state pair(s):

- `find_svi()`: retrieves US census data (Census API key required) and
  calculates SVI based on CDC/ATSDR SVI documentation
  (www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html)
  for each year-state pair at the same geography level.

In most cases, `find_svi()` would be the easiest option. If you’d like
to include simple feature geometry or have more customized requests for
census data retrieval (e.g., different geography level for each
year-state pair, multiple states for one year), you can process
individual entry using the following:

- `get_census_data()`: retrieves US census data (Census API key
  required);
- `get_svi()`: calculates SVI from the census data supplied.

Essentially, `find_svi()` is a wrapper function for `get_census_data()`
and `get_svi()` that also supports iteration over 1-year-and-1-state
pairs at the same geography level.

## Installation

Install the findSVI package via CRAN:

``` r
install.packages("findSVI")
```

Alternatively, you can install the development version of findSVI from
GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("heli-xu/findSVI")
```

## Usage

**To find county-level SVI for New Jersey (NJ) for 2017, and for
Pennsylvania (PA) for 2018:**

``` r
library(findSVI)
library(dplyr)

summarise_results <- find_svi(
  year = c(2017, 2018),
  state = c("NJ", "PA"),
  geography = "county"
)
summarise_results %>% 
  group_by(year, state) %>% 
  slice_head(n = 5)
```

    #> # A tibble: 10 × 8
    #> # Groups:   year, state [2]
    #>    GEOID RPL_theme1 RPL_theme2 RPL_theme3 RPL_theme4 RPL_themes  year state
    #>    <chr>      <dbl>      <dbl>      <dbl>      <dbl>      <dbl> <dbl> <chr>
    #>  1 34001      0.95      0.8        0.65        1          0.95   2017 NJ   
    #>  2 34003      0.2       0.3        0.55        0.45       0.25   2017 NJ   
    #>  3 34005      0.3       0.5        0.35        0.4        0.3    2017 NJ   
    #>  4 34007      0.7       0.9        0.55        0.6        0.75   2017 NJ   
    #>  5 34009      0.65      0.6        0.1         0.55       0.45   2017 NJ   
    #>  6 42001      0.212     0.242      0.697       0.227      0.182  2018 PA   
    #>  7 42003      0.136     0.0758     0.742       0.576      0.212  2018 PA   
    #>  8 42005      0.621     0.530      0.0152      0.167      0.227  2018 PA   
    #>  9 42007      0.182     0.409      0.530       0.348      0.197  2018 PA   
    #> 10 42009      0.712     0.606      0.0758      0.288      0.394  2018 PA

(First 5 rows of results for 2017-NJ and 2018-PA are shown.
‘RPL_themes\` indicates overall SVI, and ’RPL_theme1’ to ‘RPL_theme4’
indicate theme-specific SVIs.)

**To retrieve county-level census data *and then* get SVI for PA for
2020:**

``` r
data <- get_census_data(2020, "county", "PA")
data[1:10, 1:10]
```

    #> # A tibble: 10 × 10
    #>    GEOID NAME        B06009_002E B06009_002M B09001_001E B09001_001M B11012_010E
    #>    <chr> <chr>             <dbl>       <dbl>       <dbl>       <dbl>       <dbl>
    #>  1 42001 Adams Coun…        7788         602       20663          NA        1237
    #>  2 42003 Allegheny …       45708        1713      228296          49       24311
    #>  3 42005 Armstrong …        3973         305       12516           9         912
    #>  4 42007 Beaver Cou…        7546         640       31915          NA        3380
    #>  5 42009 Bedford Co…        3996         317        9386          11         468
    #>  6 42011 Berks Coun…       36488        1356       93714          44        8812
    #>  7 42013 Blair Coun…        7292         679       24920          19        2552
    #>  8 42015 Bradford C…        4395         362       13358          NA         969
    #>  9 42017 Bucks Coun…       25651        1306      128008          53        8222
    #> 10 42019 Butler Cou…        6118         468       37577          NA        2121
    #> # ℹ 3 more variables: B11012_010M <dbl>, B11012_015E <dbl>, B11012_015M <dbl>

(First 10 rows and columns are shown, with the rest of columns being
other census variables for SVI calculation.)

``` r
result <- get_svi(2020, data)
glimpse(result)
```

    #> Rows: 67
    #> Columns: 63
    #> $ GEOID       <chr> "42001", "42003", "42005", "42007", "42009", "42011", "420…
    #> $ NAME        <chr> "Adams County, Pennsylvania", "Allegheny County, Pennsylva…
    #> $ E_TOTPOP    <dbl> 102627, 1218380, 65356, 164781, 48154, 419062, 122495, 607…
    #> $ E_HU        <dbl> 42525, 602416, 32852, 79587, 24405, 167514, 56960, 30691, …
    #> $ E_HH        <dbl> 39628, 545695, 28035, 72086, 19930, 156389, 51647, 25084, …
    #> $ E_POV150    <dbl> 13573, 212117, 13566, 28766, 10130, 77317, 27397, 13731, 5…
    #> $ E_UNEMP     <dbl> 2049, 32041, 1735, 4249, 1033, 12196, 2765, 1331, 14477, 4…
    #> $ E_HBURD     <dbl> 9088, 133524, 5719, 15764, 3952, 40982, 12146, 5520, 57197…
    #> $ E_NOHSDP    <dbl> 7788, 45708, 3973, 7546, 3996, 36488, 7292, 4395, 25651, 6…
    #> $ E_UNINSUR   <dbl> 5656, 46333, 2632, 6242, 3310, 25627, 6155, 3992, 25208, 6…
    #> $ E_AGE65     <dbl> 20884, 230745, 14496, 35351, 10950, 72293, 25372, 12948, 1…
    #> $ E_AGE17     <dbl> 20663, 228296, 12516, 31915, 9386, 93714, 24920, 13358, 12…
    #> $ E_DISABL    <dbl> 13860, 163671, 11431, 25878, 7797, 57961, 20278, 8731, 653…
    #> $ E_SNGPNT    <dbl> 1719, 29689, 1159, 4167, 681, 10507, 3096, 1397, 11396, 29…
    #> $ E_LIMENG    <dbl> 1318, 9553, 130, 606, 64, 16570, 388, 172, 11502, 449, 185…
    #> $ E_MINRTY    <dbl> 11624, 269795, 2096, 18205, 1672, 123611, 7120, 2733, 1089…
    #> $ E_MUNIT     <dbl> 821, 82729, 1180, 4563, 635, 11010, 3629, 1011, 25508, 660…
    #> $ E_MOBILE    <dbl> 2882, 4147, 3289, 3012, 3491, 4628, 4094, 4419, 4764, 6464…
    #> $ E_CROWD     <dbl> 468, 4697, 238, 693, 217, 1878, 451, 472, 2916, 489, 446, …
    #> $ E_NOVEH     <dbl> 1726, 72338, 2058, 5824, 961, 13331, 4216, 2086, 11711, 49…
    #> $ E_GROUPQ    <dbl> 4140, 33976, 795, 2933, 481, 13171, 3289, 736, 9462, 5592,…
    #> $ EP_POV150   <dbl> 13.8, 17.9, 21.0, 17.7, 21.4, 19.0, 22.9, 22.9, 9.7, 13.2,…
    #> $ EP_UNEMP    <dbl> 3.9, 4.9, 5.5, 5.1, 4.5, 5.6, 4.7, 4.7, 4.2, 4.6, 5.2, 10.…
    #> $ EP_HBURD    <dbl> 22.9, 24.5, 20.4, 21.9, 19.8, 26.2, 23.5, 22.0, 23.8, 19.4…
    #> $ EP_NOHSDP   <dbl> 10.8, 5.2, 8.2, 6.2, 11.3, 12.8, 8.3, 10.2, 5.7, 4.6, 8.0,…
    #> $ EP_UNINSUR  <dbl> 5.6, 3.8, 4.1, 3.8, 6.9, 6.2, 5.1, 6.6, 4.1, 3.3, 4.1, 3.2…
    #> $ EP_AGE65    <dbl> 20.3, 18.9, 22.2, 21.5, 22.7, 17.3, 20.7, 21.3, 18.7, 18.8…
    #> $ EP_AGE17    <dbl> 20.1, 18.7, 19.2, 19.4, 19.5, 22.4, 20.3, 22.0, 20.4, 20.0…
    #> $ EP_DISABL   <dbl> 13.7, 13.6, 17.6, 15.8, 16.3, 14.0, 16.8, 14.5, 10.5, 12.8…
    #> $ EP_SNGPNT   <dbl> 4.3, 5.4, 4.1, 5.8, 3.4, 6.7, 6.0, 5.6, 4.7, 3.8, 5.3, 8.1…
    #> $ EP_LIMENG   <dbl> 1.4, 0.8, 0.2, 0.4, 0.1, 4.2, 0.3, 0.3, 1.9, 0.3, 0.1, 0.0…
    #> $ EP_MINRTY   <dbl> 11.3, 22.1, 3.2, 11.0, 3.5, 29.5, 5.8, 4.5, 17.4, 5.6, 7.6…
    #> $ EP_MUNIT    <dbl> 1.9, 13.7, 3.6, 5.7, 2.6, 6.6, 6.4, 3.3, 10.1, 7.9, 5.7, 2…
    #> $ EP_MOBILE   <dbl> 6.8, 0.7, 10.0, 3.8, 14.3, 2.8, 7.2, 14.4, 1.9, 7.7, 4.7, …
    #> $ EP_CROWD    <dbl> 1.2, 0.9, 0.8, 1.0, 1.1, 1.2, 0.9, 1.9, 1.2, 0.6, 0.8, 1.2…
    #> $ EP_NOVEH    <dbl> 4.4, 13.3, 7.3, 8.1, 4.8, 8.5, 8.2, 8.3, 4.9, 6.4, 11.0, 9…
    #> $ EP_GROUPQ   <dbl> 4.0, 2.8, 1.2, 1.8, 1.0, 3.1, 2.7, 1.2, 1.5, 3.0, 5.1, 1.7…
    #> $ EPL_POV150  <dbl> 0.0758, 0.2727, 0.5303, 0.2424, 0.5606, 0.3788, 0.6818, 0.…
    #> $ EPL_UNEMP   <dbl> 0.1212, 0.4242, 0.6818, 0.5000, 0.2576, 0.6970, 0.3636, 0.…
    #> $ EPL_HBURD   <dbl> 0.5303, 0.6970, 0.2424, 0.4394, 0.1970, 0.8636, 0.5909, 0.…
    #> $ EPL_NOHSDP  <dbl> 0.7273, 0.0152, 0.2424, 0.1061, 0.8182, 0.9091, 0.2727, 0.…
    #> $ EPL_UNINSUR <dbl> 0.5152, 0.1061, 0.1364, 0.1061, 0.7424, 0.6667, 0.3939, 0.…
    #> $ EPL_AGE65   <dbl> 0.4848, 0.2727, 0.7879, 0.7121, 0.8788, 0.0909, 0.5606, 0.…
    #> $ EPL_AGE17   <dbl> 0.5909, 0.1970, 0.2576, 0.3333, 0.3939, 0.9091, 0.6212, 0.…
    #> $ EPL_DISABL  <dbl> 0.2576, 0.2273, 0.7727, 0.5000, 0.5909, 0.3333, 0.6667, 0.…
    #> $ EPL_SNGPNT  <dbl> 0.2273, 0.6364, 0.1515, 0.7424, 0.0455, 0.8636, 0.7879, 0.…
    #> $ EPL_LIMENG  <dbl> 0.7576, 0.6515, 0.0909, 0.2879, 0.0303, 0.9697, 0.1667, 0.…
    #> $ EPL_MINRTY  <dbl> 0.6515, 0.8636, 0.0303, 0.6364, 0.0455, 0.9242, 0.2879, 0.…
    #> $ EPL_MUNIT   <dbl> 0.1515, 0.9545, 0.4242, 0.6970, 0.1970, 0.7727, 0.7576, 0.…
    #> $ EPL_MOBILE  <dbl> 0.4394, 0.0303, 0.6818, 0.2121, 0.9091, 0.1515, 0.5000, 0.…
    #> $ EPL_CROWD   <dbl> 0.4091, 0.1818, 0.0909, 0.2576, 0.3333, 0.4091, 0.1818, 0.…
    #> $ EPL_NOVEH   <dbl> 0.0000, 0.9848, 0.4545, 0.5909, 0.0455, 0.6818, 0.6061, 0.…
    #> $ EPL_GROUPQ  <dbl> 0.6667, 0.4697, 0.0758, 0.2879, 0.0455, 0.5455, 0.4394, 0.…
    #> $ SPL_theme1  <dbl> 1.9698, 1.5152, 1.8333, 1.3940, 2.5758, 3.5152, 2.3029, 2.…
    #> $ SPL_theme2  <dbl> 2.3182, 1.9849, 2.0606, 2.5757, 1.9394, 3.1666, 2.8031, 2.…
    #> $ SPL_theme3  <dbl> 0.6515, 0.8636, 0.0303, 0.6364, 0.0455, 0.9242, 0.2879, 0.…
    #> $ SPL_theme4  <dbl> 1.6667, 2.6211, 1.7272, 2.0455, 1.5304, 2.5606, 2.4849, 2.…
    #> $ RPL_theme1  <dbl> 0.2424, 0.1667, 0.1970, 0.1364, 0.5455, 0.9242, 0.3636, 0.…
    #> $ RPL_theme2  <dbl> 0.3788, 0.2121, 0.2273, 0.5758, 0.1667, 0.9091, 0.6970, 0.…
    #> $ RPL_theme3  <dbl> 0.6515, 0.8636, 0.0303, 0.6364, 0.0455, 0.9242, 0.2879, 0.…
    #> $ RPL_theme4  <dbl> 0.1212, 0.5606, 0.1515, 0.2576, 0.0455, 0.5152, 0.4848, 0.…
    #> $ SPL_themes  <dbl> 6.6062, 6.9848, 5.6514, 6.6516, 6.0911, 10.1666, 7.8788, 8…
    #> $ RPL_themes  <dbl> 0.2273, 0.2879, 0.0909, 0.2424, 0.1667, 0.9545, 0.5152, 0.…

**To find SVI for custom geographic boundaries:**

``` r
cz_svi <- find_svi_x(
  year = 2020,
  geography = "county",
  xwalk = cty_cz_2020_xwalk #county-commuting zone crosswalk
)
```

…where `xwalk` is supplied by users to define the relationship between a
Census geography (‘GEOID’) and the custom geographic level (‘GEOID2’).
The Census geography should be fully nested in the custom geographic
level of interest. As an example, first 10 rows of the county-commuting
zone crosswalk are shown below:

``` r
cty_cz_2020_xwalk %>% head(10)
#>    GEOID GEOID2
#> 1  01069      3
#> 2  01023      9
#> 3  01005      3
#> 4  01107      4
#> 5  01033     10
#> 6  04012     37
#> 7  04001     32
#> 8  05081     55
#> 9  05121     46
#> 10 06037     37
```

With the crosswalk, county-level census data are aggregated to the
commuting zone-level, and SVI is calculated for each commuting zone.
Below shows the overall and theme-specific SVI of the first 10 rows,
with GEOIDs representing the commuting zone IDs.

``` r
cz_svi %>% 
  select(GEOID, contains("RPL")) %>%
  head(10)
```

    #> # A tibble: 10 × 6
    #>    GEOID RPL_theme1 RPL_theme2 RPL_theme3 RPL_theme4 RPL_themes
    #>    <int>      <dbl>      <dbl>      <dbl>      <dbl>      <dbl>
    #>  1     1      0.778      0.833      0.885     0.730       0.826
    #>  2     2      0.734      0.436      0.698     0.388       0.625
    #>  3     3      0.871      0.892      0.703     0.570       0.833
    #>  4     4      0.881      0.498      0.838     0.947       0.876
    #>  5     5      0.560      0.675      0.684     0.333       0.606
    #>  6     6      0.799      0.813      0.605     0.302       0.720
    #>  7     7      0.821      0.680      0.802     0.875       0.842
    #>  8     8      0.694      0.888      0.438     0.0842      0.570
    #>  9     9      0.899      0.969      0.838     0.918       0.962
    #> 10    10      0.357      0.507      0.589     0.134       0.335
