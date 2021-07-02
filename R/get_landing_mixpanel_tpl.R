#' Retrieve Mixpanel data from Toplink Mixpanel API.
#' 
#' @description 
#' This function pull clean data from Serendipity Mixpanel API.
#' 
#' 
#' @param time_since starting time (default is yesterday)
#' @param time_to ending time (default is yesterday)
#' @param dev deployment status read from config (dev will not right into DBs)
#' @param key_sry mixpanel serendipidity API secret
#' @param key_tpk mixpanel toplink API secret
#' 
#' @examples 
#' \dontrun{
#' landing_mixpanel_tpl()
#' }
#' 
#' When no parameter is provided it retrieve the previous day data.
#' 
#' Save 'mixpanel_data_toplink' to 'landing_mixpanel_tpl_bucket' in the Data Lake in parquet format.
#' 
#' @export
get_landing_mixpanel_tpl <- function(
  time_since = Sys.Date() - 1, 
  time_to = Sys.Date() - 1,
  dev = Sys.getenv('deploy_status'),
  key_sry = Sys.getenv('mp_si'),
  key_tpk = Sys.getenv('mp_dm')) {
    cat(". Pulling data from Mixpanel TopLink\n")
    tryCatch(
        {
          dir <- tempfile()
          mixpanel_data_toplink <- mxp_fetch_data(time_since, time_to, key_tpk, mixpanel_columns_tpk, dir)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    mxp_clean_dir(dir)
    # TODO: Parquet transformation
    cat("\n\n Save Toplink Mixpanel data to S3 n")
    tryCatch(
        {
          s3save(mixpanel_data_toplink , bucket = paste0("s3://", Sys.getenv('landing_mixpanel_tpl_bucket')) , object = paste0("landing_mixpanel_tpl-",Sys.Date(),".json"))
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("\n\n########### landing_mixpanel_tpl procedure completed ###########\n")
}