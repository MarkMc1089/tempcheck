#' response_rate_time_series UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_response_rate_time_series_ui <- function(id){
  ns <- NS(id)
  tagList(
    highchartOutput(ns("response_rate_time_series"))
  )
}

#' response_rate_time_series Server Functions
#'
#' @noRd
mod_response_rate_time_series_server <- function(r, id){
  moduleServer(id, function(input, output, session){

    cohort_size = list(
      "Data & Insight" = 117,
      "Digital"        = 213
    )

    output$response_rate_time_series <- renderHighchart({
      chart <- r$filtered_data %>%
        select(date, team) %>%
        na.omit() %>%
        mutate(
          week_num = (year(date) - year(min(date))) * 52 + week(date) - week(min(date)),
          date = nextweekday(min(date) %m+% weeks(week_num), "Friday")
        ) %>%
        suppressWarnings() %>%
        group_by(team, date) %>%
        summarise(n = n()) %>%
        mutate(
          cohort = as.numeric(paste(cohort_size[team])),
          response_rate = round(100 * n / cohort)
        )

        charts <- chart %>% group_split()

        hc <- highchart()

        for (chart in charts) {
          hc <- hc %>% hc_add_series(
            chart,
            type = "line",
            hcaes(x = date, y = response_rate),
            name = chart$team %>% unique()
          )
        }

        hc %>%
          hc_xAxis(
            type = "datetime",
            crosshair = list(
              enabled = TRUE
            )
          ) %>%
          hc_yAxis(title = list(text = "Response Rate (%)"), min = 0) %>%
          hc_tooltip(
            formatter = JS("
              function () {
                // The first returned item is the header, subsequent items are the
                // points
                var options = {year: 'numeric', month: 'short', day: 'numeric'};
                var dtf = new Intl.DateTimeFormat('en-EN', options);

                return ['<b>' + dtf.format(this.x) + '</b>'].concat(
                  this.points ?
                    this.points.map(function (point) {
                    console.log(point)
                      b = point.point.b ? ' (base: ' + point.point.b + ')' : '';
                      c = point.point.c ? '<br>' + point.point.c : ''
                      return '<span style=\"color: ' + point.series.color + '\"><strong>' + point.series.name + ': ' + point.y + ' ' + b + '</strong></span>' + c;
                    }) : []
                );
              }
            "),
            split = TRUE,
            useHTML = TRUE
          ) %>%
          hc_plotOptions(
            line = list(
              marker = list(
                radius = 4.5,
                lineWidth = 0.75,
                lineColor = "#000",
                symbol = 'circle'
              )
            ),
            series = list(
              dataLabels = list(
                enabled = TRUE,
                style = list(
                  color = "black",
                  fontWeight = "bolder",
                  fontSize = "15px"
                )
              )
            )
          )
      })
  })
}
