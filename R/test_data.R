library(stringi)

set.seed(42)

data <- data.frame(
  date = sample(seq(as.Date('2022-06-07'), as.Date('2022-12-31'), by = "day"), 1000, replace = TRUE),
  team = sample(1:2, 1000, replace = TRUE),
  rating = sample(1:5, 1000, replace = TRUE, prob = c(0.20, 0.45, 0.15, 0.10, 0.05)),
  comment = unlist(lapply(1:1000, stri_rand_lipsum, n_paragraphs = 1, start_lipsum = FALSE))
)

save(data, file = "data/data.rda")
