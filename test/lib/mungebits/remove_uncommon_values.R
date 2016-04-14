test_that("it does not replace a common value", {
  bit <- resource()
  iris$Species <- as.character(iris$Species)
  # Test the mungebit when it is training.
  expect_equal(as.character(bit$run(iris, "Species")[1, 5]), "setosa")
  stopifnot(bit$trained())               
  # And when it is predicting.
  expect_equal(as.character(bit$run(iris, "Species")[1, 5]), "setosa")
})

test_that("it replaces an uncommon value", {
  bit <- resource()
  # Test the mungebit when it is training.
  iris$Species <- as.character(iris$Species)
  iris[1, 5] <- "Bumblebee"
  expect_equal(bit$run(iris, "Species")[1, 5], "Other")
  expect_equal(bit$run(iris, "Species")[1, 5], "Other")
})

test_that("it replaces a previously-unseen value", {
  bit <- resource()
  # Test the mungebit when it is training.
  iris$Species <- as.character(iris$Species)
  iris[1, 5] <- "Bumblebee"
  expect_equal(bit$run(iris, "Species")[1, 5], "Other")
  iris[1, 5] <- "Flubber"
  expect_equal(bit$run(iris, "Species")[1, 5], "Other")
})



