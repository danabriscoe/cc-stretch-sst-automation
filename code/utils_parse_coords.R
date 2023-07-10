## parse lat long.R

## short script to convert lat/long coords 
# see: https://docs.ropensci.org/parzer/reference/parse_lon_lat.html

# then use output to update actual shipping locations
make180 <- function(lon){
  isnot360<-min(lon)<0
  if (!isnot360) {
    ind<-which(lon>180)
    lon[ind]<-lon[ind]-360
  }
  return(lon)
}
make360 <- function(lon){
  isnot360<-min(lon)<0
  if(isnot360){
    ind<-which(lon<0)
    lon[ind]<-lon[ind]+360
  }
  return(lon)
}



lat = c("36° 59.0")
long = c("145° 36.6")
# 36°59.0N
# 145°36.6E
parzer::parse_lon_lat(lon = long, lat = lat)

parzer::parse_lon_lat(lon = "153° 12.0", lat = "39° 22.9")
parzer::parse_lon_lat(lon = "161° 55.1", lat = "41° 29.9")

parzer::parse_lon_lat(lon = "170° 33.5", lat = "42° 50.8")
parzer::parse_lon_lat(lon = "179° 44.1", lat = "43° 32.6")

parzer::parse_lon_lat(lon = "170° 09.7", lat = "42° 49.9")

make360(-170.1617)

parzer::parse_lon_lat(lon = "161° 35.6", lat = "42° 11.0")
# lon      lat
# 161.5933 42.18333
make360(-161.5933)

parzer::parse_lon_lat(lon = "153° 20.5", lat = "40° 56.1")
40°56.1N
153°20.5W
# lon      lat
# 153.3417 40.935
make360(-153.3417)
# [1] 206.6583
