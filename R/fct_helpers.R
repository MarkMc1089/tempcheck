#' Retrieve data from a MongoDB collection
#'
#' @description  Retrieve all data from a MongoDB collection, as a dataframe.
#'
#' @param collection Name of the collection.
#' @param db Name of the database the collection is in.
#' @param connection_string Address of the MongoDB server in mongo connection
#'   string [URI
#'   format](https://docs.mongodb.com/manual/reference/connection-string/).
#'
#' @return Returns all data in the given collection as a dataframe.
#'
#' @examples
#' \dontrun{
#' # Get the data in my_collection (in the my_db database)
#' get_mongo_collection(
#'   connection_string = glue::glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   ),
#'   "my_db",
#'   "my_collection"
#' )
#' }
get_mongo_collection <- function(connection_string, db, collection) {
  conn <- mongo(
    url = connection_string,
    db = db,
    collection = collection,
    options = ssl_options(weak_cert_validation = TRUE)
  )
  on.exit(rm(conn) & gc())

  conn$find()
}


#' Append to or replace data in a MongoDB collection
#'
#' @description  Append data to a MongoDB collection, optionally overwriting it.
#'   If the collection and/or database do not exist, they will be created.
#'
#' @param connection_string Address of the MongoDB server in mongo connection
#'   string [URI
#'   format](https://docs.mongodb.com/manual/reference/connection-string/).
#' @param db Name of the database the collection is in.
#' @param collection Name of the collection.
#' @param replace Default is FALSE. When TRUE, all documents are dropped in the
#'   collection first, effectively overwriting it.
#'
#' @return Returns all data in the given collection (after update) as a dataframe.
#'
#' @examples
#' \dontrun{
#' # Append rows of my_df to my_collection (in the my_db database).
#' # Set `replace = FALSE` to instead overwrite it.
#' send_to_mongo(
#'   my_df,
#'   connection_string = glue::glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   ),
#'   "my_db",
#'   "my_collection",
#'   replace = FALSE
#' )
#' }
send_to_mongo <- function(data, connection_string, db, collection, replace = FALSE) {
  conn <- mongo(
    url = connection_string,
    db = db,
    collection = collection,
    options = ssl_options(weak_cert_validation = TRUE)
  )
  on.exit(rm(conn) & gc())

  if (replace && conn$count() > 0) conn$drop()

  conn$insert(data)

  conn$find()
}


#' Append to or replace data in a MongoDB collection
#'
#' @description  Append data to a MongoDB collection, optionally overwriting it.
#'   If the collection and/or database do not exist, they will be created.
#'
#' @param snap_url URL of SNAP server
#' @param headers A named character vector of header keys and values. This allows
#'   for the `X-USERNAME` and `X-API-KEY` headers to be set for SNAP  authentication.
#' @param query A named list of query params and values. This allows the
#'   `restrictedValues` param to be set.
#' @param connection_string Address of the MongoDB server in mongo connection
#'   string [URI
#'   format](https://docs.mongodb.com/manual/reference/connection-string/).
#' @param db Name of the database the collection is in.
#' @param collection Name of the collection.
#' @param replace Default is FALSE. When TRUE, all documents are dropped in the
#'   collection first, effectively overwriting it.
#'
#' @return Returns all data in the given collection (after update) as a dataframe.
#'
#' @examples
#' \dontrun{
#' # Append the data taken from SNAP survey with ID 123-456 to my_collection
#' # (in the my_db database). Set `replace = FALSE` to instead overwrite it.
#' send_to_mongo(
#'   glue(SNAP_URL, SURVEY_ID = "123-456"),
#'   c(
#'     'X-USERNAME' = SNAP_USER,
#'     'X-API-KEY'  = SNAP_API_KEY
#'   ),
#'   mongo_url = glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   ),
#'   "my_db",
#'   "my_collection",
#'   replace = FALSE
#' )
#' }
snap_to_mongo <- function(snap_url, headers = character(0), query = character(0),
                          mongo_url, db, collection, replace = TRUE) {
  res <- GET(snap_url, add_headers(.headers = headers), query = query)
  responses <- content(res, as="parsed")$responses

  variables <- lapply(responses, FUN = function(x) x$variables)

  # TODO: abstract this out so user can specify a mapping from SNAP names
  data <- lapply(variables, function(x){
    data.frame(
      date   = x[[1]]$value,
      team   = x[[2]]$value,
      rating = x[[3]]$value,
      reason = x[[4]]$value
    )
  })

  # TODO: abstract this out so user can specify mappings from SNAP values
  team_map <- list(
    "1" = "Digital",
    "2" = "Data & Insight"
  )

  bind_rows(data) %>%
    mutate(team = as.character(team_map[team])) %>%
    send_to_mongo(mongo_url, db, collection, replace)
}


