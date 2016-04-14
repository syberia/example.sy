variable_name <- function(target_variable, grouping_variable) {
  paste0("is_mode_of_", target_variable, "_by_", grouping_variable)
}

train <- function(data, target_variable, grouping_variable, name, exclude = NA_character_) {
  stopifnot(is.character(target_variable),
    is.character(grouping_variable), is.character(exclude),
    length(target_variable) == 1, length(grouping_variable) == 1,
    target_variable %in% colnames(data), grouping_variable %in% colnames(data))
  if (missing(name)) name <- variable_name(target_variable, grouping_variable)
  stopifnot(is.character(name) && length(name) == 1 && !is.na(name) && nzchar(name))

  if (!is.character(data[[target_variable]])) {
    stop("The is_mode_in_group mungebit currently only supports character features.")
  }

  string_mode <- function(x) {
    if (length(x) == 0) NA_character_
    else {
      counts <- table(x)
      names(counts)[which.max(counts)]
    }
  }

  input$modes <- list() # Store each mode by state.
  data[[name]] <- as.logical(
    ave(seq_len(NROW(data)), data[[grouping_variable]], FUN = function(ix) {
      var   <- data[ix, target_variable]
      group <- as.character(data[ix[1L], grouping_variable])
      if (length(unique(var)) == 1) {
        input$modes[[group]] <- NA
        NA
      } else {
        input$modes[[group]] <- mode <-
          string_mode(Filter(function(x) !x %in% exclude, var))
        ifelse(var %in% exclude, NA, var == mode)
      }
    })
  )
  data
}

predict <- function(data, target_variable, grouping_variable, name, exclude = NA_character_) {
  if (missing(name)) name <- variable_name(target_variable, grouping_variable)
  groups <- match(as.character(data[[grouping_variable]]), names(input$modes))
  var <- logical(NROW(data))
  var[is.na(groups)]  <- NA
  var[!is.na(groups)] <- as.logical(
    ave(seq_len(NROW(data)), data[[grouping_variable]], FUN = function(ix) {
      slice <- data[ix, target_variable]
      ifelse(slice %in% exclude, NA,
             slice == input$modes[[as.character(data[ix[1L], grouping_variable])]])
    }))
  data[[name]] <- var
  data
}

