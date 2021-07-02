#' Issues
#' 
#' @description 
#' Event view for issues related events only
#'
#' @param date date of the file of interest (the date is the file name) 
#'
#' @examples
#' \dontrun{
#' products_issues_sry(curated_mixpanel_sry)
#' }
#' 
#' Save 'events_issues' to 'products_issues_sry_bucket' in the Data Lake in parquet format.
#' 
#' @export
get_products_issues_sry <- function(date) {
    cat("1. Getting curated_mixpanel_sry\n")
    tryCatch(
        {
          curated_mixpanel_sry <- get_object_from_s3bucket('curated_mixpanel_sry',date)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("2. build_issues_table \n")
    tryCatch(
        {
          events_issues <- build_issues_table(curated_mixpanel_sry)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    # TODO: Parquet transformation
    cat("3. Saving file to s3 bucket \n")
    tryCatch(
        {
          s3save(events_issues, bucket = paste0("s3://", Sys.getenv('products_issues_sry_bucket')) , object = paste0("products_issues_sry-",Sys.Date(),".json"))
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    ) 
    cat("\n\n########### products_issues_sry procedure completed ###########\n")
}