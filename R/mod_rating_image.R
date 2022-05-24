#' image UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_rating_image_ui <- function(id){
  ns <- NS(id)
  tagList(
    imageOutput(ns("image"), width = "100px", height = "100px")
  )
}

#' image Server Functions
#'
#' @noRd
mod_rating_image_server <- function(id, image_name){
  moduleServer( id, function(input, output, session){
    output$image <- renderImage({
      path = file.path(
        app_sys("app/www/images"),
        paste0("rating_", image_name, ".jpg")
      )

      # Return a list containing the filename and alt text
      list(
        src = path,
        contentType = "image/jpeg",
        alt = paste("Image", image_name)
      )

    }, deleteFile = FALSE)

  })
}
