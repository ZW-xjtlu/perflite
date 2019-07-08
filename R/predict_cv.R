#' @title A function to generate the cross validated prediction/decision values.
#' @return a \code{vector} that is the same length of y containing the real value decision values after cross validation.
#' @details \code{predict_cv} conduct predictions of machine learning binary classifier with cross validation.
#' This is a convenient function to get a neat and efficient result of prediction after cross validation. The output can be piped directly into the downstream performance evaluation.
#'
#' The missing values will not be imputed by default, and the dimensions containing missing values will be dropped.
#'
#' @param y an object that contains the binary response factor with levels 1,0 for binary classification, or a numeric vector for the prediction problem.
#' @param X a \code{matrix} that contains the features, nrow(X) = length(y).
#' @param pred_f a function that gets the input argument named y , X_train, and X_test, and output is the real numbered decision values for X_test.
#'
#' For example, the returned values can be the votes proportions for random forest, and it can also be the decision values for SVM.
#'
#' This package contains buildin predictor functions for you to use, such as: \code{\link{svm_class}} and \code{\link{randomForest_class}}
#' However, it is still recommended to create your own function with tunned parameters.
#'
#' @param k the number of folds used in cross validation, default 10.
#' @param p the number of parallels used, default equals 1, recommend to use p = k on server.
#' @param ... additional arguments passed to \code{pred_f}
#'
#' @importFrom caret createFolds
#' @import BiocParallel
#' @export
predict_cv <- function(y,
                       X,
                       pred_f = svm_class,
                       k = 10,
                       p = 1,
                       ...) {
  ##check input errors
  stopifnot(is.factor(y)|is.numeric(y))
  stopifnot(is.matrix(X)|is.data.frame(X))
  stopifnot(nrow(X) == length(y))

  if(is.factor(y)){
  stopifnot(length(levels(y)) == 2)
  stopifnot(all(levels(y) %in% c(1,0)))
  }

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
    return(pred_f(y=y[ -idx[[i]] ],
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




