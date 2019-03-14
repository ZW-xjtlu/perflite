Performance Evaluation All at Once
================

You are welcome to use my new package perflite
----------------------------------------------

It is a one step, easy to use package to evaluate any performances of machine learning algorithm.

Notice that the first version of this package is develped using **6 hours of one day**. And it could already realize the one step automatic performance evaluation on multiple datasets and multiple machine learning methods (with cross validation + parallel computation).

Install this package on your PC or server
-----------------------------------------

You can download this package right now from github:

``` r
devtools::install_github("ZhenWei10/perflite")
```

Run a performance evaluation with the example files in package
--------------------------------------------------------------

Below is an one step function to evaluate the performance of machine learning algorithm on multiple datasets.

``` r
library(perflite)
perf_results <- performance_cv(
                         y = list(
                         target_1 = Response_sequence,
                         target_2 = Response_genomic,
                         target_3 = Response_combinded
                        ), #list of response vectors
                    X = list(
                         sequence_feature = Feature_sequence,
                         genomic_feature = Feature_genomic,
                         combined_feature = Feature_combinded
                        ), #list of feature matrixes
                    k = 10, #number of folds in cross validation
                    p = 1, #number of parallel computation
                    cv_f = c(svm = svm_f,
           randomForest = randomForest_f)  #list of classifier functions.
  )
```

    ## [1] "Start to test on learning method: svm"
    ## [1] "Using data pairs: sequence_feature and target_1."
    ## [1] "Fold 1 training..."
    ## [1] "Fold 2 training..."
    ## [1] "Fold 3 training..."
    ## [1] "Fold 4 training..."
    ## [1] "Fold 5 training..."
    ## [1] "Fold 6 training..."
    ## [1] "Fold 7 training..."
    ## [1] "Fold 8 training..."
    ## [1] "Fold 9 training..."
    ## [1] "Fold 10 training..."
    ## [1] "Using data pairs: genomic_feature and target_2."
    ## [1] "Fold 1 training..."
    ## [1] "Fold 2 training..."
    ## [1] "Fold 3 training..."
    ## [1] "Fold 4 training..."
    ## [1] "Fold 5 training..."
    ## [1] "Fold 6 training..."
    ## [1] "Fold 7 training..."
    ## [1] "Fold 8 training..."
    ## [1] "Fold 9 training..."
    ## [1] "Fold 10 training..."
    ## [1] "Using data pairs: combined_feature and target_3."
    ## [1] "Fold 1 training..."
    ## [1] "Fold 2 training..."
    ## [1] "Fold 3 training..."
    ## [1] "Fold 4 training..."
    ## [1] "Fold 5 training..."
    ## [1] "Fold 6 training..."
    ## [1] "Fold 7 training..."
    ## [1] "Fold 8 training..."
    ## [1] "Fold 9 training..."
    ## [1] "Fold 10 training..."
    ## [1] "Start to test on learning method: randomForest"
    ## [1] "Using data pairs: sequence_feature and target_1."
    ## [1] "Fold 1 training..."
    ## [1] "Fold 2 training..."
    ## [1] "Fold 3 training..."
    ## [1] "Fold 4 training..."
    ## [1] "Fold 5 training..."
    ## [1] "Fold 6 training..."
    ## [1] "Fold 7 training..."
    ## [1] "Fold 8 training..."
    ## [1] "Fold 9 training..."
    ## [1] "Fold 10 training..."
    ## [1] "Using data pairs: genomic_feature and target_2."
    ## [1] "Fold 1 training..."
    ## [1] "Fold 2 training..."
    ## [1] "Fold 3 training..."
    ## [1] "Fold 4 training..."
    ## [1] "Fold 5 training..."
    ## [1] "Fold 6 training..."
    ## [1] "Fold 7 training..."
    ## [1] "Fold 8 training..."
    ## [1] "Fold 9 training..."
    ## [1] "Fold 10 training..."
    ## [1] "Using data pairs: combined_feature and target_3."
    ## [1] "Fold 1 training..."
    ## [1] "Fold 2 training..."
    ## [1] "Fold 3 training..."
    ## [1] "Fold 4 training..."
    ## [1] "Fold 5 training..."
    ## [1] "Fold 6 training..."
    ## [1] "Fold 7 training..."
    ## [1] "Fold 8 training..."
    ## [1] "Fold 9 training..."
    ## [1] "Fold 10 training..."

After running this function, the tables generated will be automatically saved under the current working directory.

Check the performance tables.
-----------------------------

``` r
library(knitr)
kable(perf_results[[1]],
       format = "html", 
       caption = names(perf_results)[1]) 
```

