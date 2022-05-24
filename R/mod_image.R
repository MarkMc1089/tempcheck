#' image UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_image_ui <- function(id){
  ns <- NS(id)
  tagList(
    imageOutput("image")
  )
}

#' image Server Functions
#'
#' @noRd
mod_image_server <- function(id, image_name){
  moduleServer( id, function(input, output, session){
    output$image <- renderImage({
      # When image_name is myImage, filename is ./images/myImage.jpg
      filename <- normalizePath(
        file.path('./images', paste0(image_name, '.jpg'))
      )

      # Return a list containing the filename and alt text
      list(
        src = filename,
        contentType = "image/jpeg",
        alt = paste("Image", image_name)
      )

    }, deleteFile = FALSE)

  })
}

## To be copied in the UI
# mod_image_ui("image_1")

## To be copied in the server
# mod_image_server("image_1")
