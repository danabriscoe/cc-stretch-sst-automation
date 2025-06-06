# add_sst_clim.R

# load libraries
library(raster)
library(sf)
library(khroma)
library(plotly)
library(lubridate)
library(tidyverse)

## Source helper functions
source('code/00_automate_SST_helper_functions.R')

# ## Load SST brick ----
# all_rasters <- readRDS(file = '~/github/cc-stretch-exploratory/data/interim/sst_NOAA_DHW_monthly_Lon0360_rasters_Jan1997_Dec2021.rds') 

# get ncdf list
list.ncs <- list.files('/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/npac', pattern =  'sst_', full.names=T)

filenames<-grep("monthly_",list.ncs)       
ncs <- list.ncs[filenames]
print(ncs[1])
print(max(ncs))

# later - set lines to trim to date range, if needed
# sapply(1:length(dates), function(x) ncs[grepl(dates[x],ncs)])

all_rasters <- raster::stack(ncs)

fdates <- ncs %>% 
  stringr::str_split(., "_") %>%
  purrr::map_chr(~ purrr::pluck(., 6)) %>%
  substr(., start=1, stop=10)
# ----------

# fdates <- getZ(all_rasters)
all_rasters <- setZ(all_rasters, fdates)
getZ(all_rasters)

# dates = fdates    # grab only dates from daily rasters
# or get all between apr-jul
dates <- seq(ymd('2023-01-01'),ymd('2023-12-31'), by = '1 month')

# mdates <- lubridate::month(dates) %>% unique() #%>% month.abb[.] #%>% enframe() %>% transmute("mon_abb" = value)
mdates <- lubridate::month(fdates) %>% unique() #%>% month.abb[.] #%>% enframe() %>% transmute("mon_abb" = value)

# # subset to dates between Jan 1997 and Dec 2022 (keep 2023 out of it for now)
# all_rasters_subset <- subset(all_rasters, which(getZ(all_rasters) >= '1997-01-01' & (getZ(all_rasters) <= '2022-12-31')))

end_clim_year <- year(Sys.Date()) - 1
start_clim_year <- '1985-01-01'

# subset to dates between Jan 1997 and Dec 2022 (keep 2023 out of it for now)
all_rasters_subset <- subset(all_rasters, which(getZ(all_rasters) >= start_clim_year & (getZ(all_rasters) <= end_clim_year)))

## used to subset by specific months. now doing all months (1-12), so this isn't really relevant. clean up later... ----
# idx <- getZ(all_rasters) %>%
  # fdates %>%
idx <- getZ(all_rasters_subset) %>%
  lubridate::month(.) %>% as_tibble() %>%
  mutate(id = row_number()) %>%
  setNames(c('month', 'id')) %>%
  dplyr::relocate(month, .after = id) %>%
  filter(month %in% mdates)

# ras_month = subset(all_rasters, idx$id)
ras_month = subset(all_rasters_subset, idx$id)
## --------------

# fyi, need to set 'xy' -- got this temporarily from 02_plot SST ts with isotherm...
# xy <- data.frame(x = unique(xtract_df_long$lon),  # -160 -150 -145 -140
#         y = unique(xtract_df_long$lat))           # 43.02 41.03 39.84 38.13

xy <- data.frame(x = c(160, -150, -145, -140),
                 y = c(43.02, 41.03, 39.84, 38.13))
# unique(xtract_df_long$lon)
# unique(xtract_df_long$lat)

xtract_df_long_monthly <- get_timeseries(rasIn = ras_month, pts2extract = xy, subset_dt = getZ(ras_month))

longterm_avgs <- xtract_df_long_monthly %>%
  group_by(ID, month) %>%
  summarise(longterm_avg = mean(value)) %>%
  mutate(month = as.numeric(month)) 
# mutate(date = str_c(year(fdates) %>% unique(), "-16-", month))  

longterm_df <- xtract_df_long_monthly %>%
  # df %>%
  dplyr::select(c("ID", "lon", "lat", "date")) %>%
  mutate(month = month(date),
         lonID = str_c(abs(lon), '°W')) %>%
  left_join(., longterm_avgs, by =c('ID', 'month')) %>%
  rename("value" = "longterm_avg") 

longterm_df_formatted <- longterm_df %>%
mutate(ID = str_c(abs(lon), '°W')) #%>%
  # mutate(across(ID, factor, levels=c(lonID)))

