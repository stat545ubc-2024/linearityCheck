test_that("x and y are a numeric vector", {
  y <- c(1:3)
  expect_error(linearity_check(c(1, 2, NA), y)) # NA value
  expect_error(linearity_check("a", y)) # x is not numeric
  expect_error(linearity_check(c(1, 2), y)) # not same length
  expect_error(linearity_check(c(1,2), c(5,10))) # length less than 3
})

test_that("x and y are a numeric vector", {
  x <- c(0,2,4,3,4)
  y <- dplyr::tibble(c(1:5),c(5:1))
  expect_error(linearity_check(x)) # not enough inputs. Need x and y
  expect_error(linearity_check(x, y)) # y is not a numeric vector
  expect_error(linearity_check(c(1:3), c(1,6,9),c(2:3))) # more than two inputs
})

test_that("output has expected components", {
  x <- c(0:9)
  y <- c(5,6,11,13,18,17,21,23,26,27)
  output<-linearity_check(x,y)
  expect_type(output, "list")
  expect_named(output, c("r_squared", "p_value", "plot"))
  expect_equal(length(output),3)
})
