#' \code{tempcheck} package
#'
#' Dashboard for Tempcheck Survey.
#'
#' @docType package
#' @name tempcheck
#'
#' @importFrom dplyr arrange between bind_rows case_when cur_column count desc
#' @importFrom dplyr filter group_by left_join mutate n pull rename rename_with
#' @importFrom dplyr rowwise select slice summarise transmute ungroup
#' @importFrom DT dataTableOutput renderDataTable datatable
#' @importFrom glue glue
#' @importFrom highcharter hc_add_series hc_annotations hc_exporting hc_legend
#' @importFrom highcharter hc_plotOptions hc_tooltip hc_xAxis hc_yAxis hcaes
#' @importFrom highcharter highchart highchartOutput renderHighchart JS
#' @importFrom httr GET add_headers content
#' @importFrom lubridate %m+% dmy now wday week weeks year
#' @importFrom purrr map
#' @importFrom rlang .data := sym
#' @importFrom shiny NS br column div fluidPage fluidRow h1 h2 HTML img
#' @importFrom shiny moduleServer reactive renderUI selectInput
#' @importFrom shiny shinyApp tagAppendAttributes tagList tags uiOutput
#' @importFrom tidyr complete crossing nesting pivot_wider starts_with
#' @importFrom viridis viridis
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
