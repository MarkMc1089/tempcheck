#' table_from_mongo_example UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_table_from_mongo_ui <- function(id) {
  ns <- NS(id)
  tagList(
    DT::dataTableOutput(ns("table"))
  )
}

#' table_from_mongo_example Server Functions
#'
#' @noRd
#' @importFrom utils head
mod_table_from_mongo_server <- function(id, creds = NULL) {
  moduleServer(id, function(input, output, session) {
    # File .mongo-credentials.example should be edited and renamed according to
    # users own credentials
    if (not_null(creds)) eval_lines(creds)
    stopifnot(
      exists("MONGO_USER"),
      exists("MONGO_PASS"),
      exists("MONGO_HOST")
    )

    output$table <- DT::renderDataTable({
      get_mongo_collection(
        "rocks", "readr_samples",
        connection_string = glue::glue(
          "mongodb+srv://{MONGO_USER}:{MONGO_PASS}@{MONGO_HOST}",
          "/?tls=true&retryWrites=true&w=majority"
        )
      ) %>%
        utils::head()
    })
  })
}
