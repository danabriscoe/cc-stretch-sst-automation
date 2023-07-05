# render SST report.R
# note: include ../ fpath when running script from command line

# render plots function -----
render_ncdfs = function(node, url, eov, varname,
                        dataset_ID, enddate, startdate, timestep,
                        nc_path, bbox) {
  rmarkdown::render(
    "../code/01_get_ncdf.Rmd",
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
    "../code/02_plot_SST_ts.Rmd",
    output_file = "../docs/index.html",
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
  enddate <- Sys.Date() - 1,
  startdate <- enddate - 15,
  timestep = "day",
  nc_path = "/Users/briscoedk/dbriscoe@stanford.edu - Google Drive/My Drive/ncdf/deploy_reports",
  bbox <- tibble(ymin=20, ymax=50,xmin=-180, xmax=-110)
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

