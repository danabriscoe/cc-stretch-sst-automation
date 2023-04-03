# add_sst_clim.R

# load libraries
library(raster)
library(sf)
library(khroma)
library(plotly)


## Load SST brick ----
all_rasters <- readRDS(file = '~/github/cc-stretch-exploratory/data/interim/sst_NOAA_DHW_monthly_Lon0360_rasters_Jan1997_Dec2021.rds') 

dates = fdates    # grab only dates from daily rasters
# or get all between apr-jul
dates <- seq(ymd('2023-02-01'),ymd('2023-06-30'), by = '1 week')
mdates <- lubridate::month(dates) %>% unique() #%>% month.abb[.] #%>% enframe() %>% transmute("mon_abb" = value)


idx <- getZ(all_rasters) %>%
  lubridate::month(.) %>% as.tibble() %>%
  mutate(id = row_number()) %>%
  setNames(c('month', 'id')) %>%
  relocate(month, .after = id) %>%
  filter(month %in% mdates)


# ras_month <- subset(all_rasters, grep(mdates$mon_abb, names(all_rasters)))
ras_month = subset(all_rasters, idx$id)

xtract_df_long_monthly <- get_timeseries(rasIn = ras_month, pts2extract = xy, subset_dt = getZ(ras_month))

longterm_avgs <- xtract_df_long_monthly %>%
  group_by(ID, month) %>%
  summarise(longterm_avg = mean(value)) %>%
  mutate(month = as.numeric(month)) 
# mutate(date = str_c(year(fdates) %>% unique(), "-16-", month))  

longterm_df <- df %>%
  select(c("ID", "lon", "lat", "date")) %>%
  mutate(month = month(date),
         lonID = str_c(abs(lon), '°W')) %>%
  left_join(., longterm_avgs, by =c('ID', 'month')) %>%
  rename("value" = "longterm_avg") 

longterm_df_formatted <- longterm_df %>%
mutate(ID = str_c(abs(lon), '°W')) #%>%
  # mutate(across(ID, factor, levels=c(lonID)))

# lons <- abs(df$lon) %>% unique()
# lonID <- str_c(lons, '°W')

## rename df for clarity ----
longterm_sst_mday_df <- longterm_df_formatted
longterm_avgs_sst_mday <- longterm_avgs

## save as rds ----
# saveRDS(longterm_sst_mday_df, file='./data/longterm_sst_mday_df.rds')
saveRDS(longterm_avgs_sst_mday, file='./data/longterm_avgs_sst_mday.rds')


# ## plot
# p_longterm_sst_ts <-  p_sst_ts +
#   geom_line(data = longterm_df_formatted, aes(group = ID), linewidth = 1, alpha = 0.5) +
#   scale_colour_manual(values=cpal, name = "Longitude (°W)") +
#   labs(x="Date", y="Sea surface temperature (°C)") +
#   # theme(legend.direction="horizontal",legend.position="top", legend.box = "vertical")+
#   theme(legend.position = "none") +
#   facet_wrap(~ID, ncol=1)
