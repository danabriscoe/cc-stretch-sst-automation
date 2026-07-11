# convert_coords_dms_dd.R. ## --- USE THIS FOR EACH COHORT Year! -------

## script to convert daily ship based recorded coordinates (lat/long) from degrees min seconds to decimal degrees

install.packages(pkgs='parzer')
parzer::parse_lon_lat(lon = long, lat = lat)

#   # lon      lat
#   # 1  77.03470 49.78230
#   # 2  70.36815 49.79928
#   # 3  69.11739 49.81563
#   # 4  80.20036 49.81560
#   df <- data.frame(lat, long)
# measurements::conv_unit(df$lat[1], from = 'deg_dec_min', to = 'dec_deg') # convert lat column from degrees and decimal minutes into decimal degrees


# ### THIS WORKS!!!  ------------------
# lat = c("33° 47.776")
# long = c("141° 18.781")
# parzer::parse_lon_lat(lon = long, lat = lat)

lat = c("36° 59.0")
long = c("145° 36.6")
# 36°59.0N
# 145°36.6E
parzer::parse_lon_lat(lon = long, lat = lat)


## 28 june 2024 ---- # note: for 2024 xls recordings, use all daily recordings (ie 7:00 UTC & 17:00 UTC)
lat = c("34° 41.2650") #34°41.2650
long = c("139° 42.3146") #139°42.3146
parzer::parse_lon_lat(lon = long, lat = lat)


## 28 june 2024 ---- # note: for 2024 xls recordings, use all daily recordings (ie 7:00 UTC & 17:00 UTC)
lat = c("34° 48.8466") #34°48.8466'N 
long = c("140° 16.8730") #140°16.8730'E
parzer::parse_lon_lat(lon = long, lat = lat)

## 29 june 2024 ----
lat = c("35° 27.3764") #35°27.3764'N 
long = c("139° 40.8445") #139°40.8445'E 
parzer::parse_lon_lat(lon = long, lat = lat)


## 29 june 2024 ----
lat = c("35° 27.3765") #35°27.3765'N 
long = c("139° 40.8438") #1139°40.8438'E 
parzer::parse_lon_lat(lon = long, lat = lat)


## 30 june 2024 ----
lat = c("35° 27.3830") #35°27.3830'N 
long = c("139° 40.8515") #139°40.8515'E 
parzer::parse_lon_lat(lon = long, lat = lat)

## 30 june 2024 ----
lat = c("35° 19.3018") #35°19.3018'N 
long = c("139° 42.9857") #139°42.9857'E 
parzer::parse_lon_lat(lon = long, lat = lat)


## 01 july 2024 ----
lat = c("35° 09.2418") #35°09.2418'N 
long = c("144° 21.5623") #144°21.5623'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 01 july 2024 ----
lat = c("35° 35.8683") #35°35.8683'N 
long = c("148° 00.2031") #148°00.2031'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 02 july 2024 ----
lat = c("35° 53.8686") #35°53.8686'N 
long = c("153° 00.2949") #153°00.2949'E
parzer::parse_lon_lat(lon = long, lat = lat)

## 02 july 2024 ----
lat = c("36° 11.7167") #36°11.7167'N 
long = c("156° 42.7802") #156°42.7802'E
parzer::parse_lon_lat(lon = long, lat = lat)



## 03 july 2024 ----
lat = c("37° 19.0273") #37°19.0273'N 
long = c("161° 58.0409") #161°58.0409'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 03 july 2024 ----
lat = c("38° 08.4196") #38°08.4196'N 
long = c("165° 48.4799") #165°48.4799'E
parzer::parse_lon_lat(lon = long, lat = lat)



## 04 july 2024 ----
lat = c("39° 21.4947") #39°21.4947'N 
long = c("170° 50.5607") #170°50.5607'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 04 july 2024 ----
lat = c("39° 51.6536") #39°51.6536'N 
long = c("174° 48.1040") #174°48.1040'E 
parzer::parse_lon_lat(lon = long, lat = lat)



## 05 july 2024 ---- (aka 04 July UTC) --- USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("40° 31.3708") #40°31.3708'N 
long = c("179° 54.3425") #179°54.3425'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-179.9057)


## 05 july 2024 ---- (aka 05 July UTC)
lat = c("40° 46.3810") #40°46.3810'N 
long = c("175° 58.2309") #175°58.2309'W 
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-175.9705)


## 05 july 2024 ---- (aka 05 July UTC PART 2) --- USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("41° 05.9863") #41°05.9863'N 
long = c("170° 54.3423.828325") #170°23.8283'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-170.9057)


## 06 july 2024 ---- (aka 05 July UTC PART 2)
lat = c("41° 01.8992") #41°01.8992'N 166°21.6975'W
long = c("166° 21.6975") #166°21.6975'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-166.3616)



