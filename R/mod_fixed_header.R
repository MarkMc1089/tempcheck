#' fixed_header UI Function
#'
#' @description Shows a fixed header with  dashboard title, subtitle and logo.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_fixed_header_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "container-fluid fixed-header",
    div(
      id = "mbie-header",
      style = "background-color: '#00FF00'",
      br(),
      fluidRow(
        col_3(
          div(
            h1("Tempcheck"),
            span("Internal mood survey results", style = "font-size: 10pt")
          ),
        ),
        col_3(
          mod_global_filter_ui(
            "global",
            label = "Team:",
            choices = c("All", "Data & Insight", "Digital")
          )
        ),
        col_3(
          mod_global_date_filter_ui(
            "global",
            label = "Date range:",
            start  = min(unique(data$date)),
            end    = max(unique(data$date)),
            min    = min(unique(data$date)),
            max    = max(unique(data$date)),
            separator = " - ",
            width = "100%"
          )
        ),
        col_3(
          div(
            class = "float-right",
            img(
              src = "www/bsa_logo.svg",
              height = "60px",
              name = "NHSBSA logo",
              alt = "NHS Business Services Authority logo",
              padding = "10px"
            ),
            br()
          )
        ),
      )
    )
  )
}

#' fixed_header Server Function
#'
#' @description Not needed currently.
#'
#' @noRd
mod_fixed_header_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
