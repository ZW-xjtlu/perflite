#' @title A function to generate the prediction values for random forest regression.
#' @return a \code{vector} that containing the predictions by linear regression.
#' @details \code{lm_regression} conduct linear regression.
#'
#' @param y a \code{numeric} that contains the real valued response variable.
#' @param X_train a \code{matrix} that contains the features for tarining set, nrow(X) = length(y).
#' @param X_test a \code{matrix} that contains the features for testing set.
#' @param ... additional arguments passed to \code{randomForest} defined in the package \code{randomForest}.
#'
#' @export
#' 
lm_regression <- function(y, X_train, X_test, ...) {
  
  model_matrix <- data.frame(Y = y)
  
  model_matrix <- cbind(model_matrix, X_train)
  
  lm_model <- lm(Y~., data = model_matrix)
  
  lm_pred <- predict(object = lm_model,
                     newdata = X_test)
  
  names(lm_pred) <- NULL
  
  return(lm_pred)
  
}