## 06 july 2024 ---- 
lat = c("40° 53.4876") #40°53.4876'N 
long = c("161° 03.5578") #161°03.5578'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-161.0593)


## 07 july 2024 ---- (aka 05 July UTC PART 2)
lat = c("40° 31.2070") #40°31.2070'N 
long = c("157° 00.4926") #157°00.4926'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-157.0082)




###### !!!! 08 july 2024 ---- (ACTUAL RELEASE LOCATION - COHORT 2)
lat = c("39° 33.4669") #39°38.0N 
long = c("148° 29.7291") #149°12.8W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-148.4955)

# 39°33.4669' N 148°29.7291' W


#### ---- COHORT 3 -----------
## 26 june 2025 ---- # note: potential new release location (1/2 way between Cohorts 1 & 2 locs)
lat = c("39° 29.587") #39° 29.587
long = c("147° 17.146") #147° 17.146
parzer::parse_lon_lat(lon = long, lat = lat)

# lon      lat
# 147.2858 39.49312


## 30 june 2025 ----
lat = c("35° 28.158") #35°28.158'N
long = c("139° 41.018") #139°41.018'E 
parzer::parse_lon_lat(lon = long, lat = lat)

## 30 june 2025 ----
lat = c("35° 28.158") #35°28.158'N
long = c("139° 41.020") #139°41.020'E
parzer::parse_lon_lat(lon = long, lat = lat)

## 01 july 2025 ---- 
lat = c("35° 21.722") #35°21.722'N
long = c("141° 39.044") #141°39.044'E 
parzer::parse_lon_lat(lon = long, lat = lat)
 
## 01 july 2025 ---- 
lat = c("36° 39.788") #36°39.788'N
long = c("145° 28.2644") #145°28.264'E 
parzer::parse_lon_lat(lon = long, lat = lat)


## 02 july 2025 ---- 
lat = c("38° 30.344") #38°30.344'N
long = c("150° 40.646") #150°40.646'E
parzer::parse_lon_lat(lon = long, lat = lat)

## 02 july 2025 ---- 
lat = c("39° 31.820") #39°31.820'N
long = c("154° 33.092") #154°33.092'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 03 july 2025 ---- 
lat = c("40° 50.065") #40°50.065'N
long = c("159° 34.207") #159°34.207'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 03 july 2025 ---- 
lat = c("41° 32.818") #41°32.818'N
long = c("163° 38.361") #163°38.361'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 04 july 2025 ---- 
lat = c("42° 27.437") #42°27.437'N
long = c("169° 05.581") #169°05.581'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 04 july 2025 ---- 
lat = c("42° 51.410") #42°51.410'N
long = c("173° 23.717") #173°23.717'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 05 july 2025 ---- 
lat = c("43° 15.261") #43°15.261'N
long = c("178° 52.271") #178°52.271'E
parzer::parse_lon_lat(lon = long, lat = lat)


## 04 july 2025 AGAIN ----   USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("43° 17.142") #43°17.142'N
long = c("176° 44.178") #176°44.178'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-176.7363)


## 05 july 2025 AGAIN ----   USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("43° 12.795") #43°12.795'N
long = c("171° 07.380") #171°07.380'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-171.123)


## 05 july 2025 AGAIN ----   USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("42° 51.973") #42°51.973'N
long = c("166° 45.955") #166°45.955'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-166.7659)


## 06 july 2025  ----   USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("42° 15.139") #42°15.139'N
long = c("160° 47.876") #160°47.876'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-160.7979)


## 06 july 2025  ----   USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("41° 30.820") #41°30.820'N
long = c("156° 38.899") #156°38.899'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-156.6483)


## 07 july 2025  ----   USE MAKE 360, NOW ACROSS DATELINE (W)
lat = c("40° 25.667") #40°25.667'N
long = c("151° 09.648") #151°09.648'W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-151.1608)


## 07 july 2025  (Local Time) ---- (ACTUAL RELEASE LOCATION - COHORT 3)
lat = c("39° 41.316N") #439°41.316N
long = c("148° 09.040W") # 148°09.040W
parzer::parse_lon_lat(lon = long, lat = lat)
make360(-148.1507)




#### ---- COHORT 4 -----------
# ## Poss Release Location ---- 
# lat = c("39° 18.9") #39° 29.587
# long = c("146° 03.7") #147° 17.146
# parzer::parse_lon_lat(lon = long, lat = lat)


# ## Poss Release Location ---- upd 1
lat = c("40° 16.4") #40°16.4′N, 
long = c("150° 00.0") #150°00.0′E
parzer::parse_lon_lat(lon = long, lat = lat)

150 40.27333