#' Load data from MongoDB
#'
#' @description After triggering the update of the MongoDB collection, attempts
#' to read data from specified MongoDB collection. Once read, the raw data is
#' cleaned and prepared. If an error occurs in either of these 2 steps, data is
#' read from an .rda file in the data folder - this contains the last successfully
#' read data from MongoDB.
#'
#' @param r A reactiveValues object
#' @inheritParams snap_to_mongo
#'
#' @return Nothing - the data is stored in r$data.
#'
#' @examples
#' \dontrun{
#' r <- reactiveValues()
#'
#' load_data(r)
#' }
load_data <- function(r,
                      snap_url, headers, query,
                      mongo_url, db, collection, replace = TRUE) {
  snap_to_mongo(snap_url, headers, query, mongo_url, db, collection, replace)
  tryCatch(
    r$data <- data_prep(get_mongo_collection(mongo_url, db, collection)),
    error = function(e) {
      print(
        glue(
          "Error reading or preparing data from mongoDB: {e}\n",
          "Using last read data"
        )
      )
      r$data <- tempcheck::data
    }
  )
}


#' Group related content in dashboard
#'
#' @param title Title string
#' @param ... Content elements
#'
#' @return HTML defining the content
#'
#' @examples
#' \dontrun{
#' content_box(
#'   "I have content!",
#'   shiny::selectInput("input", "Choose", c("Option 1", "Option 2")),
#'   shiny::uiOutput("output")
#' )
#' }
content_box <- function(title, ...) {
  div(
    class = "ui card",
    style = "margin:auto; width:100%;",
    div(
      class = "extra content",
      style = "background-color: #E8EDEE;",
      div(
        class = "left aligned description",
        style = "font-size:16px; color: black;",
        HTML(glue("<b>{title}</b>"))
      )
    ),
    div(
      class = "content",
      div(
        ...
      )
    )
  )
}


#' Calculate whether NPS score has significantly changed between 2 samples.
#'
#' @description A margin of error is calculated for each sample, from the number of
#' promoters, neutrals (i.e. passives) and detractors. The standard error of
#' their difference is estimated using the Pythagorean formula, and the absolute
#' difference of the two samples is compared to this multiplied by the critical
#' value (aka z*-value).
#'
#' The return value is in (-1, 0, +1), according to whether a significant decrease
#' is found, no significant change, or a significant increase, respectively. If
#' the total for a sample is 0, then 0 is returned.
#'
#' Formula is based on the one found in this [blog post]
#' (https://www.genroe.com/blog/how-to-calculate-margin-of-error-and-other-stats-
#' for-nps/5994).
#'
#' @param p_0 Number of Promoters in latest sample
#' @param n_0 Number of Neutrals in latest sample
#' @param d_0 Number of Detractors in latest sample
#' @param p_1 Number of Promoters in oldest sample
#' @param n_1 Number of Neutrals in oldest sample
#' @param d_1 Number of Detractors in oldest sample
#' @param z_val Critical value multiplier; 1.96 by default for a 95% confidence
#' interval. See [this table]
#' (http://www.ltcconline.net/greenl/courses/201/estimation/smallConfLevelTable.htm)
#' for further values of z_val for common confidence intervals.
#'
#' @return A value in (-1, 0, +1); see notes above.
#'
#' @examples
#' # Test with a 99% confidence interval
#' \dontrun{
#' nps_moe_test(123, 456, 789, 321, 654, 987, z_val = 2.58)
#' }
nps_moe_test <- function(p_0, n_0, d_0,
                         p_1, n_1, d_1,
                         z_val = 1.96) {
  if (NA %in% c(p_0, n_0, d_0, p_1, n_1, d_1)) {
    return(0)
  }

  t_0 <- p_0 + n_0 + d_0
  if (t_0 == 0) {
    return(0)
  }
  nps_0 <- (p_0 - d_0) / t_0
  t_1 <- p_1 + n_1 + d_1
  if (t_1 == 0) {
    return(0)
  }
  nps_1 <- (p_1 - d_1) / t_1

  var_0 <- ((1 - nps_0)^2 * p_0 + nps_0^2 * n_0 + (-1 - nps_0)^2 * d_0) / t_0
  var_1 <- ((1 - nps_1)^2 * p_1 + nps_1^2 * n_1 + (-1 - nps_1)^2 * d_1) / t_1

  se_0 <- sqrt(var_0 / t_0)
  se_1 <- sqrt(var_1 / t_1)

  if (abs(nps_0 - nps_1) > z_val * sqrt(se_0^2 + se_1^2)) {
    if (nps_0 > nps_1) {
      return(1)
    }
    return(-1)
  }

  0
}

