library(DBI)
library(RPostgreSQL)
library(gsubfn)

# constant for now, will be dynamically populated by user login details
# once web app functionality is implemented
user <- 'jbrown'

connect <- function() {
  drv <- dbDriver("PostgreSQL")
  dbConnect(drv,
            dbname = "edsa",
            user   = "llschlit")
}

getWaveform <- function(table, column) {
  con <- connect()
  query <- fn$identity("SELECT $column
                        FROM $table;
                       ")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result

}

