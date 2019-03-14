#' @title A function to generate the cross validated decision values.
#' @return a \code{vector} that is the same length of y containing the real value decision values after cross validation.
#' @details \code{predict_cv} conduct predictions of machine learning binary classifier with cross validation.
#' This is a convenient function to get a neat and efficient result of prediction after cross validation. The output can be piped directly into the downstream performance evaluation.
#'
#' The missing values will not be imputed by default, and the dimensions containing missing values will be dropped.
#'
#' @param y a \code{factor} that contains the binary response variable with levels 1,0 for binary classification.
#' @param X a \code{matrix} that contains the features, nrow(X) = length(y).
#' @param cv_f a function that gets the input argument named y , X_train, and X_test, and output is the real numbered decision values for X_test.
#'
#' For example, the returned values can be the votes proportions for random forest, and it can also be the decision values for SVM.
#'
#' This package contains buildin predictor functions for you to use, such as: \code{\link{svm_f}} and \code{\link{randomForest_f}}
#' However, it is still recommended to create your own function with tunned parameters.
#'
#' @param k the number of folds used in cross validation, default 10.
#' @param p the number of parallels used, default equals 1, recommend to use p = k on server.
#' @param ... additional arguments passed to \code{cv_f}
#'
#' @importFrom caret createFolds
#' @import BiocParallel
#' @export
predict_cv <- function(y,
                       X,
                       cv_f = svm_f,
                       k = 10,
                       p = 1,
                       ...) {
  ##check input errors
  stopifnot(is.factor(y))
  stopifnot(is.matrix(X)|is.data.frame(X))
  stopifnot(nrow(X) == length(y))
  stopifnot(length(levels(y)) == 2)
  stopifnot(all(levels(y) %in% c(1,0)))
  stopifnot(p > 0)

  ##deal with NAs
  na_indx <- is.na(y)|(rowSums(is.na(X)) > 0)
  y <- y[!na_indx]
  X <- X[!na_indx,]

  #divide the data into K folds
  idx <- createFolds(y, k=k)

  #Set K folds cv helper function
  k_pred <- function(i,...){
    suppressMessages( require(perflite) )
    print(paste("Fold", i, "training..."))
    return(cv_f(y=y[ -idx[[i]] ],
                X_train=X[ -idx[[i]], ],
                X_test=X[ idx[[i]], ],
                ...))
  }

  #Conduct iteration
  if(p == 1){
  decs_lst <- lapply(seq_len(k),k_pred)
  }else{
  #set parallel parameters
  register(SerialParam(), default = FALSE)
  register(MulticoreParam(workers = p))
  register(SnowParam(workers = p))
  decs_lst <- bplapply(seq_len(k), k_pred)
  }

  #Fill in NAs at corresponding dimensions
  decision_return <- rep(NA,length = length(na_indx))
  decision_return[!na_indx][unlist(idx)] <- unlist( decs_lst )

  #return the cross validated decision values
  return(decision_return)
}




