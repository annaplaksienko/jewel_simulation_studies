#This file shows you construction of X list from original txt files.
#If you want to skip it, go to next R file and use ready X_real_data.Rdata

#https://gdc.cancer.gov/about-data/publications/brca_2012
#RNA Expression -> Data Matrix Files
#download BRCA.exp.547.med.txt and BRCA.547.PAM50.SigClust.Subtypes.txt
#specify your folder
path <- "/home/anna/0_jewel/jewel_simulation_studies/Breast_cancer_real_data"
setwd(path)

data <- read.delim("BRCA.exp.547.med.txt", header = FALSE)
#save first row and first column to use as rownames and colnames
samples <- data[1, -1]
genes <- data[-1, 1]
#delete them and convert data frame to numeric matrix
data <- data[-1, -1]
data <- as.matrix(data)
data <- apply(data, 2, as.numeric)
#assign rownames and colnames
rownames(data) <- genes
colnames(data) <- samples

dim(data)

#are there any absent measurements?
sum(is.na(data))
#replace them with 0
data[is.na(data)] <- 0
sum(is.na(data))

#let's reduce the number of genes in questions by selecting only some pathways
library(gage)
#download pathways
#hsa.kegg.gs <- kegg.gsets(species = "hsa", id.type = "kegg", check.new = TRUE)
#kegg.sets <- hsa.kegg.gs$kg.sets
#save not to donwload next time
#save(kegg.sets, file = "kegg_pathways_July_2022.RData")
load("kegg_pathways_July_2022.RData")
#to convert to gene symbols
data(egSymb)
#select pathways
p1 <- eg2sym(kegg.sets$`hsa05224 Breast cancer`)
p2 <- eg2sym(kegg.sets$`hsa04915 Estrogen signaling pathway`)
p3 <- eg2sym(kegg.sets$`hsa04115 p53 signaling pathway`)
p4 <- eg2sym(kegg.sets$`hsa04912 GnRH signaling pathway`)
p5 <- eg2sym(kegg.sets$`hsa04151 PI3K-Akt signaling pathway`)
p6 <- eg2sym(kegg.sets$`hsa03320 PPAR signaling pathway`)
p7 <- eg2sym(kegg.sets$`hsa04310 Wnt signaling pathway`)
p8 <- eg2sym(kegg.sets$`hsa04064 NF-kappa B signaling pathway`)
p9 <- eg2sym(kegg.sets$`hsa04330 Notch signaling pathway`)
p10 <- eg2sym(kegg.sets$`hsa04340 Hedgehog signaling pathway`) 

#drop repetitions of genes in pathways
pathways <- unique(c(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10))
length(pathways)

#delete TBL1Y because as of August 2022 it was not found in STRING database with which we compare
pathways <- pathways[pathways != "TBL1Y"]
length(pathways)

#reduce the matrix only to gene present in pathways
data_red <- data[rownames(data) %in% pathways, ]
dim(data_red)
#save gene names to have inout for STRING database
write(rownames(data_red), file = "gene_names.txt")


#load the metadata
meta <- read.delim("BRCA.547.PAM50.SigClust.Subtypes.txt")
table(meta$Type)
table(meta$PAM50)
#choose only tumor tissue
meta <- meta[meta$Type == "tumor", ]
table(meta$PAM50)

#divide the matrix by subtypes
X <- vector(mode = "list", length = 4)
names(X) <- names(table(meta$PAM50))[1:4]
X[[1]] <- t(data_red[, samples %in% meta$Sample[meta$PAM50 == "Basal"]])
X[[2]] <- t(data_red[, samples %in% meta$Sample[meta$PAM50 == "Her2"]])
X[[3]] <- t(data_red[, samples %in% meta$Sample[meta$PAM50 == "LumA"]])
X[[4]] <- t(data_red[, samples %in% meta$Sample[meta$PAM50 == "LumB"]])
sapply(X, dim)
#save the matrices
save(X, file = "X_real_data.RData")


