
init <- function(){
    cat('"""""""" Checking and installing dependencies """"""""\n\n' )
    list.of.packages <- c('aws.s3','yaml','utils', 'urltools', 'tidyr', 'tibble', 'stringr', 'readr', 'magrittr', 'dplyr', 'purrr','lubridate', 'jsonlite', 'cli','assertthat', 'RPostgres','DBI', 'crayon','dbplyr','arrow','devtools')
    new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
    if(length(new.packages)) {
        install.packages(new.packages)
    }
    lapply(list.of.packages, require, character.only = TRUE)
    
    install_github('koad7/mixpanel_r')
    
    
    cat('"""""""" Loading environment variables """"""""\n\n' )
    readRenviron('./.Renviron')
    cat('"""""""" Loading dependency libraries  """"""""\n\n' )
    source("libraries.R")
    cat('"""""""" Sourcing Anahita code  """"""""\n\n' )
    anahita_list <- list.files('./')
    # anahita_list <- paste("./", anahita_list, sep="")
    anahita_list=anahita_list[anahita_list != "main.R"]
    anahita_list=anahita_list[anahita_list != "mpdata"]
    sapply(anahita_list[anahita_list != "main.R"], source)
}
