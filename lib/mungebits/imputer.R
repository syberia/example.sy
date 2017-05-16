train <- function(data) {
  numeric_columns <- vapply(data,
    function(x) is.numeric(x) && any(is.na(x)), logical(1))
  input$columns <- colnames(data)[numeric_columns]
  input$means <- list()
  data[numeric_columns] <- lapply(input$columns, function(column) {
    input$means[[column]] <- mean(data[[column]], na.rm = TRUE)
    col <- data[[column]]
    col[is.na(col)] <- input$means[[column]]
    col
  })
  data
}

predict <- function(data) {
  data[input$columns] <- lapply(input$columns, function(column) {
    col <- data[[column]]
    col[is.na(col)] <- input$means[[column]]
    col
  })
  data
}
