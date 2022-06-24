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
data_prep <- function(raw_data, maps, transforms) {
  data <- raw_data %>%
    mutate(
      across(names(maps),       ~ maps[[cur_column()]][.x]),
      across(names(transforms), ~ transforms[[cur_column()]](.x))
    )

  use_data(data, overwrite = TRUE)

  data
}
