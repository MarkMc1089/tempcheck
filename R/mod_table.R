#' table_with_group_select UI Function
#'
#' @description Shows a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_table_ui <- function(id) {
  ns <- NS(id)
  div(
    DT::dataTableOutput(ns("table"))
  )
}

#' table_with_group_select Server Function
#'
#' @description Creates a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param id String id, to match the corresponding UI element
#' @param col_name String of the column name for comments to show.
#' month in the data, then 2 for 2nd latest etc.
#' @param r A reactiveValues object
#'
#' @noRd
#'
mod_table_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    output$table <- DT::renderDataTable({
      table <- r$data %>%
        rename(
          Date  = 1,
          Reason  = 2,
          Team = 3,
          Rating  = 4
        ) %>%
        arrange(
          desc(.data$Date),
          .data$Rating
        ) %>%
        mutate(
          Date = format(.data$Date, format = "%a %d %b %y")
        )

      DT::datatable(table, rownames = FALSE)
    })
  })
}
