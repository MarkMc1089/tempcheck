#' global_date_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_global_date_filter_ui <- function(id, ...){
  ns <- NS(id)

  dateRangeInput(
    ns(glue("{id}_date_range")),
    ...
  )
}

#' global_date_filter Server Functions
#'
#' @noRd
mod_global_date_filter_server <- function(r, id, other_filter_col) {
  moduleServer(id, function(input, output, session){
    observeEvent(
      input[[glue("{id}_date_range")]],
      if (input[[glue("{id}_select")]] != "All") {
        r$filtered_data <- r$data %>%
          filter(
            .data[[other_filter_col]] == input[[glue("{id}_select")]],
            between(
              .data$date,
              input[[glue("{id}_date_range")]][1],
              input[[glue("{id}_date_range")]][2]
            )
          )
      } else {
        r$filtered_data <- r$data %>%
          filter(
            between(
              .data$date,
              input[[glue("{id}_date_range")]][1],
              input[[glue("{id}_date_range")]][2]
            )
          )
      }

    )
  })
}

## To be copied in the UI
# mod_global_date_filter_ui("global_date_filter_1")

## To be copied in the server
# mod_global_date_filter_server("global_date_filter_1")
