
#' Connect to anahita
#' @export
connect_anahita <- function(){
  dbConnect(
    drv = Postgres(),
    dbname = Sys.getenv('anahita_db_name'),
    host = Sys.getenv('anahita_db_uri') ,
    port = Sys.getenv('anahita_db_port'),
    user = Sys.getenv('aurora_user'),
    password = Sys.getenv('aurora_password')
  )

}

#' Connect to anahita
#' @export
connect_anahita_aur <- function(){
  dbConnect(
    drv = RPostgreSQL::PostgreSQL(),
    dbname = Sys.getenv('anahita_db_name'),
    host = Sys.getenv('anahita_db_uri') ,
    port = Sys.getenv('anahita_db_port'),
    user = Sys.getenv('aurora_user'),
    password = Sys.getenv('aurora_password')
  )

}


#' Connect to data warehouse
#' @export
connect_dw <- function(){
  dbConnect(
    drv = Postgres(),
    dbname = "dw",
    host = Sys.getenv('dw_uri'),
    port = Sys.getenv('dw_port'),
    user = Sys.getenv('dw_user'),
    password = Sys.getenv('dw_password'),
    sslmode = "require"
  )
}

#' Connect to aurora AWS db
#' @export
connect_aurora <- function() {
  dbConnect(
    drv = Postgres(),
    dbname = "anahita",
    host = Sys.getenv('anahita_db_uri') ,
    port = Sys.getenv('anahita_db_port'),
    user = Sys.getenv('aurora_user'),
    password = Sys.getenv('aurora_password') 
  )

}

#' disconnect
#' @param con connection to close 
#' @export
disconnect <- function(con){
  dbDisconnect(con)
}
