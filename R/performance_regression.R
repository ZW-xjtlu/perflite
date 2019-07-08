#' @title A function to generate the performance evaluation metrices based on cross validation results.
#' @return a \code{data.frame} that contains comprehensive performance report after cross validation.
#' @details \code{performance_regression} conduct performance evaluation on a machine learning regressor using cross validation.
#' This is a convenient function to get a neat and efficient result of performance evaluation after cross validation.
#'
#' The missing values will not be imputed by default, and the dimensions containing missing values will be dropped.
#'
#' @param y a \code{numeric} that contains the response vector for regression. This argument could be a \code{list} of numeric vectors.
#' @param X a \code{matrix} that contains the features, nrow(X) = length(y). This argument could be a \code{list} of matrixes.
#' @parampred_f a function that gets the input argument named y , X_train, and X_test, and output is the real numbered decision values for X_test.
#'
#' For example, the returned values can be the votes proportions for random forest, and it can also be the decision values for SVM.
#'
#' This package contains buildin predictor functions for you to use, such as: \code{\link{svm_regression}}, \code{\link{randomForest_regression}}, and \code{\link{lm_regression}}
#' However, it is still recommended to create your own function with tunned parameters.
#'
#' This argument could be a \code{list} of functions, Default to be list(lm_regression, svm_regression, randomForest_regression).
#'
#' @param performance_matrices a character vector indicating the performance metrices returned, default is \code{c("COR","MAE","RMSE","RAE","RRSE")},
#'
#' "COR" represents: Correlation coefficient.
#'
#' "MAE" represents: Mean absolute error.
#'
#' "RMSE" represents: Root mean squared error.
#'
#' "RAE" represents: Relative absolute error.
#'
#' "RRSE" represents: Root relative squared error.
#'
#' @param k the number of folds used in cross validation, default 10.
#' @param p the number of parallels used, default equals 1, recommend to use p = k on server.
#' @param save_table save the performance table or not, default TRUE.
#' @param ... additional arguments passed to \code{pred_f}
#'
#' @seealso \code{\link{view_tables}} to visualize the output.
#'
#' @importFrom ROCR prediction performance
#' @import ggplot2
#' @export
performance_regression <- function(y,
                                   X,
                                  pred_f = list("LR" = lm_regression,
                                                "RR_SVR" = svm_regression,
                                                "RF_R" = randomForest_regression),
                                   performance_metrices = c("COR","MAE","RMSE","RAE","RRSE"),
                                   k = 10,
                                   p = 1,
                                   save_table = T,
                                   ...
) {

  #Checking potential conditions for failure.
  stopifnot(p >= 1)
  stopifnot(k >= 1)
  stopifnot(all(performance_metrices %in% c("COR","MAE","RMSE","RAE","RRSE")))

  #Convert the non list input into the list input.
  if(is.data.frame(X)|(!is.list(X))){
    X <- list(X)
  }

  if(!is.list(y)){
    y <- list(y)
  }

  stopifnot(length(X)==length(y))

  if(!is.list(pred_f)){
   pred_f <- list(pred_f)
  }

  #Check the homogeneity of the list elements.
  lapply(X,function(x)stopifnot(is.data.frame(x)|is.matrix(x)))

  lapply(pred_f,function(x)stopifnot(is.function(x)))

  Map(function(x,y)stopifnot(nrow(x)==length(y)), X, y)

  #Rename the list if they are not properly named.
  if(is.null(names(X))){
    names(X) <- paste0("feature_",seq_along(X))
  }

  if(is.null(names(y))){
    names(y) <- paste0("response_",seq_along(X))
  }

  if(is.null(names(pred_f))){
    names(pred_f) <- paste0("method_",seq_along(pred_f))
  }

  #Start to generate performance matrices per method
  return_list <- split(seq_along(pred_f),seq_along(pred_f))
  names(return_list) <- names(pred_f)
  plot_AUC_df <- data.frame(x.FPR = NA,
                            y.TPR = NA,
                            method = NA,
                            feature = NA,
                            response = NA)

  for (i in names(pred_f)){
    ##Iterating over different methods
    print(paste0("Start to test on learning method: ", i))
    perf_table_i <- matrix(NA, nrow = length(X), ncol = length(performance_metrices))
    colnames(perf_table_i) <- performance_metrices
    rownames(perf_table_i) <- names(X)

    for (j in seq_along(X)){
      print(paste0("Using data pairs: ", names(X)[j], " and ", names(y)[j], "."))
      cv_value_j <- predict_cv(y = y[[j]],
                               X = X[[j]],
                              pred_f =pred_f[[i]],
                               k = k,
                               p = p,
                               ...)
      #Calculating data for plot ROC

      ##Calculating performance metrices c("COR","MAE","RMSE","RAE","RRSE")
      if("COR" %in% performance_metrices){
        perf_table_i[names(X)[j],"COR"]  <- round( cor(cv_value_j ,y[[j]]), 4)
      }

      if("MAE" %in% performance_metrices){
        perf_table_i[names(X)[j],"MAE"]  <- round( mean(abs(cv_value_j - y[[j]])), 4)
      }

      if("RMSE" %in% performance_metrices){
        perf_table_i[names(X)[j],"RMSE"] <- round( sqrt(mean((cv_value_j - y[[j]])^2)), 4)
      }

      if("RAE" %in% performance_metrices){
        perf_table_i[names(X)[j],"RAE"] <- round( sum(abs(cv_value_j - y[[j]]))/sum(abs(mean(y[[j]]) - y[[j]])), 4)
      }

      if("RRSE" %in% performance_metrices){
        perf_table_i[names(X)[j],"RRSE"] <- round( sum((cv_value_j - y[[j]])^2)/sum((mean(y[[j]]) - y[[j]])^2), 4)
      }


      return_list[[i]] = perf_table_i
    }
  }

  rm(cv_value_j,perf_table_i)

  if(save_table){
    Map(function(x,y) write.table(x,paste0("perf_",y,".txt"), sep = "\t"), return_list, names(pred_f))
  }

  return(return_list)
}
