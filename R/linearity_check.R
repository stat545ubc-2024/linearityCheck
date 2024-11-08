#' @title Linear regression model plot with extracted R-squared and p-value
#'
#' @details The function plots two variables x versus y and applies a linear regression model to calculate the adjusted R-squared and p-value
#'
#' @param x numeric vector for independent variable
#' @param y numeric vector for dependent variable
#' @param ... used to check that only x and y are included as inputs. Not needed as input variable.
#'
#' @return numeric value of adjusted R-squared and p-value, and the plot
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_smooth ggtitle theme_bw
#' @importFrom broom glance
#' @importFrom stats lm
#' @importFrom dplyr %>% tibble
#' @export
#'
#' @examples
#' x <- c(0:9)
#' y <- c(5,6,11,13,18,17,21,23,26,27)
#' linearity_check(x,y)
#'
#' if (requireNamespace("datateachr", quietly = TRUE)) {
#'   cancer_sample <- datateachr::cancer_sample
#'   x <- cancer_sample$radius_mean
#'   y <- cancer_sample$perimeter_mean
#'   linearity_check(x,y)
#' }
#'

linearity_check <- function(x,y, ...){

  # Check for number of inputs
  if (length(list(...)) > 0) {
    stop("Only two inputs (x and y) are allowed!")
  }

  # Check for any NAs
  if (any(is.na(x)) || any(is.na(y))) {
    stop("The input contains NA values!")
  }

  # Check if inputs are numeric
  if (!is.numeric(x) || !is.numeric(y)) {
    stop("Imputs x and y must be numeric!")
  }

  # Check if inputs are vectors
  if (!is.vector(x) || !is.vector(y)) {
    stop("Inputs x and y must be vectors!")
  }

  # Check if vectors have same length
  if (length(x) != length(y)) {
    stop("Input vectors must have the same length!")
  }

  # Check if there are enough data points for regression
  if (length(x) < 3) {
    stop("Need at least 3 data points for regression!")
  }


  # Make a tibble with both variables
  my_data = dplyr::tibble(x,y) # call tibble() function within tibble package without loading package

  # Create a linear model: y = Coef*x + intercept
  my_lm <- stats::lm(y ~ x,data = my_data) # model: y ~ x

  # Extract strength of linear model: adj.r.square and p.value
  adj_rsqd <- broom::glance(my_lm)$adj.r.squared # call glance() function within broom package without loading package
  pvalue <- broom::glance(my_lm)$p.value

  # Plot y versus x and add adjusted R-squared value

  my_plot<-my_data %>%
    ggplot2::ggplot(aes(x,y)) + # plot y versus x
    ggplot2::geom_point(alpha = 0.4, color = "darkred") + # adjusted alpha to show the overlap region     between the diagnosis status
    ggplot2::geom_smooth(method = lm, se=FALSE) + # added a linear trendline
    ggplot2::ggtitle(sprintf("Y versus X where Adj R\u00B2 = %.3f", adj_rsqd)) +
    ggplot2::theme_bw()

  return(list(r_squared=adj_rsqd,p_value=pvalue,plot=my_plot)) # return Rsqd, p-value and plot
}

