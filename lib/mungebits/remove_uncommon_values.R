# lib/mungebits/remove_uncommon_values.R
train <- function(dataframe, variables, threshold = 0.01, replacement = "Other") {
  common_values <- list()
  for (v in variables) {
    dataframe[[v]] <- ave(dataframe[[v]], dataframe[[v]], FUN = function(x) {
      if (length(x) / NROW(dataframe) < threshold) {
        "Other"
      } else {
        common_values[[v]] <<- c(common_values[[v]], x[1L])
        x[1L]
      }
    })
  }
  input$common_values <- common_values
  dataframe
}

predict <- function(dataframe, variables, threshold = 0.01, replacement = "Other") {
  variables <- intersect(colnames(dataframe), variables)
  for (v in names(input$common_values)) {
    dataframe[[v]][!is.element(dataframe[[v]], input$common_values[[v]])] <- replacement
  }
  dataframe
}

