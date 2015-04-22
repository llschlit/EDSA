library(DBI)
library(RPostgreSQL)
library(gsubfn)

# constant for now, will be dynamically populated by user login details
# and user selected input from previous shiny app in work flow
# once web app functionality is implemented
user      <- 'jbrown'
projTitle <- 'electroporation_w_impedence'
projId    <- 100
expTitle  <- 'G3A1'
expId     <- 1000

connect <- function() {
  drv <- dbDriver("PostgreSQL")
  dbConnect(drv,
            dbname = "edsa",
            user   = "llschlit")
}

getXYDS <- function() {
  con <- connect()
  query <- fn$identity("SELECT ds_title 
                        FROM data_set AS a 
                        WHERE exp_id = $expId AND d_type = 1
                        ORDER BY substring(ds_title, '^[0-9]+')::int, substring(ds_title, '[0-9]*$');
                       ")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

loadXY <- function(dsTitle) {
  con <- connect()
  query <- fn$identity("SELECT  location
                        FROM    data_set AS a
                        JOIN    experiment AS b
                        ON      a.exp_id = b.exp_id
                        WHERE   ds_title = '$dsTitle'")
  result <- dbGetQuery(con, query)
  loc <- result$location
  query <- fn$identity("SELECT * FROM $loc;")
  xy <- dbGetQuery(con, query)
  dbDisconnect(con)
  xy
}


loadDSInfo <- function(dsTitle) {
  con <- connect()
  query <- fn$identity("SELECT y.* 
                        FROM (SELECT b.proj_id, a.* 
                              FROM data_set AS a 
                              JOIN experiment AS b 
                              ON a.exp_id = b.exp_id 
                              WHERE b.exp_title = '$expTitle'
                                    AND a.ds_title = '$dsTitle') AS y 
                        JOIN project AS z 
                        ON y.proj_id = z.proj_id
                        WHERE z.proj_title = '$projTitle';
                       ")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  dsData <- data.frame('proj_id' = as.numeric(result$proj_id), 
                       'exp_id' = as.numeric(result$exp_id),
                       'ds_id' = as.numeric(result$ds_id), 
                       'ds_title' = toString(result$ds_title),
                       'd_type' = as.numeric(result$d_type),
                       'storage_type' = toString(result$storage_type),
                       'location' = toString(result$location),
                       'xunit' = toString(result$xunit),
                       'yunit' = toString(result$yunit),
                       'dt' = as.numeric(result$dt),
                       'notes' = toString(result$notes))
}

parseUnits <- function(s) {
  tmp <- unlist(strsplit(s,','))
  nFields <- length(tmp)
  cols <- NULL
  dat <- NULL
  
  if(length(tmp) > 1) {
    for(i in 1:nFields) { 
      if ((i + 2) %% 2 != 0) {
        cols <- c(cols, tmp[i])
      } else {
        dat <- c(dat, tmp[i])
      }
    }
    
    units <- vector("list", length(cols))
    names(units) <- cols
    
    for(i in 1:length(cols)) { 
      units[i] <- toString(dat[i])
    }
    
    units
  }
  else {
    tmp
  }
}

