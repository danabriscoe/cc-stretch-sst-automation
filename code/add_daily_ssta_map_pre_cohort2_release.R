# add daily ssta map.R

# 
# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools")
# 
# 
# # render plots function -----
# render_ncdfs = function(eov, 
#                         enddate, startdate, timestep,
#                         nc_path, bbox) {
#   rmarkdown::render(
#     here("code","01_get_ncdf.Rmd"),
#     # "code/01_get_ncdf.Rmd",
#     params = list(eov=eov, 
#                   enddate = enddate, startdate = startdate,
#                   nc_path = nc_path, bbox = bbox),
#     envir = parent.frame()
#   )
# }
# 
# 

## 1 Get new netcdfs ----

# # get ssta daily
# render_ncdfs(
#   eov = "ssta",
#   timestep = "daily",
#   enddate <- Sys.Date() - 2,
#   startdate <- Sys.Date() - 3,#"2023-07-10",  ## JUST PULL MOST RECENT 2 dailys for SSTA map (for now)
#   nc_path = "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/npac",
#   bbox <- dplyr::tibble(ymin=20, ymax=50,xmin=-180, xmax=-110)
# )


## -------------------------------------------------------------------------------------
### ADD SSTA plot
nc_path_ssta <- "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/npac"
ssta_varname <- "ssta_dhw_5km"

ncs_ssta <- list.files(nc_path_ssta, pattern = ssta_varname, full.names=T)

## only for unit testing ---
fdates_ssta <- ncs_ssta %>% 
  str_split(., "_") %>%
  purrr::map_chr(~ pluck(., 4)) %>%
  substr(., start=1, stop=10)

# params$startdate = fdates[1]
# params$startdate = fdates[length(fdates)]

## end only for unit testing ---
dates_ssta = fdates
enddate_idx = which(fdates == Sys.Date() - 2)


# ncIn_ssta <- sapply(1:length(dates_ssta), function(x) ncs_ssta[grepl(dates_ssta[x],ncs_ssta)])
ncIn_ssta <- sapply(enddate_idx, function(x) ncs_ssta[grepl(dates_ssta[x],ncs_ssta)]) # just get most recent date

# convert ncs to raster stack
ras_ssta <- raster::stack(ncIn_ssta)

ras_ssta <- setZ(ras_ssta, ncIn_ssta %>% 
              map_chr(~parseDT(., start=14, stop = 23, format="%Y-%m-%d")) %>%
              as.Date(), name = 'date') 

# name raster layers (select one)
names(ras_ssta) <- tools::file_path_sans_ext(basename((ncIn_ssta)))
names(ras_ssta) <- str_c('daily_ssta_', getZ(ras_ssta))


library(raster)
library(leaflet)
library(leaflet.extras2)
library(RColorBrewer)

# get most recent daily sst raster. subtract enddate by 1 since in NZ time
# enddate_ras = subset(ras, which(getZ(ras) == (params$enddate - 1)))
enddate_ras_ssta = subset(ras_ssta, which(getZ(ras_ssta) == (dates_ssta[enddate_idx])))
# pal_rev <- colorNumeric(c("#2c7bb6","#abd9e9","#ffffbf","#fdae61", "#d7191c"), values(enddate_ras), reverse = FALSE, na.color = "transparent")

smooth_rainbow <- khroma::colour("smooth rainbow")
limits <- c(5, 35)
cpal <- c(smooth_rainbow(length(seq(floor(limits[1]), ceiling(limits[2]), 1)), range = c(0, 0.9)))

# pal_rev <- colorNumeric(cpal[14:length(cpal)], values(enddate_ras), reverse = FALSE, na.color = "transparent")


limits_ssta <- c(-5.5,6)
cbar_int <- 0.5
cbar_title <- 'SSTA (°C)\n'

