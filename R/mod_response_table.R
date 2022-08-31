#' response_table UI Function
#'
#' @description Shows a table of response rates, optionally with a select input
#' to filter it.
#'
#' @param id A unique ID for the the module.
#' @param ... Arguments for the associated `selectInput`.
#' @inheritParams selectInput
#'
#' @noRd
mod_response_table_ui <- function(id, ...) {
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

#' response_table Server Function
#'
#' @description Creates a table with month, comment and NPS group. Includes a
#' select input to filter to a specific group.
#'
#' @param r A `reactiveValues` object.
#' @param id A unique ID for the the module.
#'
#' @noRd
mod_response_table_server <- function(r, id) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderDataTable({

      table <- r$filtered_data %>%
        select(date, team) %>%
        na.omit() %>%
        mutate(
          week_num = (year(date) - year(min(date))) * 52 + week(date) - week(min(date)),
          date = nextweekday(min(date) %m+% weeks(week_num), "Friday")
        ) %>%
        suppressWarnings() %>%
        group_by(date, team) %>%
        summarise(n = n()) %>%
        ungroup() %>%
        complete(
          date = seq.Date(min(date), max(date), by="week"),
          team
        ) %>%
        left_join(
          tempcheck::cohort_size,
          by = c("date" = "date", "team" = "team"),
          keep = FALSE
        ) %>%
        mutate(
          formatted_date = format(date, format = "%a %d %b %Y"),
          response_rate = case_when(
            size > 0 ~ round(100 * n / size),
            TRUE ~ NA_real_
          ),
          response_rate = case_when(
            !is.na(response_rate) ~ glue("{response_rate}%"),
            TRUE ~ "No survey sent to team"
          )
        ) %>%
        complete(
          nesting(date, formatted_date), team,
          fill = list(size = 0, n = 0, response_rate = "No survey sent to team")
        ) %>%
        select(date, formatted_date, team, size, n, response_rate) %>%
        arrange(
          desc(date),
          team
        )

      datatable(
        table,
        escape=FALSE,
        rownames = FALSE,
        colnames = c("Date", "Team", "Cohort Size", "Responses", "Response Rate"),
        options = list(
          columnDefs = list(
            list(className = 'dt-center', targets = "_all"),
            list(orderable = TRUE, targets = 0),
            list(orderData = 0, targets = 1),
            list(visible = FALSE, targets = 0)
          ),
          searching = FALSE
        )
      )
    })
  })
}
