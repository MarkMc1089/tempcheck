#' rating_time_series UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_rating_time_series_ui <- function(id){
  ns <- NS(id)
  tagList(
    highchartOuput("rating_time_series")
  )
}

#' rating_time_series Server Functions
#'
#' @noRd
mod_rating_time_series_server <- function(r, id){
  moduleServer(id, function(input, output, session){



    output$rating_time_series <- renderHighchart({

      chart <- data %>%
        select(date, rating) %>%
        mutate(
          week_num = (year(date) - year(min(date))) * 52 + week(date) - week(min(date)),
          date = nextweekday(min(date) %m+% weeks(week_num), 6)
        ) %>%
        group_by(date, rating) %>%
        summarise(n = n(), .groups = "drop_last") %>%
        mutate(per = n / sum(n)) %>%
        suppressWarnings() %>%
        complete(nesting(date, rating), fill = list(n = 0, per = 0)) %>%
        pivot_wider(rating, n, per) %>%
        setNames(c("date", "sunny", "sunny_with_clouds", "cloudy", "rainy", "stormy"))

        cols <- viridis(5)
        cols <- substr(cols, 0, 7)

        highchart() %>%
          hc_add_series(
            type = "line",
            name = "sunny",
            color = cols[1],
            data = chart,
            hcaes(x = date, y = sunny)
          ) %>%
          hc_add_series(
            type = "line",
            name = "sunny",
            color = cols[1],
            data = chart,
            hcaes(x = date, y = sunny)
          ) %>%
          hc_add_series(
            type = "line",
            name = "sunny",
            color = cols[1],
            data = chart,
            hcaes(x = date, y = sunny)
          ) %>%
          hc_add_series(
            type = "line",
            name = "sunny",
            color = cols[1],
            data = chart,
            hcaes(x = date, y = sunny)
          ) %>%
          hc_add_series(
            type = "line",
            name = "sunny",
            color = cols[1],
            data = chart,
            hcaes(x = date, y = sunny)
          ) %>%
          hc_xAxis(
            type = "datetime",
            crosshair = list(
              enabled = TRUE
            )
          ) %>%
          hc_yAxis(min = 0) %>%
          hc_tooltip(
            formatter = JS(
              "function () {
          // The first returned item is the header, subsequent items are the
          // points
          var options = {year: 'numeric', month: 'short'};
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
        }"
            ),
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
