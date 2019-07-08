#' @title A function to generate the decision values for random forest classification.
#' @return a \code{vector} that containing the positive voting proportions of the random forest model for testing set.
#' @details \code{svm_f} conduct binary classification using randomForest.
#'
#' @param y a \code{factor} that contains the binary response variable with levels 1,0 for prediction.
#' @param X_train a \code{matrix} that contains the features for tarining set, nrow(X) = length(y).
#' @param X_test a \code{matrix} that contains the features for testing set.
#' @param ... additional arguments passed to \code{randomForest} defined in the package \code{randomForest}.
#'
#' @importFrom randomForest randomForest
#' @export
randomForest_class <- function(y,X_train,X_test,...){
  rf_model <- randomForest( y = y, x = X_train,...)
  rf_votes <- predict(object = rf_model,
                      newdata = X_test,
                      type = "prob")[,2]
  names(rf_votes) <- NULL
  return(rf_votes)
}
