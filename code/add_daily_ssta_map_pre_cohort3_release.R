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

## TEMP SOLUTION FOR SSTA 
cpy_temp = "ssta_cpy_5km"
pattern1 = c('ssta_dhw_5km','ssta_cpy_5km')
ncs_ssta <- list.files(nc_path_ssta, pattern=paste0(pattern1, collapse="|"), full.names=T)


## only for unit testing ---
fdates_ssta <- ncs_ssta %>% 
  str_split(., "_") %>%
  purrr::map_chr(~ pluck(., 4)) %>%
  substr(., start=1, stop=10)

# params$startdate = fdates[1]
# params$startdate = fdates[length(fdates)]

## end only for unit testing ---
dates_ssta = fdates_ssta
enddate_idx = which(fdates_ssta == Sys.Date() - 2)
# previous_dt_idx = which(fdates_ssta == Sys.Date() - (366+2))
previous_dt_idx = which(fdates_ssta == Sys.Date() - (366+1)) # this should now match exacty one year prev to the day.


# ncIn_ssta <- sapply(1:length(dates_ssta), function(x) ncs_ssta[grepl(dates_ssta[x],ncs_ssta)])
ncIn_ssta <- sapply(c(previous_dt_idx, enddate_idx), function(x) ncs_ssta[grepl(dates_ssta[x],ncs_ssta)]) # just get most recent date

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
previous_dt_ras_ssta = subset(ras_ssta, which(getZ(ras_ssta) == (dates_ssta[previous_dt_idx])))


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



###--------------
library(RColorBrewer)

# Customize number of shades (e.g., 10 on each side)
# n_side <- 10
# # Manually interpolate colors to get symmetry
# reds_ext <- colorRampPalette(c("#48090B", rev(brewer.pal(9, "YlOrRd"))))(n_side)
# blues_ext <- colorRampPalette(c("#06224C", brewer.pal(9, "Blues")))(n_side)
# 
# # Combine cool → white → warm
# cpal_ssta_sym <- c(blues_ext, "white", reds_ext)

n_side <- 10

# Select lighter subset of each palette
# reds_soft <- brewer.pal(9, "YlOrRd")[4:9]  # skip the darkest reds
reds_soft <- brewer.pal(9, "YlOrRd")[1:9]  # skip the darkest reds
blues_soft <- brewer.pal(9, "Blues")[5:9]  # skip the darkest blues

# Interpolate smoother gradients from light shades
reds_ext <- colorRampPalette(reds_soft)(n_side)
blues_ext <- #colorRampPalette(blues_soft)(n_side)
  # colorRampPalette(c("#d4f1f9", "#90d2ec", "#0077B6"))(n_side)
  # colorRampPalette(c("#e0f7fa", "#a5ddf5", "#009FF5"))(n_side)
  # colorRampPalette(c("#e5f7ff", "#b3e5fc", "#4fc3f7", "#29b6f6", "#0AA9FF", "#0085CC"))(n_side)
  colorRampPalette(c("#e5f7ff", "#4fc3f7", "#06224C"))(n_side)


# Combine: blue → gray90 → red
# cpal_ssta_sym <- c(blues_ext, "white", reds_ext)
cpal_ssta_sym <- c("#022C64",rev(blues_ext), "white", reds_ext, "#48090B")


# pal_ssta_centered <- colorNumeric(
#   palette = cpal_ssta_sym,
#   domain = c(-6, 6),  # expanded limits
#   na.color = "transparent"
# )

pal_ssta_centered <- colorNumeric(
  palette = cpal_ssta_sym,  # your diverging palette
  domain = c(-6, 6),         # clamp domain
  na.color = "transparent"
)


###--------------


pal_rev_ssta <- colorNumeric(cpal_ssta[1:length(cpal_ssta)], values(enddate_ras_ssta), reverse = FALSE, na.color = "transparent")
pal_no_rev_ssta <- colorNumeric(cpal_ssta[1:length(cpal_ssta)], values(enddate_ras_ssta), reverse = TRUE, na.color = "transparent")




