#' countup UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom countup countupOutput
mod_countup_ui <- function(id){
  ns <- NS(id)
  tagList(
    countup::countupOutput(ns("counter"))
  )
}

#' countup Server Functions
#'
#' @noRd
#'
#' @importFrom countup renderCountup countup
mod_countup_server <- function(id, rating, r){
  moduleServer( id, function(input, output, session){
    weather_to_rating = list(
      sun = 1,
      sun_cloud = 2,
      cloud = 3,
      cloud_rain = 4,
      cloud_storm = 5
    )

    opts = list(
      useEasing = TRUE,
      useGrouping = TRUE
    )

    output$counter <- countup::renderCountup({
      count <- nrow(r$data %>% filter(ratingmerge == weather_to_rating[rating]))
      countup::countup(count, duration = 2, options = opts)
    })

  })
}
