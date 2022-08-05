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
        content_box(
          "Ratings",
          fluidRow(
            style="text-align: -webkit-center;",
            col_1(),
            col_2(mod_tile_ui("count_sun")),
            col_2(mod_tile_ui("count_sun_cloud")),
            col_2(mod_tile_ui("count_cloud")),
            col_2(mod_tile_ui("count_cloud_rain")),
            col_2(mod_tile_ui("count_cloud_storm")),
            col_1()
          )
        ),
        br(),
        content_box(
          "Response Rates",
          mod_response_table_ui("response_rate"),
          br(),
          mod_response_rate_time_series_ui("rating_ts"),
        ),
        br(),
        content_box(
          "Trend",
          mod_rating_stacked_vertical_ui("rating_sv")
        ),
        br(),
        content_box(
          "Comments",
          mod_comment_table_ui("comments")
        )
      )
    ),
    br(), br(),
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
    # Seems to be a bug in {golem} - placing tags within a tags$head should place
    # them in the head tag. But it does not. Seems OK with nesting another tags$head!
    tags$head(
      tags$link(rel = "icon", href = "animated_svgs/day.svg", type = "image/svg+xml")
    ),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "NHSBSA Weekly Staff Survey"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
