## parse lat long.R

## short script to convert lat/long coords 
# see: https://docs.ropensci.org/parzer/reference/parse_lon_lat.html

# then use output to update actual shipping locations

lat = c("36° 59.0")
long = c("145° 36.6")
# 36°59.0N
# 145°36.6E
parzer::parse_lon_lat(lon = long, lat = lat)