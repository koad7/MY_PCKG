#' Retrieve Mixpanel data from Serendipity Mixpanel API.
#' @description 
#' This function pull clean data from Serendipity Mixpanel API.
#' 
#' 
#' When no parameter is provided it retrieve the previous day data.
#' 
#' @param time_since starting time (default is yesterday)
#' @param time_to ending time (default is yesterday)
#' @param dev deployment status read from config (dev will not right into DBs)
#' @param key_sry mixpanel serendipidity API secret
#' @param key_tpk mixpanel toplink API secret
#' 
#' @examples 
#' \dontrun{
#' landing_mixpanel_sry()
#' }
#' 
#' Save 'mixpanel_data_clean_original' to 'landing_mixpanel_sry_bucket' in the Data Lake in parquet format.
#' 
#' @export
get_landing_mixpanel_sry <- function(
  time_since = Sys.Date() - 1, 
  time_to = Sys.Date() - 1,
  dev = Sys.getenv('deploy_status'),
  key_sry = Sys.getenv('mp_si'),
  key_tpk = Sys.getenv('mp_dm')) {

  cat("\n\n########### Save Serendipity Mixpanel data to S3 ###########\n")
  cat("---> Deployment status = ", dev, "\n\n")

  cat("1. Retrieving Mixpanel Serendipity Data\n")
  dir <- tempfile()
  tryCatch(
        {
          mixpanel_data <- mxp_fetch_data(time_since, time_to, key_sry, mixpanel_columns_sry, dir)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
  
  mxp_clean_dir(dir)

  # TODO: Parquet transformation
  tryCatch(
        {
            s3save(mixpanel_data, bucket = paste0("s3://" , Sys.getenv('landing_mixpanel_sry_bucket')) , object = paste0("landing_mixpanel_sry-",Sys.Date(),".json"))
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
  cat("\n\n########### landing_mixpanel_sry procedure completed ###########\n")
}