# manual subset and save ncdf.R


library(terra)

## SST ----------------------

sst_fname = 'coraltemp_v3.1_20250703'

# Load the NetCDF file
fpath <- glue("~/Downloads/{sst_fname}.nc")
r <- rast(fpath, lyrs = 1)  # First variable/layer only: analysed sst

# Check variable and coordinate structure
print(r)

# Subset to lon: -180 to -110 and lat: 20 to 50
r_subset <- crop(r, ext(-180, -109.95, 20, 50.05))

# Set CRS to WGS84 explicitly
crs(r_subset) <- "+proj=longlat +datum=WGS84 +no_defs"

# Set layer name (e.g., "sea.surface.temperature.1")
names(r_subset) <- "sea.surface.temperature.1"

# Save as NetCDF with desired variable name and structure
writeCDF(r_subset,
         filename = glue("~/Downloads/{sst_fname}_ENP_subset.nc"),
         varname = "CRW_SST",  # zvar
         # varunit = "degree_Celsius",  # optional
         overwrite = TRUE)



## SSTA ----------------------

ssta_fname = 'ct5km_ssta_v3.1_20250703'

# Load the NetCDF file
fpath <- glue("~/Downloads/{ssta_fname}.nc")
r <- rast(fpath, lyrs = 1)  # First variable/layer only: analysed sst

# Check variable and coordinate structure
print(r)

# Subset to lon: -180 to -110 and lat: 20 to 50
r_subset <- crop(r, ext(-180, -109.95, 20, 50.05))

# Set CRS to WGS84 explicitly
crs(r_subset) <- "+proj=longlat +datum=WGS84 +no_defs"

# # Set layer name (e.g., "sea.surface.temperature.1")
# names(r_subset) <- "sea.surface.temperature.1"

# Save as NetCDF with desired variable name and structure
writeCDF(r_subset,
         filename = glue("~/Downloads/{ssta_fname}_ENP_subset.nc"),
         varname = "CRW_SSTANOMALY",  # zvar
         # varunit = "degree_Celsius",  # optional
         overwrite = TRUE)


