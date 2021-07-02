#' User ids and email list
#' 
#' @description 
#' Sometimes, mixpanel stores emails instead of SF ids. We need
#' to replace emails by ids using a reference list of email to id
#' mappings. We need to note more than 1 email can be associated to
#' an single id since we have the person emnail and the toplink email.
#' In principle, the toplink email is the right one but we never now.
#'
#' Connection to the anahita DB
#'
#' @examples
#' \dontrun{
#' conn1 <- connect_anahita()
#' df <- mxp_build_user_ids_emails(conn1)
#' }
#' 
#' Save 'users' to 'landing_sf_email_to_id_bucket' in the Data Lake in parquet format.
#' 
#' @export
get_landing_sf_email_to_id <- function(){
    cat('Connection to anahitaDB \n')
    tryCatch(
        {
            con_an <- connect_anahita()
            
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat('Download of users file \n')
    tryCatch(
        {
            users <- sf_build_user_emails_to_id(con_an)
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat('########## Write Stripe users file to Parquet format on disk ##########\n')
    # TODO: Parquet transformation
    tryCatch(
        {
            s3save(users, bucket = paste0("s3://", Sys.getenv('landing_sf_email_to_id_bucket')) , object = paste0("landing_sf_email_to_id-",Sys.Date(),".json"))
        }, error = function(err.msg){
             write(toString(err.msg), Sys.getenv('logfile'), append=TRUE)
        }
    )
    cat("\n\n########### landing_sf_email_to_id procedure completed ###########\n")
}