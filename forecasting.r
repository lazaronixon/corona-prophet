# frequency, data
################################################################

tryCatch({
  library(prophet)

  args <- commandArgs(trailingOnly = TRUE)

  dataset   <- read.csv(args[2])
  dataset$y <- c(dataset$y[1], diff(dataset$y))

  m <- prophet(dataset)

  future   <- make_future_dataframe(m, periods = as.numeric(args[1]))
  forecast <- predict(m, future)
  forecast$yhat <- cumsum(forecast$yhat)

  write.csv(tail(forecast[c('ds', 'yhat')], as.numeric(args[1])), row.names = FALSE)
}, error = function (e) {
  cat(geterrmessage())
})
