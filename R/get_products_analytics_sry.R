#' Advanced Analytics
#' 
#' @description 
#' Event view for advanced analytics related events only
#'
#' @param date date of the file of interest (the date is the file name) 
#'
#' @examples
#' \dontrun{
#' products_analytics_sry(curated_mixpanel_sry)
#' }
#' 
#' Save 'events_advanced_analytics' to 'products_analytics_sry_bucket' in the Data Lake in parquet format.
#' 
#' @export
get_products_analytics_sry <- function(date) {
    cat("1. Getting curated_mixpanel_sry\n")
    tryCatch(
        {
          curated_mixpanel_sry <- get_object_from_s3bucket('curated_mixpanel_sry',date)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("2. build_advanced_analytics_table \n")
    tryCatch(
        {
          events_advanced_analytics <- build_advanced_analytics_table(curated_mixpanel_sry)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    # TODO: Parquet transformation
    cat("3. Saving file to s3 bucket \n")
    tryCatch(
        {
          s3save(events_advanced_analytics, bucket = paste0("s3://", Sys.getenv('products_analytics_sry_bucket')) , object = paste0("products_analytics_sry",Sys.Date(),".json"))
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("\n\n########### products_analytics_sry procedure completed ###########\n")
}
