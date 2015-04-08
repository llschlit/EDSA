library(DBI)
library(RPostgreSQL)
library(gsubfn)

# constant for now, will be dynamically populated by user login details
# once web app functionality is implemented
user = 'jbrown'

connect <- function() {
  drv <- dbDriver("PostgreSQL")
  dbConnect(drv,
            dbname = "edsa",
            user   = "llschlit")
}

getTableList <- function() {
  con <- connect()
  result <- dbGetQuery(con, "SELECT table_name AS table
                             FROM   information_schema.tables 
                             WHERE  table_schema = 'public';")
  dbDisconnect(con)
  result

}

getUserProjects <- function() {
  con <- connect()
  query <- fn$identity("SELECT a.proj_title
                        FROM project AS a 
                        JOIN (SELECT * 
                              FROM permissions 
                              WHERE usf_uid = '$user' AND p_type >= 4) AS b 
                        ON a.proj_id = b.proj_id
                        ORDER BY a.proj_title;")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

getProjectInfo <- function(project) {
  con <- connect()
  query <- fn$identity("SELECT a.proj_id, a.proj_title, a.creator, a.created_at,
                        b.p_group AS role, b.name AS permissions, a.notes 
                  FROM project AS a 
                  JOIN (SELECT * 
                        FROM permissions AS z
                        JOIN permission_type AS y
                        ON z.p_type = y.code
                        WHERE usf_uid = '$user' AND 
                              p_type > 0) AS b  
                  ON a.proj_id = b.proj_id 
                  WHERE a.proj_title = '$project';"
            )
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

getExpInfo <- function(exp, proj) {
  con <-connect()
  query <- fn$identity("SELECT a.exp_id, a.proj_id, a.exp_title, 
                               b.dt_name AS data_type, a.storage_type, a.notes
                        FROM experiment AS a
                        JOIN data_type AS b
                        ON a.d_type = b.dt_id 
                        WHERE a.exp_title = '$exp' AND
                              proj_id = (SELECT proj_id
                                         FROM project
                                         WHERE proj_title = '$proj');")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

getProjExp <- function(project) {
  con <-connect()
  query <- fn$identity("SELECT exp_title  
                        FROM experiment
                        WHERE proj_id IN (SELECT proj_id 
                                          FROM project 
                                          WHERE proj_title = '$project');")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

