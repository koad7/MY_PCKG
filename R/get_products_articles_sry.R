#' Articles
#' 
#' @description 
#' Event view for article related events only
#'
#' @param date date of the file of interest (the date is the file name) 
#'
#' @examples
#' \dontrun{
#' products_articles_sry(curated_mixpanel_sry)
#' }
#' 
#' Save 'events_briefings' to 'products_articles_sry_bucket' in the Data Lake in parquet format.
#' 
#' @export
get_products_articles_sry <- function(date) {
    cat("1. Getting curated_mixpanel_sry\n")
    tryCatch(
        {
          curated_mixpanel_sry <- get_object_from_s3bucket('curated_mixpanel_sry',date)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("2. build_articles_table \n")
    tryCatch(
        {
          events_articles <- build_articles_table(curated_mixpanel_sry)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    # TODO: Parquet transformation
    cat("3. Saving file to s3 bucket \n")
    tryCatch(
        {
          s3save(events_articles, bucket = paste0("s3://", Sys.getenv('products_articles_sry_bucket')) , object = paste0("products_articles_sry-",Sys.Date(),".json"))
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("\n\n########### products_articles_sry procedure completed ###########\n")
}

