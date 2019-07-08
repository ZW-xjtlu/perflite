#' @title A function to generate the prediction values for random forest regression.
#' @return a \code{vector} that containing the predictions by randomForest regression.
#' @details \code{randomForest_regression} conduct regression using randomForest.
#'
#' @param y a \code{numeric} that contains the real valued response variable.
#' @param X_train a \code{matrix} that contains the features for tarining set, nrow(X) = length(y).
#' @param X_test a \code{matrix} that contains the features for testing set.
#' @param ... additional arguments passed to \code{randomForest} defined in the package \code{randomForest}.
#'
#' @importFrom randomForest randomForest
#' @export
#' 
randomForest_regression <- function(y, X_train, X_test, ...) {
  rf_model <- randomForest( y = y, x = X_train,...)
  rf_pred <- predict(object = rf_model,
                      newdata = X_test)
  names(rf_pred) <- NULL
  return(rf_pred)
}
