# render SST report.R
# note: include ../ fpath when running script from command line

# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools")
Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64") # fyi, new posit rstudio release 12-2024
## used the following command to locate the newer pandoc version (source: )
# rmarkdown::find_pandoc()


# render plots function -----
render_ncdfs = function(node, url, eov, varname,
                        dataset_ID, enddate, startdate, timestep,
                        nc_path, bbox) {
  rmarkdown::render(
    here::here("code","01_get_ncdf.Rmd"),
    # "code/01_get_ncdf.Rmd",
    params = list(node = node, url = url, eov=eov, varname=varname,
                  dataset_ID = dataset_ID, enddate = enddate, startdate = startdate,
                  nc_path = nc_path),
    # output_file = str_c('STRETCH_SST_report_DBriscoe_', (lubridate::today()-1), '.html'),
    envir = parent.frame()
  )
}


# render SST timeseries function -----
render_SST_timeseries = function(eov, eov_unit,
                                 deploy_lons, interval, sst_thresh,
                                 # enddate, startdate,
                                 nc_path) {
  rmarkdown::render(
    ## "../code/02_plot_SST_ts.Rmd",
    # "../code/02_plot_SST_ts_with_18C_isotherm_post_release.Rmd",
    # here::here("code","02_plot_SST_ts_with_18C_isotherm_pre_cohort2_release.Rmd"),
    # here::here("code","02_plot_SST_ts_with_18C_isotherm_cohort2_actual_route.Rmd"),
    here::here("code","02_plot_SST_ts_with_18C_isotherm_cohort2_actual_route_w_ssta.Rmd"),
    # here::here("code","03_plot_SST_ts_with_18C_isotherm_pre_cohort3_release_w_ssta.Rmd"),
    # here::here("code","03_plot_SST_ts_with_18C_isotherm_post_cohort3_release_w_ssta.Rmd"),
    
    # "code/02_plot_SST_ts.Rmd",
    output_file = here::here("docs","index.html"),
    params = list(eov=eov, eov_unit=eov_unit,
                  deploy_lons = deploy_lons, interval = interval, sst_thresh = sst_thresh,
                  # enddate = enddate, startdate = startdate,
                  nc_path = nc_path),
    envir = parent.frame()
  )
}



## 1 Get new netcdfs ----
render_ncdfs(
  node = "pacioos",
  url = "https://pae-paha.pacioos.hawaii.edu/erddap/griddap/",
  eov = "sst",
  varname = "CRW_SST",
  dataset_ID = "dhw_5km",
  enddate <- Sys.Date() - 2,
  startdate <- enddate - 60,  #15, #dkb note (17 Sept 2024): canvas a larger period to re-download any bad files (< 6.8 mb)
  timestep = "day",
  nc_path = "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/deploy_reports",
  bbox <- tibble(ymin=20, ymax=60,xmin=-180, xmax=-110)
)

# get ssta daily
render_ncdfs(
  node = "pacioos",
  url = "https://pae-paha.pacioos.hawaii.edu/erddap/griddap/",
  eov = "ssta",
  varname = "CRW_SSTANOMALY",
  dataset_ID = "dhw_5km",
  enddate <- Sys.Date() - 2,
  # startdate <- Sys.Date() - (3+14),#"2023-07-10",  ## JUST PULL MOST RECENT 2 dailys for SSTA map (for now) + covering last 2 weeks, just in case automator didn't run 
  startdate <- Sys.Date() - (3+60),#"2023-07-10",  ## JUST PULL MOST RECENT 2 dailys for SSTA map (for now) + covering last 2 weeks, just in case automator didn't run 
  timestep = "day",
  nc_path = "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/npac",
  bbox <- dplyr::tibble(ymin=20, ymax=50,xmin=-180, xmax=-110)
)

# ssta - 1 year
render_ncdfs(
  node = "pacioos",
  url = "https://pae-paha.pacioos.hawaii.edu/erddap/griddap/",
  eov = "ssta",
  varname = "CRW_SSTANOMALY",
  dataset_ID = "dhw_5km",
  enddate <- Sys.Date() - (366+2), # account for leap year...
  startdate <- Sys.Date() - (366+2),#"2023-07-10",  ## JUST PULL MOST RECENT 2 dailys for SSTA map (for now)
  timestep = "day",
  nc_path = "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/npac",
  bbox <- dplyr::tibble(ymin=20, ymax=50,xmin=-180, xmax=-110)
)


render_SST_timeseries(
  eov = "sst",
  eov_unit = "°C",
  deploy_lons <- c(-160, -150, -145, -140),
  interval = "weekly",
  sst_thresh <- c(17),
  # enddate <- Sys.Date() - 1,
  # startdate <- enddate - 15,
  nc_path = "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/deploy_reports"
)

# 
# library(git2r)
# library(tidyverse)
# repo <- repository()
# 
# commit_dt <- gsub("-", " ", Sys.time()) %>% gsub(":", " ", .)
# # git2r::add(repo, "docs/index.html")
# git2r::add(repo, here::here("docs/index.html"))
# git2r::commit(repo, str_c("test commit ", commit_dt))
# ## Push commits from repository to bare repository
# push(repo, "origin", "refs/heads/main")


library(gert)
library(tidyverse)

# Stage the rendered file
# git_add(here::here("docs/index.html"))
git_add(here::here("docs/index.html"))

# status <- gert::git_status()
# to_stage <- status$file[status$status == "modified" & status$staged == FALSE]
# if (length(to_stage)) gert::git_add(to_stage)


# # Check which files are staged
# staged <- git_status(staged = TRUE)
# print(staged)
# 
# # # Only commit if something is staged
# # if (nrow(staged) > 0) {
#   commit_dt <- gsub("-", " ", Sys.time()) %>% gsub(":", " ", .)
#   git_commit(message = str_c("test commit ", commit_dt))
#   git_push(remote = "origin", refspec = "refs/heads/main")
# # } else {
# #   message("⚠️ No staged changes to commit.")
# # }


# Create a commit with current date/time
commit_dt <- gsub("-", " ", Sys.time()) %>% gsub(":", " ", .)
git_commit(message = str_c("test commit ", commit_dt))

# Push to origin/main
git_push(remote = "origin", refspec = "refs/heads/main")


## added this now works ---
# Check what's currently staged
status <- git_status()
staged_files <- status[status$staged == TRUE, ]
print("Currently staged files:")
print(staged_files)

if (nrow(staged_files) > 0) {
  commit_dt <- format(Sys.time(), "%Y%m%d_%H%M%S")
  git_commit(message = paste("Update SST report", commit_dt))
  git_push(remote = "origin", refspec = "refs/heads/main")
  cat("Successfully committed and pushed\n")
} else {
  cat("No staged files found\n")
}



# fin --

