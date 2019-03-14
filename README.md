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

``` r
library(perflite)
perf_results <- performance_cv(example_y,example_X)
```

    ## [1] "Start to test on learning method: svm"
    ## [1] "Using data pairs: feature_1 and response_1."
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
    ## [1] "Using data pairs: feature_1 and response_1."
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
auroc
</th>
<th style="text-align:right;">
acc
</th>
<th style="text-align:right;">
err
</th>
<th style="text-align:right;">
sens
</th>
<th style="text-align:right;">
spec
</th>
<th style="text-align:right;">
mcc
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
feature\_1
</td>
<td style="text-align:right;">
0.7388
</td>
<td style="text-align:right;">
0.6633
</td>
<td style="text-align:right;">
0.3367
</td>
<td style="text-align:right;">
0.5918
</td>
<td style="text-align:right;">
0.732
</td>
<td style="text-align:right;">
0.3273
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
auroc
</th>
<th style="text-align:right;">
acc
</th>
<th style="text-align:right;">
err
</th>
<th style="text-align:right;">
sens
</th>
<th style="text-align:right;">
spec
</th>
<th style="text-align:right;">
mcc
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
feature\_1
</td>
<td style="text-align:right;">
0.7249
</td>
<td style="text-align:right;">
0.68
</td>
<td style="text-align:right;">
0.32
</td>
<td style="text-align:right;">
0.6667
</td>
<td style="text-align:right;">
0.6928
</td>
<td style="text-align:right;">
0.3596
</td>
</tr>
</tbody>
</table>
A plot of ROC curve is automatically saved under the current directory.
-----------------------------------------------------------------------

<img src="/Users/zhenwei/Documents/GitHub/perflite/ROC_cv.pdf" alt="The whole analysis requires only one function." width="100%" />
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
    ## [1] knitr_1.20
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_3.4.2  backports_1.1.2 magrittr_1.5    rprojroot_1.3-2
    ##  [5] tools_3.4.2     htmltools_0.3.6 yaml_2.1.19     Rcpp_0.12.17   
    ##  [9] stringi_1.2.2   rmarkdown_1.9   highr_0.6       stringr_1.3.0  
    ## [13] digest_0.6.15   evaluate_0.10.1
