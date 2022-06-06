#' tile UI Function
#'
#' @description A {shiny} Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
mod_tile_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("tile"))
  )
}

#' tile Server Function
#'
#' @noRd
mod_tile_server <- function(r, id, rating_key){
  moduleServer(id, function(input, output, session){
    weather_to_rating = list(
      sun         = 1,
      sun_cloud   = 2,
      cloud       = 3,
      cloud_rain  = 4,
      cloud_storm = 5
    )

    weather_to_svg = list(
      sun = "day",
      sun_cloud = "cloudy-day-3",
      cloud = "cloudy",
      cloud_rain = "rainy-6",
      cloud_storm = "thunder"
    )

    output$tile <- renderUI({
      count <- nrow(r$filtered_data %>% filter(.data$rating == weather_to_rating[rating_key]))
      img_src <- glue("animated_svgs/{weather_to_svg[rating_key]}.svg")
      tile(count, img_src, "#0000ff")
      # solo_box(count, textModifier = "span", style = "width:100%; color: black; font-size: xxx-large; font-weight: bold")
    })

  })
}
