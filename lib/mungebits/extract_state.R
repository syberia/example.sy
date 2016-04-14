train <- predict <- function(dataframe, from, to) {
  extract_state <- function(strings) {
    has_state <- grepl("[A-Z]{2}", strings)
    output <- character(length(strings))
    output[has_state] <- gsub(".*([A-Z]{2}).*", "\\1", strings[has_state])
    output
  }
  dataframe[[to]] <- extract_state(dataframe[[from]])
  dataframe
}
