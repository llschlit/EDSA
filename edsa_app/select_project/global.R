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
  query <- fn$identity("SELECT exp_id, proj_id, exp_title, notes
                        FROM experiment
                        WHERE exp_title = '$exp' AND
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

getExpDS <- function(exp, proj) {
  con <- connect()
  query <- fn$identity("SELECT y.ds_title
                        FROM (SELECT * 
                              FROM data_set AS a 
                              JOIN experiment AS b 
                              ON a.exp_id = b.exp_id
                              WHERE b.exp_title = '$exp') AS y 
                        JOIN project AS z 
                        ON y.proj_id = z.proj_id
                        WHERE z.proj_title = '$proj'
                        ORDER BY substring(y.ds_title, '^[0-9]+')::int, substring(y.ds_title, '[0-9]*$');
                       ")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

getDSInfo <- function(ds, exp, proj) {
  con <- connect()
  query <- fn$identity("SELECT foo.*
                        FROM (SELECT  z.proj_id, y.exp_id, z.exp_title, 
                                      y.ds_id, y.ds_title, y.dt_name, 
                                      y.storage_type, y.location, y.xunit, 
                                      y.yunit, y.dt, y.notes 
                              FROM   (SELECT  a.exp_id, a.ds_id, a.ds_title, 
                                              b.dt_name, a.storage_type, 
                                              a.location, 
                                              a.xunit, 
                                              a.yunit, 
                                              a.dt, a.notes
                                      FROM data_set AS a 
                                      JOIN data_type AS b
                                      ON a.d_type = b.dt_id
                                      WHERE ds_title = '$ds') AS y 
                            JOIN experiment AS z 
                            ON y.exp_id = z.exp_id
                            WHERE exp_title = '$exp') AS foo
                         JOIN project AS bar
                         ON foo.proj_id = bar.proj_id 
                         WHERE bar.proj_title = '$proj'
                       ;")
  result <- dbGetQuery(con, query)
  dbDisconnect(con)
  result
}

