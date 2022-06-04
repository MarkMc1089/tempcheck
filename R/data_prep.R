#' Prepare data
#'
#' Cleans and prepares raw data, saving it as an .rda file in data folder.
#'
#' @param raw_data A data-frame-like object
#'
#' @return Prepared data
#'
#' @noRd
#'
data_prep <- function(raw_data) {
  data <- raw_data %>%
    slice(-1) %>%
    select(
      .data$date,
      .data$reason,
      .data$team,
      .data$rating
    ) %>%
    mutate(date = lubridate::dmy(.data$date))

  save(data, file = "data/data.rda")
  data
}
