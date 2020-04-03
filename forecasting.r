# frequency, period, data
################################################################

tryCatch({
  library(prophet)

  args <- commandArgs(trailingOnly = TRUE)

  m <- prophet(read.csv(args[2]))

  future   <- make_future_dataframe(m, periods = as.numeric(args[1]))
  forecast <- predict(m, future)

  write.csv(tail(forecast[c('ds', 'yhat')], n = as.numeric(args[1])), row.names = FALSE)
}, error = function (e) {
  cat(geterrmessage())
})
