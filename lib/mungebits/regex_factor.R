# This mungebit converts a list of presumably independent regex
# matches to a categorical feature. For example, if
#
# cases = c(foo = "^foo", bar = "^bar", baz = "baz$")
#
# then applying this to c("food", "barfood", "books", "goombaz")
# will yield c("foo", "bar", "other", "baz") as a categorical feature
# with levels c("foo", "bar", "baz", "other").
train <- column_transformation(function(feature, cases, other = "other", name) {
  if (!is.character(feature)) {
    stop("The feature ", sQuote(name), " must be of type character ",
         "when used with the regex_factor mungebit.")
  }

  x <- Reduce(function(labels, case) {
    ifelse(grepl(case, fixed = TRUE, feature),
           names(case), labels)
  }, Map(`names<-`, names(cases), cases), character(length(feature)))
  x[!nzchar(x)] <- other
  factor(x, c(names(cases), other))
})

