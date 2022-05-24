#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_00_header_server("00_header_1")
  mod_image_server("image_1", image_name = "sunny")
  mod_table_from_mongo_server("table_example_1", creds = ".mongo-credentials")
  mod_table_from_mongo_server("table_example_2")
  mod_99_footer_server("99_footer_1")
}
