#' comment_table UI Function
#'
#' @description Shows a table of comments, optionally with a select input to filter it.
#'
#' @param id A unique ID for the the module.
#' @param ... Arguments for the associated `selectInput`.
#' @inheritParams selectInput
#'
#' @noRd
mod_comment_table_ui <- function(id, ...) {
  ns <- NS(id)

  out <- dataTableOutput(ns("table"))

  if (!missing(...)) {
    out <- div(
      selectInput(
        ns(glue("{id}_select")),
        ...
      ),
      out
    )
  }

  out
}

#' comment_table Server Function
#'
#' @description Creates a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param r A `reactiveValues` object.
#' @param id A unique ID for the the module.
#' @param filter_col If a `selectInput` is associated, the column it filters on.
#'
#' @noRd
mod_comment_table_server <- function(r, id, filter_col = NULL) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderDataTable({

      rating_to_image <- list(
        `1` = "day",
        `2` = "cloudy-day-3",
        `3` = "cloudy",
        `4` = "rainy-6",
        `5` = "thunder"
      )

      rating_to_alt_text = list(
        `1` = "Sun icon",
        `2` = "Sun and clouds icon",
        `3` = "Clouds icon",
        `4` = "Rainy cloud icon",
        `5` = "Thunder cloud icon"
      )

      table <- r$filtered_data

      if (!is.null(filter_col)) {
        if (input[[glue("{id}_select")]] != "All") {
          table <- table %>%
            filter(
              .data[[filter_col]] == input[[glue("{id}_select")]]
            )
        }
      }

      table <- table %>%
        filter(reason != "") %>%
        arrange(
          desc(.data$date),
          .data$rating
        ) %>%
        mutate(
          formatted_date = format(.data$date, format = "%a %d %b %Y"),
          rating = glue(
            "<img order = {rating} src='animated_svgs/{rating_to_image[rating]}.svg'
            alt='{rating_to_alt_text[rating]}' height='50'></img>"
          )
        ) %>%
        select(date, formatted_date, team, rating, reason)

      datatable(
        table,
        escape=FALSE,
        rownames = FALSE,
        colnames = c("", "Date", "Team", "Rating", "Reason"),
        options = list(
          columnDefs = list(
            list(className = 'dt-center', targets = "_all"),
            list(orderable = TRUE, targets = 0),
            list(orderData = 0, targets = 1),
            list(visible = FALSE, targets = 0)
          )
        )
      )
    })
  })
}
