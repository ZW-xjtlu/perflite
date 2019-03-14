library(perflite)
indx <- sample(4520,500)
MM_squence <- read.csv("~/MM_squence.csv")[indx,-1]
MM_genomic <- read.csv("~/MM_genomic.csv")[indx,-1]
MM_combinded <- read.csv("~/MM_combined.csv")[indx,-1]

Response_sequence <- factor( as.numeric( MM_squence$Y ) )
Response_genomic <- factor( as.numeric( MM_genomic$Y ) )
Response_combinded <- factor( as.numeric( MM_combinded$Y ) )

Feature_sequence <- MM_squence[,colnames(MM_squence)!="Y"]
Feature_genomic <- MM_genomic[,colnames(MM_genomic)!="Y"]
Feature_combinded <- MM_combinded[,colnames(MM_combinded)!="Y"]

Feature_combinded <- Feature_combinded[,apply(Feature_combinded,2,var) != 0]
Feature_genomic <- Feature_genomic[,apply(Feature_genomic,2,var) != 0]
Feature_sequence <- Feature_sequence[,apply(Feature_sequence,2,var) != 0]

performance_cv(y = list(sequence = Response_sequence,
                        genomic = Response_genomic,
                        combined = Response_combinded),
               X = list(sequence = Feature_sequence,
                        genomic = Feature_genomic,
                        combined = Feature_combinded),
               cv_f = list(svm = svm_f),
               boundaries = c(0)
               )
