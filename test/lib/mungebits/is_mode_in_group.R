test_that("it can tell whether a target is in the mode of a group on a simple example", {
  data <- data.frame(stringsAsFactors = FALSE,
    target = c("A", "A", "A", "B", "C"), group = rep(1, 5))
  
  mb <- resource()
  expect_equal(
    mb$run(data, "target", "group")$is_mode_of_target_by_group,
    c(TRUE, TRUE, TRUE, FALSE, FALSE)
  )
  # Check that it works on one-row data as well.
  expect_true (mb$run(data[1, ], "target", "group")$is_mode_of_target_by_group)
  expect_false(mb$run(data[4, ], "target", "group")$is_mode_of_target_by_group)
})

test_that("it keeps track of different modes for different groups", {
  data <- data.frame(stringsAsFactors = FALSE,
    target = c("A", "A", "A", "B", "C", "C", "C", "C", "B", "A"),
    group = rep(c(1, 2), each = 5))
  
  mb <- resource()
  expect_equal(
    mb$run(data, "target", "group")$is_mode_of_target_by_group,
    c(TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE)
  )
  # Check that it works on one-row data as well.
  expect_true (mb$run(data[1, ], "target", "group")$is_mode_of_target_by_group)
  expect_false(mb$run(data[4, ], "target", "group")$is_mode_of_target_by_group)
  expect_true (mb$run(data[6, ], "target", "group")$is_mode_of_target_by_group)
  expect_false(mb$run(data[9, ], "target", "group")$is_mode_of_target_by_group)
})

test_that("it assigns NA to excluded labels", {
  data <- data.frame(stringsAsFactors = FALSE,
    target = c("A", "A", "A", "B", ""), group = rep(1, 5))
  mb <- resource()
  expect_equal(
    mb$run(data, "target", "group", exclude = "")$is_mode_of_target_by_group,
    c(TRUE, TRUE, TRUE, FALSE, NA)
  )
  # Check that it works on one-row data as well.
  expect_true (mb$run(data[1, ], "target", "group", exclude = "")$is_mode_of_target_by_group)
  expect_false(mb$run(data[4, ], "target", "group", exclude = "")$is_mode_of_target_by_group)
  expect_equal(mb$run(data[5, ], "target", "group", exclude = "")$is_mode_of_target_by_group, NA)
})