# ## Poss Release Location ---- upd 2
lat = c("38° 23.5") #38°23.5′N, 
long = c("143° 44.8") #143°44.8′E
parzer::parse_lon_lat(lon = long, lat = lat)

143.7467 38.39167


## 2 july 2026 ---- yokohama
lat = c("35° 27.3916") #35°27.3916'N, 
long = c("139° 40.8324") #139゜40.8324'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 139.6805 35.45653


## 2 july 2026 ---- 
lat = c("35° 27.1822") #35°27.1822'N, 
long = c("139° 40.8764") #139゜40.8764'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 139.6813 35.45304


## 3 july 2026 ---- 
lat = c("36° 10.4402") #36°10.4402'N, 
long = c("143° 38.0953") #143゜38.0953'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 143.6349 36.174


## 3 july 2026 ---- 
lat = c("37° 26.9978") #37°26.9978'N, 
long = c("147° 01.6208") #147゜01.6208'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 147.027 37.44996


## 4 july 2026 ---- 
lat = c("38° 57.3696") #38°57.3696'N, 
long = c("151° 34.8100") #151゜34.8100'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 151.5802 38.95616


## 4 july 2026 ---- 
lat = c("39° 54.4630") #39°54.4630'N, 
long = c("155° 08.6129") #155゜08.6129'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 155.1435 39.90772

## 5 july 2026 ---- 
lat = c("41° 08.7417") #41°08.7417'N, 
long = c("159° 54.0825") #159゜54.0825'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 159.9014 41.1457



## 5 july 2026 ---- 
lat = c("41° 47.4103") #41°47.4103'N,
long = c("163° 43.9002") # 163゜43.9002'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 163.7317 41.79017



## 6 july 2026 ---- 
lat = c("42° 37.4062") #42°37.4062'N, 
long = c("168° 54.7496") # 168゜54.7496'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 168.9125 42.62344


## 6 july 2026 ---- 
lat = c("43° 01.2248") #43°01.2248'N, 
long = c("172° 58.6875") # 172゜58.6875'E 
parzer::parse_lon_lat(lon = long, lat = lat)

# 172.9781 43.02041



## 7 july 2026 ---- 
lat = c("43° 26.4825") #43°26.4825'N, 
long = c("178° 54.2252") # 178゜54.2252'E
parzer::parse_lon_lat(lon = long, lat = lat)

# 178.9038 43.44138


## 7 july 2026 ---- 
lat = c("43° 29.0565") #43°29.0565'N, 
long = c("176° 54.2252") # 176゜51.7368'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 176.9038 43.48427
make360(-176.9038)
# 183.0962



## 7 july 2026 ---- dateline crossing - 7 July 2026 again
lat = c("43° 21.9888") #43°21.9888'N, 
long = c("171° 12.2731") # 171゜12.2731'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 171.2046 43.36648
make360(-171.2046)
# 188.7954



## 7 july 2026 ---- dateline crossing - 7 July 2026 again
lat = c("43° 01.7796") #43°01.7796'N,
long = c("166° 58.6694") # 166゜58.6694'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 166.9778 43.02966
make360(-166.9778)
# 193.0222



## 8 july 2026 ---- 
lat = c("42° 24.1816") #42°24.1816'N, 
long = c("161° 02.2944") # 161°02.2944'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 161.0382 42.40303
make360(-161.0382)
# 198.9618


## 8 july 2026 ---- 
lat = c("41° 41.2952") #41°41.2952'N, 
long = c("157° 00.3209") # 157°00.3209'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 157.0053 41.68825
make360(-157.0053)
# 202.9947



## 9 july 2026 ---- 
lat = c("40° 39.4711") #40°39.4711'N, 
long = c("151° 52.7249") # 151°52.7249'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 151.8787 40.65785
make360(-151.8787)
# 208.1213


## 9 july 2026 ---- COHORT 4 RELEASE LOCATION!!!
lat = c("39° 59.2032") #39°59.2032'N, 
long = c("149° 02.9923") # 149°02.9923'W
parzer::parse_lon_lat(lon = long, lat = lat)

# 149.0499 39.98672
make360(-149.0499)
# 210.9501




#### ---------
parzer::parse_lon_lat(lon = long, lat = lat)



string <- "34°41.2650'N 139°42.3146'E"
tt<-unlist(str_split(string, "\\ "))
str_split(tt, "\\°")[[1]] 
str_split(tt, "\\°")[[2]]

string %>%
  gsub("", "", .) %>%
  gsub("'", "", .) %>%
  gsub("°", " ", .) 

# total length of string
num.chars <- nchar(string)

# the indices where each substr will start
starts <- seq(1,num.chars, by=2)
starts <- c(1,3,11,15,18)
# chop it up
sapply(starts, function(ii) {
  substr(string, ii, ii+1)
})