# cpal_ssta <- rev(c("#48090B", "#540b0e", rev(brewer.pal(9, "YlOrRd")),"white", brewer.pal(9, "Blues"), "#06224C", "#031126", "#020813"))
cpal_ssta <- rev(c("#48090B", rev(brewer.pal(9, "YlOrRd")),"white", brewer.pal(9, "Blues"), "#06224C"))

pal_rev_ssta <- colorNumeric(cpal_ssta[1:length(cpal_ssta)], values(enddate_ras_ssta), reverse = FALSE, na.color = "transparent")



#### ----{r plot-ssta-map}
# Plot leaflet with sst, but without deploy lons (n=4) and estimated shipping route
fig_top_ssta <- get_npac_map(xy, lon_type='360', add_deploy_lons=TRUE, cpal_ssta, col_borders=TRUE) %>% 
  # addPolylines(
  #   data = xy,
  #   lng = ~y, 
  #   lat = ~x,
  #   weight = 3,
  #   opacity = 3,
  #   color = 'azure4'
  # ) |>
  addScaleBar(position = "bottomleft", options = scaleBarOptions())

# Add SST daily raster to map
if(params$add_sst_map){
  map_ssta <- fig_top_ssta %>%
    addRasterImage(enddate_ras_ssta, colors = pal_rev_ssta, opacity = 0.8) %>%
    addLegend('topright',
              pal = pal_rev_ssta,
              values = values(enddate_ras_ssta),
              position = "topright",
              title = "SSTA (°C)",
              labFormat = labelFormat(transform = function(x) sort(x, decreasing = FALSE))) 
  # #Add the contour lines as lines on the map
  # map <- addCircleMarkers(map, data = df_18C, lng = ~lng360, lat = ~lat, 
  #                         label = "18 degrees C SST isotherm",
  #                         labelOptions = labelOptions(noHide = F, direction = "bottom",
  #                                                     style = list(
  #                                                       
  #                                                       "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
  #                                                       "font-size" = "12px",
  #                                                       "border-color" = "rgba(0,0,0,0.5)"
  #                                                     )),
  #                         group = ~group, color = "gray10", radius = 1.5) #%>%
  # 
  
  map_ssta <- map_ssta %>%
    addRectangles(
      lng1 = 225, lat1 = 25,
      lng2 = 243, lat2 = 35, stroke = TRUE, weight = 3,
      color = "white", label = "Thermal Corridor Area",
      labelOptions = labelOptions(noHide = F, direction = "bottom",
                                  style = list(
                                    
                                    "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                    "font-size" = "12px",
                                    "border-color" = "rgba(0,0,0,0.5)"
                                  )),
      fillColor = "transparent"
    )
  
} else {
  map_ssta <- fig_top_ssta
}

map_ssta_w_long_cohort1_markers <- 
map_ssta %>%
  # addPolylines(
  #   data = actual_ship,
  #   lng = ~lon, 
  #   lat = ~lat,
  #   weight = 3,
  #   opacity = 3,
  #   color = 'green'
  # ) |>
  # addCircleMarkers(lng = actual_ship$lon, lat = actual_ship$lat, color = 'green',radius = 3, weight=1.5, label=actual_ship_labels,
  #                  labelOptions = labelOptions(noHide = F, direction = "bottom",
  #                                               style = list(
# 
#                                                 "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
#                                                 "font-size" = "12px",
#                                                 "border-color" = "rgba(0,0,0,0.5)"
#                                               ))
#                  ) |>
addAwesomeMarkers(lng = actual_ship$lon[recent_loc], lat = actual_ship$lat[recent_loc], 
                  icon=ship_icon,
                  # label=actual_ship_labels[recent_loc],
                  label=release_loc_label[recent_loc],
                  labelOptions = labelOptions(noHide = F, direction = "bottom",
                                              style = list(
                                                
                                                "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                                "font-size" = "12px",
                                                "border-color" = "rgba(0,0,0,0.5)"
                                              ))
)
                  
#### ----