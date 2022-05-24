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
      .data$ID.endDate,
      .data$reason,
      .data$team,
      .data$ratingmerge
    ) %>%
    rename(ID.date = ID.endDate) %>%
    mutate(ID.date = lubridate::dmy(.data$ID.date))

  save(data, file = "data/data.rda")
  data
}
