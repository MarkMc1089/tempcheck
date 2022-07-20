#' rating_stacked_vertical UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_rating_stacked_vertical_ui <- function(id){
  ns <- NS(id)
  plotlyOutput(ns("rating_stacked_vertical"))
}

#' rating_stacked_vertical Server Functions
#'
#' @noRd
mod_rating_stacked_vertical_server <- function(r, id){
  moduleServer( id, function(input, output, session){
    output$rating_stacked_vertical <- renderPlotly({
      rating_to_labels = c(
        `1` = "Sunny",
        `2` = "Partially Sunny",
        `3` = "Cloudy",
        `4` = "Rainy",
        `5` = "Stormy"
      )
      #colours = rev(substr(viridis(5), 0, 7))
      colours = c("#eba134", "#ebe134", "#34cfeb", "#3434eb", "#eb34ae")

      chart <- r$filtered_data %>%
        select(date, rating) %>%
        arrange(date, rating) %>%
        mutate(
          week_num = (year(date) - year(min(date))) * 52 + week(date) - week(min(date)),
          date = nextweekday(min(date) %m+% weeks(week_num), "Friday")
        ) %>%
        suppressWarnings() %>%
        group_by(date, rating) %>%
        summarise(n = n(), .groups = "drop_last") %>%
        complete(crossing(rating = 1:5), fill = list(n = 0)) %>%
        mutate(per = round(100 * n / sum(n), 1)) %>%
        mutate(
          base = sum(n),
          rating = factor(
            rating,
            levels = names(rating_to_labels),
            labels = rating_to_labels,
            ordered = TRUE
          )
        )

      ggplotly(
        chart %>%
          ggplot(
            aes(
              x = date,
              y = per,
              fill = rating,
              text = glue(
                "{format(date, format = '%d %b %Y')} ({base})\n",
                "{rating}\n",
                "{trimws(format(round(per, 0), nsmall = 0))}%"
              ),
            )
          ) +
          geom_col() +
          labs(
            y = "Percentage of respondents (%)",
            x = element_blank(),
            fill = "Rating"
          ) +
          scale_x_date(
            date_breaks = "1 week",
            expand = c(0,0),
            date_labels = "%d %b %Y"
          ) +
          scale_fill_manual(
            values = setNames(
              colours,
              rating_to_labels)
          ) +
          theme_classic() +
          theme(
            axis.text.x = element_text(
              angle = 45,
              vjust = 1,
              hjust=1
            )
          ),
        tooltip = "text"
      ) %>%
        config(
          displayModeBar = FALSE
        ) %>%
        layout(
          legend = list(orientation = "h",  xanchor = "center", x = 0.5,  y = -0.4)
        )
    })
  })
}

## To be copied in the UI
# mod_rating_stacked_vertical_ui("rating_stacked_vertical_1")

## To be copied in the server
# mod_rating_stacked_vertical_server("rating_stacked_vertical_1")
