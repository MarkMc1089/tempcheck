#' tile UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom countup countupOutput
mod_tile_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("tile"))
  )
}

#' tile Server Functions
#'
#' @noRd
#'
#' @importFrom TileMaker solo_box
mod_tile_server <- function(id, rating_key, r){
  moduleServer( id, function(input, output, session){
    weather_to_rating = list(
      sun = 1,
      sun_cloud = 2,
      cloud = 3,
      cloud_rain = 4,
      cloud_storm = 5
    )

    output$tile <- renderUI({
      count <- nrow(r$data %>% filter(.data$rating == weather_to_rating[rating_key]))
      solo_box(count, style = 'width:100%;')
    })

  })
}