#### ----{r plot-ssta-map}
# Plot leaflet with sst, but without deploy lons (n=4) and estimated shipping route
fig_top_ssta <- get_npac_map(xy, lon_type='360', add_deploy_lons=TRUE, cpal_ssta, col_borders=TRUE) %>% 
  addProviderTiles("Esri.WorldImagery", group = "ESRI World Imagery") |>
  # addPolylines(
  #   data = xy,
  #   lng = ~y, 
  #   lat = ~x,
  #   weight = 3,
  #   opacity = 3,
  #   color = 'azure4'
  # ) |>
  addScaleBar(position = "bottomleft", options = scaleBarOptions()) |>
  addMapInset()

# Add SST daily raster to map
if(params$add_sst_map){
  map_ssta_enddate <- 
    # fig_top_ssta %>%
    # addRasterImage(enddate_ras_ssta, colors = pal_rev_ssta, opacity = 0.8) %>%
    # addLegend('topright',
    #           pal = pal_rev_ssta,
    #           # pal = pal_no_rev_ssta,
    #           values = seq(-5,5,1),
    #           position = "topright",
    #           title = "SSTA (°C)",
    #           labFormat = labelFormat(transform = function(x) sort(x, decreasing = FALSE)))
    #           # labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))) 
    fig_top_ssta %>%
    addRasterImage(enddate_ras_ssta, colors = pal_ssta_centered, opacity = 0.8) %>%
    addLegend(
      position = "topright",
      pal = pal_ssta_centered,
      # values = seq(-6, 6, 1),
      values = seq(-5.5, 5.5, 1),
      title = "SSTA (°C)",
      # labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = FALSE))
    )
    
  map_ssta_enddate <- map_ssta_enddate %>%
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
  
  ## 2023
  map_ssta_previous_dt<- 
    # fig_top_ssta %>%
    # addRasterImage(previous_dt_ras_ssta, colors = pal_rev_ssta, opacity = 0.8) %>%
    # addLegend('topright',
    #           pal = pal_rev_ssta,
    #           # values = values(previous_dt_ras_ssta),
    #           values = seq(-4,8,2),
    #           position = "topright",
    #           title = "SSTA (°C)",
    #           labFormat = labelFormat(transform = function(x) sort(x, decreasing = FALSE))) 
  fig_top_ssta %>%
  addRasterImage(previous_dt_ras_ssta, colors = pal_ssta_centered, opacity = 0.8) %>%
    addLegend(
      position = "topright",
      pal = pal_ssta_centered,
      # values = seq(-6, 6, 1),  # use full range for consistency
      values = seq(-5.5, 5.5, 1),
      title = "SSTA (°C)",
      # labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
      labFormat = labelFormat(transform = function(x) sort(x, decreasing = FALSE))
    )
  
  map_ssta_previous_dt <- map_ssta_previous_dt %>%
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
  map_ssta_enddate <- fig_top_ssta
  map_ssta_previous_dt <- fig_top_ssta
}

# 2024 SSTA
map_ssta_w_long_cohort1_markers_enddate <- 
  map_ssta_enddate %>%
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
       
# 2023 SSTA
map_ssta_w_long_cohort1_markers_previous_dt <- 
  map_ssta_previous_dt %>%
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


# # pull most recent location (last row)
# recent_loc <- nrow(actual_ship)
# 
# 
# # pull latest SSTA at ship route loc
# xtract_ssta_recent_loc_enddate <- get_timeseries(rasIn = enddate_ras_ssta, 
#                                                      pts2extract = tibble(x=actual_ship$lon[recent_loc],y=actual_ship$lat[recent_loc]), subset_dt = getZ(enddate_ras)) %>%
#   mutate(lon = ceiling(lon))
# 
# 
# xtract_ssta_recent_loc_previous_dt <- get_timeseries(rasIn = previous_dt_ras_ssta, 
#                                         pts2extract = tibble(x=actual_ship$lon[recent_loc],y=actual_ship$lat[recent_loc]), subset_dt = getZ(enddate_ras)) %>%
#   mutate(lon = ceiling(lon))

           
##
## ----