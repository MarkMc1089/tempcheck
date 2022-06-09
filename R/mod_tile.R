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
mod_tile_server <- function(r, id, rating_key = NULL, day = NULL){
  moduleServer(id, function(input, output, session){

    weather_to_rating <- list(
      sun         = 1,
      sun_cloud   = 2,
      cloud       = 3,
      cloud_rain  = 4,
      cloud_storm = 5
    )

    rating_to_weather <- setNames(names(weather_to_rating), unname(weather_to_rating))

    weather_to_svg = list(
      sun = "day",
      sun_cloud = "cloudy-day-3",
      cloud = "cloudy",
      cloud_rain = "rainy-6",
      cloud_storm = "thunder"
    )

    weather_to_alt_text <- list(
      sun = "Sun icon",
      sun_cloud = "Sun and clouds icon",
      cloud = "Clouds icon",
      cloud_rain = "Rainy cloud icon",
      cloud_storm = "Thunder cloud icon"
    )

    output$tile <- renderUI({
      if (!is.null(rating_key)) {
        ratings <- r$filtered_data %>%
        # ratings <- data %>%
          select(rating) %>%
          complete(rating = 1:5) %>%
          count(rating) %>%
          mutate(percent = 100 * prop.table(n)) %>%
          filter(.data$rating == weather_to_rating[rating_key])

        percent <- glue(
          "{ratings %>% pull(percent) %>% format(digits = 2, nsmall = 1)}%"
        )

        img_src <- glue("animated_svgs/{weather_to_svg[rating_key]}.svg")
        out <- tile(percent, img_src, weather_to_alt_text[rating_key])
      }

      if (!is.null(day)) {
        avg_rating <- r$filtered_data %>%
          mutate(weekday = tolower(wday(.data$date, label = TRUE))) %>%
          group_by(weekday) %>%
          summarise(avg_rating = floor(mean(rating, na.rm=TRUE))) %>%
          filter(weekday == day) %>%
          pull(avg_rating)

        rating_key <- rating_to_weather[as.character(avg_rating)]

        img_src <- glue("animated_svgs/{weather_to_svg[rating_key]}.svg")
        out <- tile(toupper(day), img_src, weather_to_alt_text[rating_key])
      }

      out
    })

  })
}
