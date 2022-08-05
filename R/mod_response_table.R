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
#' @param filter_col If a `selectInput` is associated, the column it filters on.
#'
#' @noRd
mod_response_table_server <- function(r, id, filter_col = NULL) {
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
        left_join(
          tempcheck::cohort_size,
          by = c("date" = "date", "team" = "team"),
          keep = FALSE
        ) %>%
        arrange(
          desc(date),
          team
        ) %>%
        mutate(
          date = format(date, format = "%a %d %b %Y"),
          response_rate = case_when(
            size > 0 ~ round(100 * n / size),
            TRUE ~ NA_real_
          ),
          response_rate = case_when(
            !is.na(response_rate) ~ glue("{response_rate}%"),
            TRUE ~ "No survey sent to team"
          )
        ) %>%
        select(date, team, size, n, response_rate)

      datatable(
        table,
        escape=FALSE,
        rownames = FALSE,
        colnames = c("Date", "Team", "Cohort Size", "Responses", "Response Rate"),
        options = list(
          columnDefs = list(list(className = 'dt-center', targets = "_all")),
          searching = FALSE
        )
      )
    })
  })
}
