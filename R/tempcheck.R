#' \code{tempcheck} package
#'
#' Dashboard for Tempcheck Survey.
#'
#' @docType package
#' @name tempcheck
#'
#' @importFrom dplyr arrange between bind_rows case_when cur_column desc filter
#' @importFrom dplyr group_by left_join mutate n rename rename_with rowwise select
#' @importFrom dplyr slice summarise ungroup
#' @importFrom DT dataTableOutput renderDataTable datatable
#' @importFrom glue glue
#' @importFrom highcharter hc_add_series hc_annotations hc_exporting hc_legend
#' @importFrom highcharter hc_plotOptions hc_tooltip hc_xAxis hc_yAxis hcaes
#' @importFrom highcharter highchart highchartOutput renderHighchart
#' @importFrom httr GET add_headers content
#' @importFrom lubridate dmy
#' @importFrom purrr map
#' @importFrom rlang .data := sym
#' @importFrom shiny NS br column div fluidPage fluidRow h1 h2 HTML img
#' @importFrom shiny moduleServer reactive renderUI selectInput
#' @importFrom shiny shinyApp tagAppendAttributes tagList tags uiOutput
#' @importFrom TileMaker solo_box
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
