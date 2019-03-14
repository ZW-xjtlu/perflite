#' @title A function to generate the performance evaluation metrices based on cross validation results.
#' @return a \code{data.frame} that contains comprehensive performance report after cross validation.
#' @details \code{performance} conduct performance evaluation on a machine learning binary classifier using cross validation.
#' This is a convenient function to get a neat and efficient result of performance evaluation after cross validation.
#'
#' The missing values will not be imputed by default, and the dimensions containing missing values will be dropped.
#'
#' @param y a \code{factor} that contains the binary response variable with levels 1,0 for binary classification. This argument could be a \code{list} of factors.
#' @param X a \code{matrix} that contains the features, nrow(X) = length(y). This argument could be a \code{list} of matrixes.
#' @param cv_f a function that gets the input argument named y , X_train, and X_test, and output is the real numbered decision values for X_test.
#'
#' For example, the returned values can be the votes proportions for random forest, and it can also be the decision values for SVM.
#'
#' This package contains buildin predictor functions for you to use, such as: \code{\link{svm_f}} and \code{\link{randomForest_f}}
#' However, it is still recommended to create your own function with tunned parameters.
#'
#' This argument could be a \code{list} of functions, Default to be list(svm_f, randomForest_f).
#'
#' @param boundary The decision boundary used when quantify performance metrices with fixed alpha, should be a numeric value.
#' Default: 0.5.
#'
#' @param performance_matrices a character vector indicating the performance metrices returned, default is \code{c("AUROC","ACC","ERR","SENS","SPEC","MCC")},
#'
#' "AUROC" represents: Area under receiver operating characteristic curve.
#'
#' "ACC" represents: Accuracy.
#'
#' "ERR" represents: Error rate.
#'
#' "SENS" represents: Sensitivity.
#'
#' "SPEC" represents: Specificity.
#'
#' "MCC" represents: Matthews correlation coefficient.
#'
#' @param k the number of folds used in cross validation, default 10.
#' @param p the number of parallels used, default equals 1, recommend to use p = k on server.
#' @param plot_AUC plot and save the ROC curve or not, default TRUE.
#' @param save_table save the performance table or not, default TRUE.
#' @param save_plot_data save the data used to plot the ROC curve, default FALSE.
#' @param ... additional arguments passed to \code{cv_f}
#'
#' @seealso \code{\link{view_tables}} to visualize the output.
#'
#' @importFrom ROCR prediction performance
#' @import ggplot2
#' @export
performance_cv <- function(y,
                       X,
                       cv_f = list("svm" = svm_f,
                                   "randomForest" = randomForest_f),
                       boundary = 0.5,
                       performance_metrices = c("AUROC","ACC","ERR","SENS","SPEC","MCC"),
                       k = 10,
                       p = 1,
                       plot_AUC = T,
                       save_table = T,
                       save_plot_data = F,
                       ...) {
  #Checking potential conditions for failure.
  stopifnot(p >= 1)
  stopifnot(k >= 1)
  stopifnot(all(performance_metrices %in% c("AUROC","ACC","ERR","SENS","SPEC","MCC")))
  stopifnot(is.numeric(boundary))

  #Convert the non list input into the list input.
  if(is.data.frame(X)|(!is.list(X))){
  X <- list(X)
  }

  if(!is.list(y)){
  y <- list(y)
  }

  stopifnot(length(X)==length(y))

  if(!is.list(cv_f)){
  cv_f <- list(cv_f)
  }

  #Check the homogeneity of the list elements.
  lapply(X,function(x)stopifnot(is.data.frame(x)|is.matrix(x)))

  lapply(y,function(x)stopifnot(is.factor(x)&(length(levels(x)) == 2)&all(levels(x) %in% c(1,0))))

  lapply(cv_f,function(x)stopifnot(is.function(x)))

  Map(function(x,y)stopifnot(nrow(x)==length(y)), X, y)

  #Rename the list if they are not properly named.
  if(is.null(names(X))){
  names(X) <- paste0("feature_",seq_along(X))
  }

  if(is.null(names(y))){
  names(y) <- paste0("response_",seq_along(X))
  }

  if(is.null(names(cv_f))){
    names(cv_f) <- paste0("method_",seq_along(cv_f))
  }

  #Start to generate performance matrices per method
  return_list <- split(seq_along(cv_f),seq_along(cv_f))
  names(return_list) <- names(cv_f)
  plot_AUC_df <- data.frame(x.FPR = NA,
                            y.TPR = NA,
                            method = NA,
                            feature = NA,
                            response = NA)

  for (i in names(cv_f)){
    ##Iterating over different methods
    print(paste0("Start to test on learning method: ", i))
    perf_table_i <- matrix(NA, nrow = length(X), ncol = length(performance_metrices))
    colnames(perf_table_i) <- performance_metrices
    rownames(perf_table_i) <- names(X)

    for (j in seq_along(X)){
      print(paste0("Using data pairs: ", names(X)[j], " and ", names(y)[j], "."))
        cv_value_j <- predict_cv(y = y[[j]],
                                 X = X[[j]],
                                 cv_f = cv_f[[i]],
                                 k = k,
                                 p = p,
                                 ...)
        #Calculating data for plot ROC
        pred <- prediction(cv_value_j, y[[j]])

        plot_df_j <- data.frame(x.FPR = performance(pred,"tpr","fpr")@x.values[[1]],
                                y.TPR = performance(pred,"tpr","fpr")@y.values[[1]],
                                method = i,
                                feature = names(X)[j],
                                response = names(y)[j])

        plot_AUC_df <- rbind(plot_AUC_df,plot_df_j)

        ##Calculating performance metrices
        if("AUROC" %in% performance_metrices){
        perf_table_i[names(X)[j],"AUROC"] <- round( performance( pred, "auc" )@y.values[[1]], 4)
        }

        ##Calculating performance metrices with selected decision boundary
        pred <- prediction(as.numeric(cv_value_j > boundary), y[[j]])

        if("ACC" %in% performance_metrices){
        perf_table_i[names(X)[j],"ACC"]  <- round( performance( pred, "acc" )@y.values[[1]][2], 4)
        }

        if("ACC" %in% performance_metrices){
        perf_table_i[names(X)[j],"ACC"]  <- round( performance( pred, "acc" )@y.values[[1]][2], 4)
        }

        if("ERR" %in% performance_metrices){
          perf_table_i[names(X)[j],"ERR"]  <- round( performance( pred, "err" )@y.values[[1]][2], 4)
        }

        if("SENS" %in% performance_metrices){
          perf_table_i[names(X)[j],"SENS"]  <- round( performance( pred, "sens" )@y.values[[1]][2], 4)
        }

        if("SPEC" %in% performance_metrices){
          perf_table_i[names(X)[j],"SPEC"]  <- round( performance( pred, "spec" )@y.values[[1]][2], 4)
        }

        if("MCC" %in% performance_metrices){
          perf_table_i[names(X)[j],"MCC"]  <- round( performance( pred, "mat" )@y.values[[1]][2], 4)
        }

        return_list[[i]] = perf_table_i
    }
  }

  plot_AUC_df <- plot_AUC_df[-1,]
  rm(plot_df_j,pred,cv_value_j,perf_table_i)

  if(save_table){
   Map(function(x,y) write.table(x,paste0("perf_",y,".txt"), sep = "\t"), return_list, names(cv_f))
  }
  if(save_plot_data){
  write.csv(plot_AUC_df,"plot_AUC.csv")
  }
  if(plot_AUC){
  p1 <- ggplot(plot_AUC_df) +
             geom_line(aes(x=x.FPR,
                           y=y.TPR,
                           colour=feature,
                           linetype = method)) +
    theme_classic() +
    scale_colour_brewer(palette = "Dark2") +
    labs(title = paste0("ROC Curve with ",k, " Folds Cross Validation"),
         x = "False Positive Rate",
         y = "True Positive Rate")

  ggsave("ROC_cv.pdf",p1,width = 6,height = 4)
  }
  return(return_list)
}
