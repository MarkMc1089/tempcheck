#' 00_header UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_00_header_ui <- function(id) {
  tagList(
    fluidRow(
      style = "background-color: #005EB8; width: 100%",
      align = "center",
      fluidRow(
        style = "background-color: #005EB8; max-width: 950px",
        align = "left",
        splitLayout(
          cellArgs = list(style = "padding: 15px"),
          tags$a(
            href = "https://www.nhs.uk/",
            target = "_blank",
            img(src = "www/logo.jpg", height = "10%", width = "10%")
          )
        )
      )
    )
  )
}

#' 00_header Server Function
#'
#' @noRd
mod_00_header_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
