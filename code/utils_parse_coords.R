## parse lat long.R

## short script to convert lat/long coords 
# see: https://docs.ropensci.org/parzer/reference/parse_lon_lat.html

# then use output to update actual shipping locations

lat = c("36° 59.0")
long = c("145° 36.6")
# 36°59.0N
# 145°36.6E
parzer::parse_lon_lat(lon = long, lat = lat)

parzer::parse_lon_lat(lon = "153° 12.0", lat = "39° 22.9")
parzer::parse_lon_lat(lon = "161° 55.1", lat = "41° 29.9")