# lons <- abs(df$lon) %>% unique()
# lonID <- str_c(lons, '°W')

## Rename df for clarity ----
longterm_sst_mday_df <- longterm_df_formatted
longterm_avgs_sst_mday <- longterm_avgs

## Save as rds ----
### save clims rds ----
saveRDS(longterm_avgs_sst_mday, file='./data/longterm_avgs_sst_mday.rds')

### save monthly values (before averaging) rds ----
#### used for boxplot
# saveRDS(xtract_df_long_monthly, file='./data/longterm_avgs_sst_mday.rds')

 
saveRDS(longterm_sst_mday_df, file='./data/longterm_sst_mday_df.rds')
# ## plot
# p_longterm_sst_ts <-  p_sst_ts +
#   geom_line(data = longterm_df_formatted, aes(group = ID), linewidth = 1, alpha = 0.5) +
#   scale_colour_manual(values=cpal, name = "Longitude (°W)") +
#   labs(x="Date", y="Sea surface temperature (°C)") +
#   # theme(legend.direction="horizontal",legend.position="top", legend.box = "vertical")+
#   theme(legend.position = "none") +
#   facet_wrap(~ID, ncol=1)


## Plot annual clims ----
p_monthly_clims <- 
  df %>%
  select(c("ID", "lon", "lat", "date")) %>%
  mutate(month = month(date)) %>%
         # lon = case_when(
         #   ID == 1  ~ 160,
         #   ID == 2  ~ 150,
         #   ID == 3  ~ 145,
         #   ID == 4  ~ 140,
         #   TRUE ~ ID)) %>%
  full_join(., longterm_avgs, by =c('ID', 'month')) %>%
  mutate(lon = case_when(
    ID == 1  ~ 160,
    ID == 2  ~ 150,
    ID == 3  ~ 145,
    ID == 4  ~ 140,
    TRUE ~ lon)) %>%
  mutate(lonID = str_c(abs(lon), '°W')) %>%
  rename("value" = "longterm_avg") %>%

ggplot(data = ., aes(month, value, group = ID)) +
    geom_line(aes(group = ID, color = factor(lon)), linewidth = 1, alpha = 0.5) + 
    scale_colour_manual(values=rev(cpal), name = "Longitude (°W)") +
  scale_x_continuous(limits=c(1,12), breaks=seq(1,12,1)) +
  scale_y_continuous(limits=c(8,22), breaks=seq(8,22,2)) +
  theme_minimal() +
  theme(plot.caption = element_text(hjust=0)) +
    labs(title = 'Monthly SST Climatologies Along Shipping Route', x="Month", y="Sea surface temperature (°C)",
         caption = "Source:\nNOAA Coral Reef Watch, 5-km Monthly SST (1997-2022)") 
  

## Boxplot temps at locations for July ----

july_df <- xtract_df_long_monthly %>% filter(month == '07')

x = july_df %>%
  # select(c("ID", "lon", "lat", "date")) %>%
  mutate(month = month(date),
         year = year(date),
         lon = ceiling(lon),
         lonID = str_c(abs(lon), '°W'))

july_df_formatted <- x %>%
  mutate(ID = str_c(abs(lon), ' W')) %>%
  mutate(ID = as.factor(ID))

july_df_formatted %>% 
  filter(lon > -160 & lon < -140) %>%
  ggplot(data=., aes(x=year, y=value)) + geom_line(aes(group = ID, color = factor(lon)), linewidth = 1, alpha = 0.5) + 
  
  geom_hline(yintercept=17, linetype="dashed", color = "gray10") +
  
  scale_y_continuous(limits=c(12,22), breaks=seq(12,22, 1)) +
  scale_x_continuous(limits=c(1997,2021), breaks=seq(1997,2021, 1)) +
  
  theme_minimal() +
  scale_colour_manual(values=cpal[2:3], name = "Longitude (°W)") +
  
  
  labs(x="Date", y="Sea surface temperature (°C)") 


p<-july_df_formatted %>% 
  filter(lon > -160 & lon < -140) %>%
  ggplot(., aes(x=lonID, y=value, color=lonID)) +
  geom_boxplot() +
  scale_colour_manual(values=c(cpal[3], cpal[2]), name = "Longitude (°W)")  + 
  scale_y_continuous(limits=c(14,20), breaks=seq(14,20, 1)) +
  labs(x='Longitude', y = "Average July SST", title="Boxplot of Average July SSTs (1997 - 2021) by Longitude") 
p