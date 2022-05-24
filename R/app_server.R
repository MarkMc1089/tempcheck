
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @noRd
app_server <- function(input, output, session) {
  eval_lines(".mongo-credentials")

  r <- rv()

  load_data(r, "data")

  mod_rating_image_server("image_sun", "sun")
  mod_rating_image_server("image_sun_cloud", "sun_cloud")
  mod_rating_image_server("image_cloud", "cloud")
  mod_rating_image_server("image_cloud_rain", "cloud_rain")
  mod_rating_image_server("image_cloud_storm", "cloud_storm")
  mod_countup_server("countup_sun", "sun", r)
  mod_countup_server("countup_sun_cloud", "sun_cloud", r)
  mod_countup_server("countup_cloud", "cloud", r)
  mod_countup_server("countup_cloud_rain", "cloud_rain", r)
  mod_countup_server("countup_cloud_storm", "cloud_storm", r)
  mod_table_server("table_1", r)
  # mod_3_month_nps_groups_server("nps_groups_3_month", r)
  # mod_prom_det_tile_row_server("current-0", 1, r)
  # mod_prom_det_tile_row_server("current-1", 2, r)
  # mod_prom_det_tile_row_server("current-2", 3, r)
  # mod_3_month_tile_server("nps_3_month_tile", "NPS", r)
  # mod_monthly_chart_server("nps_monthly", "NPS", r)
  # mod_table_group_select_server("overall_why", "Overall_why", r)
  # mod_monthly_chart_server("nes_monthly", "NES", r)
  # mod_3_month_tile_server("nes_3_month_tile", "NES", r)
  # mod_table_group_select_server("suggestions", "Q4", r)
}
