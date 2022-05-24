#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    mod_00_header_ui("00_header_1"),
    br(),
    fluidPage(
      mod_image_ui("image_1"),
      br(),
      mod_table_from_mongo_ui("table_example_1"),
      br(),
      mod_table_from_mongo_ui("table_example_2")
    ),
    br(),
    mod_99_footer_ui("99_footer_1")
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "tempcheck"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
