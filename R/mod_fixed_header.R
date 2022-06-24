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
  tags$header(
    div(
      class = "container-fluid fixed-header",
      div(
        id = "mbie-header",
        style = "background-color: '#00FF00'",
        br(),
        fluidRow(
          col_3(
            div(
              style = "height: 64 px; display: flex; flex-direction: column;
                      justify-content: center;",
              h1("NHSBSA Weekly Staff Survey"),
            ),
          ),
          col_7(
            fluidRow(
              col_4(
                mod_global_filter_ui(
                  "global",
                  label = "Team:",
                  choices = c("All", "Data & Insight", "Digital")
                )
              ),
              col_8(
                mod_global_date_filter_ui(
                  "global",
                  label = "Date range:",
                  format = "dd-mm-yyyy",
                  start  = dmy("07/06/2022"),
                  end    = now(),
                  min    = dmy("07/06/2022"),
                  max    = now(),
                  separator = " - ",
                  width = "100%"
                )
              )
            )
          ),
          col_2(
            div(
              img(
                src = "www/bsa_logo.svg",
                name = "NHSBSA logo",
                alt = "NHS Business Services Authority logo"
              ),
              br()
            )
          ),
        )
      )
    )
  )
}

#' fixed_header Server Function
#'
#' @description Not needed currently.
#'
#' @noRd
mod_fixed_header_server <- function(r, id) {
  moduleServer(id, function(input, output, session) {

  })
}
