#' Pull data from a SNAP survey
#'
#' @description Pull data from a SNAP survey. The data will be returned as
#'   a dataframe, with column names as specified.
#'
#' @param snap_url URL of SNAP server
#' @param headers A named character vector of header keys and values. This allows
#'   for the `X-USERNAME` and `X-API-KEY` headers to be set for SNAP  authentication.
#' @param query A named list of query params and values. This allows the
#'   `restrictedValues` param to be set.
#' @param col_names A character vector of equal length to the number of variables
#' pulled from the survey. Columns of the resulting dataframe will be named from this.
#'
#' @return Returns a dataframe, with column names as specified in `col_names`.
#'
#' @examples
#' \dontrun{
#' # Get data from SNAP survey with ID 123-456, restricted to variables
#' # V18, V56, V58 and V49, as a dataframe. The columns will be named like
#' # V18 -> date, V56 -> team, V58 -> rating and V49 -> reason
#' snap_to_df(
#'   glue(SNAP_URL, SURVEY_ID = "123-456"),
#'   c(
#'     'X-USERNAME' = SNAP_USER,
#'     'X-API-KEY'  = SNAP_API_KEY
#'   ),
#'   list(restrictedVariables = "V18,V56,V58,V49"),
#'   col_names = c("date", "team", "rating", "reason")
#' )
#' }
snap_to_df <- function(snap_url, headers = character(0), query = character(0),
                       col_names) {
  response <- GET(snap_url, add_headers(.headers = headers), query = query)
  response <- content(response, as = "parsed")

  map(response$responses, function(x){
    data.frame(x$variables) %>%
      select(starts_with("value")) %>%
      rename_with(~ col_names)
  }) %>%
    bind_rows()
}


#' Load data from SNAP, clean it and save in a `reactiveValues` object.
#'
#' @description Attempts to read data from SNAP. Once read, the raw data is cleaned.
#' If an error occurs in either of these 2 steps, data is read from an .rda file
#' in the data folder - this contains the last successfully read data from SNAP.
#'
#' @param r A `reactiveValues` object.
#' @inheritParams snap_to_df
#' @param ... Extra arguments passed to `data_prep`. Useful for passing any mappings
#'   or transformations needed.
#'
#' @return Nothing - the data is stored in `r$data`.
#'
#' @examples
#' \dontrun{
#' # create a reactiveValues object to hold data
#' r <- rv()
#'
#' # Get data from SNAP survey with ID 123-456, restricted to variables
#' # V18, V56, V58 and V49, as a dataframe. The columns will be named like
#' # V18 -> date, V56 -> team, V58 -> rating and V49 -> reason. Also, a mapping
#' # is provided for the team variable and a transformation specified for the
#' # date variable.
#' load_data(
#'   r,
#'   glue(SNAP_URL, SURVEY_ID = "123-456"),
#'   c(
#'     'X-USERNAME' = SNAP_USER,
#'     'X-API-KEY'  = SNAP_API_KEY
#'   ),
#'   list(restrictedVariables = "V18,V56,V58,V49"),
#'   col_names = c("date", "team", "rating", "reason"),
#'   maps = list(
#'     team = c(
#'       "1" = "Digital",
#'       "2" = "Data & Insight"
#'     )
#'   ),
#'   transforms <- list(
#'     date = dmy
#'   )
#' )
#' }
load_data <- function(r, snap_url, headers, query, col_names, ...) {
  tryCatch(
    data <- snap_to_df(snap_url, headers, query, col_names),
    error = function(e) {
      print(
        glue(
          "Error reading data from SNAP: {e}\n",
          "Using last read data"
        )
      )
      r$data <- tempcheck::data
      r$filtered_data <- tempcheck::data
      return ()
    }
  )

  tryCatch(
    r$data <- data_prep(data, ...),
    error = function(e) {
      print(
        glue(
          "Error preparing data: {e}\n",
          "Using last read data"
        )
      )
      r$data <- tempcheck::data
      r$filtered_data <- tempcheck::data
      return ()
    }
  )
}


#' Group related content in dashboard
#'
#' @param title Title string
#' @param ... Content elements
#'
#' @return HTML defining the content
#'
#' @examples
#' \dontrun{
#' content_box(
#'   "I have content!",
#'   shiny::selectInput("input", "Choose", c("Option 1", "Option 2")),
#'   shiny::uiOutput("output")
#' )
#' }
content_box <- function(title, ...) {
  div(
    class = "ui card",
    style = "margin:auto; width:100%;",
    div(
      class = "extra content",
      style = "background-color: #E8EDEE;",
      div(
        class = "left aligned description",
        style = "font-size:16px; color: black;",
        HTML(glue("<b>{title}</b>"))
      )
    ),
    div(
      class = "content",
      div(
        ...
      )
    )
  )
}

tile <- function (value, img_src = NULL, alt_text = NULL, bg_colour = "#005ebf", height = "64px") {
  if (!is.null(img_src)) {
    stopifnot(!is.null(alt_text))

    div(
      style = glue("background-color: {bg_colour}; height: {height}; border-radius: 4px"),
      div(
        style = "color: black; font-weight: bold;",
        div(img(src = img_src, alt = alt_text)),
        div(
          class = "tile",
          style = glue(
            "height: {height}; display: flex; flex-direction: column;
            justify-content: center;"
          ),
          value
        )
      )
    )
  } else {
    div(
      style = glue("background-color: {bg_colour}; height: {height}; border-radius: 4px"),
      div(
        style = "color: black; font-weight: bold;",
        div(
          class = "tile-text-only",
          style = glue(
            "height: {height}; display: flex; flex-direction: column;
          justify-content: center;"
          ),
          value
        )
      )
    )
  }
}