<table>
<caption>
svm
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
AUROC
</th>
<th style="text-align:right;">
ACC
</th>
<th style="text-align:right;">
ERR
</th>
<th style="text-align:right;">
SENS
</th>
<th style="text-align:right;">
SPEC
</th>
<th style="text-align:right;">
MCC
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sequence\_feature
</td>
<td style="text-align:right;">
0.6555
</td>
<td style="text-align:right;">
0.630
</td>
<td style="text-align:right;">
0.370
</td>
<td style="text-align:right;">
0.5959
</td>
<td style="text-align:right;">
0.6627
</td>
<td style="text-align:right;">
0.2593
</td>
</tr>
<tr>
<td style="text-align:left;">
genomic\_feature
</td>
<td style="text-align:right;">
0.6660
</td>
<td style="text-align:right;">
0.604
</td>
<td style="text-align:right;">
0.396
</td>
<td style="text-align:right;">
0.5714
</td>
<td style="text-align:right;">
0.6353
</td>
<td style="text-align:right;">
0.2072
</td>
</tr>
<tr>
<td style="text-align:left;">
combined\_feature
</td>
<td style="text-align:right;">
0.7363
</td>
<td style="text-align:right;">
0.678
</td>
<td style="text-align:right;">
0.322
</td>
<td style="text-align:right;">
0.6490
</td>
<td style="text-align:right;">
0.7059
</td>
<td style="text-align:right;">
0.3555
</td>
</tr>
</tbody>
</table>
``` r
kable(perf_results[[2]],
       format = "html", 
       caption = names(perf_results)[2]) 
```

<table>
<caption>
randomForest
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
AUROC
</th>
<th style="text-align:right;">
ACC
</th>
<th style="text-align:right;">
ERR
</th>
<th style="text-align:right;">
SENS
</th>
<th style="text-align:right;">
SPEC
</th>
<th style="text-align:right;">
MCC
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sequence\_feature
</td>
<td style="text-align:right;">
0.6734
</td>
<td style="text-align:right;">
0.640
</td>
<td style="text-align:right;">
0.360
</td>
<td style="text-align:right;">
0.5837
</td>
<td style="text-align:right;">
0.6941
</td>
<td style="text-align:right;">
0.2796
</td>
</tr>
<tr>
<td style="text-align:left;">
genomic\_feature
</td>
<td style="text-align:right;">
0.6787
</td>
<td style="text-align:right;">
0.634
</td>
<td style="text-align:right;">
0.366
</td>
<td style="text-align:right;">
0.6163
</td>
<td style="text-align:right;">
0.6510
</td>
<td style="text-align:right;">
0.2675
</td>
</tr>
<tr>
<td style="text-align:left;">
combined\_feature
</td>
<td style="text-align:right;">
0.7379
</td>
<td style="text-align:right;">
0.686
</td>
<td style="text-align:right;">
0.314
</td>
<td style="text-align:right;">
0.6327
</td>
<td style="text-align:right;">
0.7373
</td>
<td style="text-align:right;">
0.3722
</td>
</tr>
</tbody>
</table>
A plot of ROC curve is automatically saved under the current directory.
-----------------------------------------------------------------------

<img src="README_files/figure-markdown_github/ROC_cv.pdf" alt="The whole analysis requires only one function." width="100%" />
<p class="caption">
The whole analysis requires only one function.
</p>

``` r
sessionInfo()
```

    ## R version 3.4.2 (2017-09-28)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Sierra 10.12.6
    ## 
    ## Matrix products: default
    ## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] zh_CN.UTF-8/zh_CN.UTF-8/zh_CN.UTF-8/C/zh_CN.UTF-8/zh_CN.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] knitr_1.20     perflite_1.0.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.17        lubridate_1.7.4     lattice_0.20-35    
    ##  [4] class_7.3-14        gtools_3.5.0        assertthat_0.2.0   
    ##  [7] rprojroot_1.3-2     digest_0.6.15       ipred_0.9-8        
    ## [10] foreach_1.4.4       R6_2.2.2            plyr_1.8.4         
    ## [13] backports_1.1.2     stats4_3.4.2        e1071_1.7-0.1      
    ## [16] evaluate_0.10.1     highr_0.6           ggplot2_3.1.0      
    ## [19] pillar_1.2.3        gplots_3.0.1        rlang_0.3.1        
    ## [22] lazyeval_0.2.1      caret_6.0-81        data.table_1.10.4-3
    ## [25] gdata_2.18.0        rpart_4.1-13        Matrix_1.2-14      
    ## [28] rmarkdown_1.9       labeling_0.3        splines_3.4.2      
    ## [31] BiocParallel_1.12.0 gower_0.2.0         stringr_1.3.0      
    ## [34] munsell_0.4.3       compiler_3.4.2      pkgconfig_2.0.1    
    ## [37] htmltools_0.3.6     nnet_7.3-12         tidyselect_0.2.4   
    ## [40] tibble_1.4.2        prodlim_2018.04.18  codetools_0.2-15   
    ## [43] randomForest_4.6-14 dplyr_0.7.5         withr_2.1.2        
    ## [46] MASS_7.3-50         bitops_1.0-6        recipes_0.1.4      
    ## [49] ModelMetrics_1.2.2  grid_3.4.2          nlme_3.1-137       
    ## [52] gtable_0.2.0        magrittr_1.5        scales_0.5.0       
    ## [55] KernSmooth_2.23-15  stringi_1.2.2       ROCR_1.0-7         
    ## [58] reshape2_1.4.3      bindrcpp_0.2.2      timeDate_3043.102  
    ## [61] generics_0.0.2      lava_1.6.5          RColorBrewer_1.1-2 
    ## [64] iterators_1.0.9     tools_3.4.2         glue_1.2.0         
    ## [67] purrr_0.2.5         survival_2.42-3     yaml_2.1.19        
    ## [70] colorspace_1.3-2    caTools_1.17.1      bindr_0.1.1
