test_that("it imputes a simple example correctly during training", {
  mungebit <- resource()
  iris[1, 1] <- NA
  expect_equal(mungebit$train(iris)[1, 1], mean(iris[-1, 1]))
})

test_that("it imputes a simple example correctly during prediction", {
  mungebit <- resource()
  iris[1, 1] <- NA
  mungebit$train(iris)
  expect_equal(mungebit$predict(iris)[1, 1], mean(iris[-1, 1]))
})







