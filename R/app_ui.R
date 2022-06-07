#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#'
#' @noRd
app_ui <- function(request) {
  fluidPage(
    style = "margin-left: 10px; margin-right: 10px;",
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    mod_fixed_header_ui("header_1"),
    br(),br(),
    tags$main(
      fluidPage(
        fluidRow(
          style="text-align: -webkit-center;",
          col_1(),
          col_2(mod_tile_ui("count_sun")),
          col_2(mod_tile_ui("count_sun_cloud")),
          col_2(mod_tile_ui("count_cloud")),
          col_2(mod_tile_ui("count_cloud_rain")),
          col_2(mod_tile_ui("count_cloud_storm")),
          col_1()
        ),
        br(),
        fluidRow(
          style="text-align: -webkit-center;",
          col_1(),
          col_2(mod_tile_ui("avg_mon")),
          col_2(mod_tile_ui("avg_tue")),
          col_2(mod_tile_ui("avg_wed")),
          col_2(mod_tile_ui("avg_thu")),
          col_2(mod_tile_ui("avg_fri")),
          col_1()
        ),
        br(),
        mod_table_ui("table_1")
      )
    ),
    br(),br(),
    mod_footer_ui("footer_1")
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @importFrom golem add_resource_path favicon bundle_resources
#'
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))
  add_resource_path("images", app_sys("app/www/images"))
  add_resource_path("animated_svgs", app_sys("app/www/images/weather_icons/animated"))

  tags$head(
    tags$html(lang = "en"),
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Tempcheck"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
