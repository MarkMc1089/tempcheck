library(jsonlite)
library(httr)
library(dplyr)

apikey <- "VwmL8jauiXziUNeWAeojaYpyld5UvGXwbBhEABNGc9xJV5RUDhNDh6cwqg+OEXqkh365mCzJBqFd1djZmiCSFQ=="
username <- "paul.farrow@nhs.net"
apiurl <- "https://online1.snapsurveys.com/snaponline/api/surveys/55db4a62-7a8d-4df8-b8aa-0bf2c02a48a2/responses?restrictedVariables=V18,V56,V58,V49"
headers = c(
  'X-USERNAME' = username,
  'X-API-KEY' = apikey
)
result <- content(httr::GET(url = apiurl, httr::add_headers(.headers=headers)),as="parsed")

responses <- result$responses
variables <- lapply(responses, FUN = function(x) x$variables)

lst_df <- lapply(variables, function(x){
  data.frame(
    date = x[[1]]$value,
    team = x[[2]]$value,
    rating = x[[3]]$value,
    reason = x[[4]]$value
  )
})

team_map <- list(
  "1" = "Digital",
  "2" = "Data & Insight"
)

bind_rows(lst_df) %>%
  mutate(team = as.character(team_map[team])) %>%
  toJSON()
