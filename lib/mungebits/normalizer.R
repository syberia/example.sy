normalize <- function(variable, mean, stdev) {
  (variable - mean) / stdev
}

normalizer <- mungebit$new(function(data, variables) {
  input$means <- lapply(data[variables], mean, na.rm = TRUE)
  input$stdev <- lapply(data[variables], stats::sd, na.rm = TRUE)
  names(input$means) <- names(input$stdev) <- variables
  data[variables] <- Map(normalize, data[variables], input$means, input$stdev)
  data
}, function(data, variables) {
  # We should be careful since the variables may not be in the
  # same order when we're looking at new data.
  data[variables] <-
    Map(normalize, data[match(variables, names(input$means))],
        input$means, input$stdev)
  data
})

head(normalizer$run(iris, "Sepal.Length"))
