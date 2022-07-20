#' \code{tempcheck} package
#'
#' Dashboard for Tempcheck Survey.
#'
#' @docType package
#' @name tempcheck
#'
#' @importFrom dplyr arrange between bind_rows case_when cur_column count desc
#' @importFrom dplyr filter group_by group_split left_join mutate n pull rename
#' @importFrom dplyr rename_with rowwise select slice summarise transmute ungroup
#' @importFrom DT dataTableOutput renderDataTable datatable
#' @importFrom ggplot2 aes element_blank element_text geom_col ggplot labs
#' @importFrom ggplot2 scale_fill_manual scale_x_date theme theme_classic
#' @importFrom glue glue
#' @importFrom highcharter hc_add_series hc_annotations hc_exporting hc_legend
#' @importFrom highcharter hc_plotOptions hc_tooltip hc_xAxis hc_yAxis hcaes
#' @importFrom highcharter highchart highchartOutput renderHighchart JS
#' @importFrom httr GET add_headers content
#' @importFrom lubridate %m+% dmy now wday week weeks year
#' @importFrom plotly config ggplotly layout plotlyOutput renderPlotly
#' @importFrom purrr map
#' @importFrom rlang .data := sym
#' @importFrom shiny NS br column div fluidPage fluidRow h1 h2 HTML img
#' @importFrom shiny moduleServer reactive renderUI selectInput
#' @importFrom shiny shinyApp tagAppendAttributes tagList tags uiOutput
#' @importFrom tidyr complete crossing nesting pivot_wider starts_with
#' @importFrom usethis use_data
#' @importFrom viridis viridis
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
