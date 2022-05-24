#' Retrieve data from MongoDB
#'
#' @description  Retrieve all data from a mongodb collection. Optionally,
#'   replace the collection data first.
#'
#' @param collection Name of the collection.
#' @param db Name of the database the collection is in.
#' @param connection_string Address of the mongodb server in mongo connection
#'   string [URI
#'   format](https://docs.mongodb.com/manual/reference/connection-string/).
#' @param replace_with Default is NULL. If passed, must be a dataframe, named
#'   list (for single record) or character vector with json strings (one string
#'   for each row).
#'
#' @return Returns all data in the given collection as a dataframe.
#' @export
#'
#' @importFrom mongolite mongo ssl_options
#'
#' @examples
#' \dontrun{
#' # Get the data in my_collection (in the my_db database)
#' get_mongo_collection(
#'   "my_collection", "my_db",
#'   connection_string = glue::glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   )
#' )
#'
#' # Replace the data in my_collection (in the my_db database) with the data in
#' # my dataframe, then get that data
#' get_mongo_collection(
#'   "my_collection", "my_db",
#'   connection_string = glue::glue(
#'     "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
#'     "/?tls=true&retryWrites=true&w=majority"
#'   ),
#'   replace_with = my_dataframe
#' )
#' }
get_mongo_collection <- function(collection, db,
                                 connection_string,
                                 replace_with = NULL) {
  conn <- mongo(
    collection = collection,
    db = db,
    url = connection_string,
    options = ssl_options(weak_cert_validation = TRUE)
  )
  on.exit(rm(conn) & gc())

  if (!is.null(replace_with)) {
    if (conn$count() > 0) conn$drop()
    conn$insert(replace_with)
  }

  conn$find()
}
