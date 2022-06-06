#' table UI Function
#'
#' @description Shows a table, optionally with a select input to filter it.
#'
#' @param id A unique ID for the the module.
#' @param ... Arguments for the associated `selectInput`.
#' @inheritParams selectInput
#'
#' @noRd
mod_table_ui <- function(id, ...) {
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

#' table Server Function
#'
#' @description Creates a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param r A `reactiveValues` object.
#' @param id A unique ID for the the module.
#' @param filter_col If a `selectInput` is associated, the column it filters on.
#'
#' @noRd
mod_table_server <- function(r, id, filter_col = NULL) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderDataTable({
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
        rename(
          Date   = 1,
          Team   = 2,
          Rating = 3,
          Reason = 4
        ) %>%
        arrange(
          desc(.data$Date),
          .data$Rating
        ) %>%
        mutate(
          Date = format(.data$Date, format = "%a %d %b %Y")
        )

      datatable(table, rownames = FALSE)
    })
  })
}
