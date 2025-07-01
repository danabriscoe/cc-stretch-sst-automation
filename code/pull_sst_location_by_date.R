# script to manually pull daily sst (or ssta) at last year's release location, given a speficied date
#
# author: dbriscoe
# date: jun 2025
# ------------------------------------------------------------------------------

# Load required package
library(tidyverse)
library(terra)
library(glue)
library(here)

# Specify NetCDF file path
varname = 'sst'
# varname = 'ssta_dhw_5km'


if(varname == 'sst'){
nc_path = '/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/deploy_reports'
} else if (varname == 'ssta_dhw_5km'){
  nc_path = '/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/npac'
}

# varname = 'sst'
ncs <- list.files(nc_path, pattern = paste0(varname, collapse="|"), full.names=T, ignore.case = TRUE)

ncs <- ncs[order(basename(ncs))]
print(str_c('most recent ncdf - ', ncs[length(ncs)]))



nc_file <-ncs[length(ncs)]

# nc_file <- ncs[grepl('2024-06-11',ncs)]
nc_file <- ncs[grepl('2024-07-07',ncs)]

# Load NetCDF as a SpatRaster (specify variable if needed)
r <- rast(nc_file)  # Loads all layers/variables
# Optionally, select a specific variable/layer:
# r <- rast(nc_file, varname = "sst")

# Check names and metadata
print(names(r))
print(r)

## Define the target coordinates (longitude and latitude)
lon <- -148.5  # or 235.0 if in 0–360° format
lat <- 38.56

lon <- -147.2858
lat <- 39.49312


# Extract value at specified location
value <- terra::extract(r, cbind(lon, lat))

# Print extracted value
print(value)
