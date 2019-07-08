#' @title A function to generate the prediction values for svm regression.
#' @return a \code{vector} that is the same length of y containing the prediction values on testing set.
#' @details \code{svm_regression} conduct support vector regression.
#'
#' @param y a \code{numeric} that contains the real valued response variable.
#' @param X_train a \code{matrix} that contains the features for tarining set, nrow(X) = length(y).
#' @param X_test a \code{matrix} that contains the features for testing set.
#' @param ... additional arguments passed to \code{svm} defined in the package \code{e1071}.
#'
#' @importFrom e1071 svm
#' @export
svm_regression <- function(y, X_train, X_test, ...) {

  svm_model <- svm(y = y, x = X_train, kernel = "linear", ...)

  svm_pred <- predict(
    object = svm_model,
    newdata = X_test
  )

  names(svm_pred) <- NULL
  return(svm_pred)
}
