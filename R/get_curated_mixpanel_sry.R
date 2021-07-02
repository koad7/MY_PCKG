#' Enrich Mixpanel data with Stripe data and filter out only payeing members.
#' 
#' @description 
#' This function call on landing  Serendipity mixpanel filter it with paying members get from Stripe.
#' 
#' @param date date of the file of interest (the date is the file name) 
#' 
#' @examples 
#' \dontrun{
#' curated_mixpanel_sry(landing_mixpanel_sry)
#' }
#' 
#' Save 'mixpanel_data_dms' to 'curated_mixpanel_sry_bucket' in the Data Lake.
#' 
#' @export
get_curated_mixpanel_sry <- function(date) {
  cat("############# Load landing_mixpanel_sry from S3 #############\n")
  tryCatch(
        {
          landing_mixpanel_sry <- get_object_from_s3bucket('landing_mixpanel_sry',date)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
  
  cat("Connection to anahita\n")
  tryCatch(
        {
          con_an <- connect_anahita()
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
  
  cat("Retrieving Stripe data\n")
  tryCatch(
        {
          stripe <- stripe_customers(con_an)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
  
  cat("Do curration work\n")
  tryCatch(
        {
          mixpanel_data_dms <- landing_mixpanel_sry %>%
                filter(distinct_id %in% stripe$id) %>%
                select(dplyr::one_of(mixpanel_columns_dms)) %>%
                rename(
                  id = "distinct_id",
                  entity_name = "entityName",
                  entity_type = "entityType",
                  secondary_entity_type = "secondaryEntityType",
                  country_code = "mp_country_code",
                  entity_id = "entityId",
                  secondary_entity_id = "secondaryEntityId",
                  secondary_entity_name = "secondaryEntityName"
                )
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
  
    # TODO: Parquet transformation

    tryCatch(
          {
            s3save(mixpanel_data_dms, bucket =  paste0("s3://",Sys.getenv('curated_mixpanel_sry_bucket')), object = paste0("curated_mixpanel_sry",Sys.Date(),".json"))
          }, error = function(err.msg){
              write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
          }
      )
    cat("\n\n########### curated_mixpanel_sry procedure completed ###########\n")
    
  }

  