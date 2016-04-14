test_that("it can parse a simple state example", {
  data <- data.frame(location = c("Birmingham, AL", "Chicago, IL", "Mars"),
                     stringsAsFactors = FALSE)
  # resource() will build us the mungebit: same as mungebit$new(train)
  expect_equal(resource()$run(data, "location", "state")$state,
               c("AL", "IL", ""))
})
