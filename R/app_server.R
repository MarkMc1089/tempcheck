#' @param input,output,session Internal parameters for {shiny}.
#'
#' @noRd
app_server <- function(input, output, session) {

  eval_lines(".snap-credentials")

  r <- rv()

  load_data(
    r,
    glue(SNAP_URL, SURVEY_ID = "55db4a62-7a8d-4df8-b8aa-0bf2c02a48a2"),
    c(
      'X-USERNAME' = SNAP_USER,
      'X-API-KEY'  = SNAP_API_KEY
    ),
    list(restrictedVariables = "V18,V56,V58,V49", maxResponses = "5000"),
    col_names <- c("date", "team", "rating", "reason"),
    maps = list(
      team = c(
        "1" = "Digital",
        "2" = "Data & Insight"
      )
    ),
    transforms <- list(
      date = dmy,
      rating = as.integer
    )
  )

  data <- tempcheck::data

  mod_global_date_filter_server(r, "global", "team")
  mod_global_filter_server(r, "global", "team")
  mod_tile_server(r, "count_sun", "sun")
  mod_tile_server(r, "count_sun_cloud", "sun_cloud")
  mod_tile_server(r, "count_cloud", "cloud")
  mod_tile_server(r, "count_cloud_rain", "cloud_rain")
  mod_tile_server(r, "count_cloud_storm", "cloud_storm")
  mod_tile_server(r, "response_count", value = "count")
  mod_tile_server(r, "response_rate", value = "rate")
  mod_table_server(r, "table_1")
}
