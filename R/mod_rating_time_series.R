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
    highchartOutput(ns("rating_time_series"))
  )
}

#' rating_time_series Server Functions
#'
#' @noRd
mod_rating_time_series_server <- function(r, id){
  moduleServer(id, function(input, output, session){
    output$rating_time_series <- renderHighchart({
      chart <- r$filtered_data %>%
        select(date, rating) %>%
        mutate(
          week_num = (year(date) - year(min(date))) * 52 + week(date) - week(min(date)),
          date = nextweekday(min(date) %m+% weeks(week_num), "Friday")
        ) %>%
        group_by(date, rating) %>%
        summarise(n = n(), .groups = "drop_last") %>%
        complete(crossing(rating = 1:5), fill = list(n = 0)) %>%
        ungroup() %>%
        mutate(per = round(100 * n / sum(n), 1)) %>%
        suppressWarnings() %>%
        pivot_wider(names_from = rating, values_from = c(per, n)) %>%
        mutate(base = rowSums(select(., starts_with("n"))))

        cols <- viridis(5)
        cols <- substr(cols, 0, 7)

        highchart() %>%
          hc_add_series(
            chart,
            type = "line",
            hcaes(x = date, y = per_1, b = n_1),
            name = "Sunny",
            color = cols[1]
          ) %>%
          hc_add_series(
            chart,
            hcaes(x = date, y = per_2, b = n_2),
            type = "line",
            name = "Partially Sunny",
            color = cols[2]
          ) %>%
          hc_add_series(
            chart,
            hcaes(x = date, y = per_3, b = n_3),
            type = "line",
            name = "Cloudy",
            color = cols[3]
          ) %>%
          hc_add_series(
            chart,
            hcaes(x = date, y = per_4, b = n_4),
            type = "line",
            name = "Rainy",
            color = cols[4]
          ) %>%
          hc_add_series(
            chart,
            type = "line",
            hcaes(x = date, y = per_5, b = n_5),
            name = "Stormy",
            color = cols[5]
          ) %>%
          hc_xAxis(
            type = "datetime",
            crosshair = list(
              enabled = TRUE
            )
          ) %>%
          hc_yAxis(min = 0) %>%
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
