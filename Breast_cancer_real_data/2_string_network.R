library(igraph)
library(jewel)

path <- "/home/anna/0_jewel/jewel_simulation_studies/Breast_cancer_real_data"
setwd(path)

#read string network
string <- read.table(file = "string_network.tsv", sep = '\t', header = FALSE)

#read string mapping of gene names
string_mapping <- read.table(file = "string_mapping.tsv", 
                             quote = "", sep = '\t')[, c(2, 4)]
#which rows don't match?
diff_names <- string_mapping[, 1] != string_mapping[, 2]
#extract those genes whose names were changed by STRING
diff_names <- string_mapping[diff_names, ]
#how many genes like that there are?
dim(diff_names)[1]
#in the network, change names from string to out version to match with the data
for (i in 1:dim(diff_names)[1]) {
  original_name <- diff_names[i, 1]
  string_name <- diff_names[i, 2]
  string$V1 <- gsub(string_name, original_name, string$V1)
  string$V2 <- gsub(string_name, original_name, string$V2)
}

#make a graph object
G_string <- graph_from_edgelist(as.matrix(string[, 1:2]), directed = FALSE)

#how many vertices are in the network?
vcount(G_string)
#how many edges?
gsize(G_string)
#calculate the "true" degrees
degrees <- degree(G_string)

#find how many vertices with the highest degree to choose (in this example, 3%)
top <- ceiling(900 * 0.03)
top
#find the vertices with the highest degree
top_vertices <- sort(degrees, decreasing = TRUE)[1:top]
top_vertices
names(top_vertices)

#give all vertices degree 1 ("not hub") and those vertices degree 10 ("hub")
approx_degree <- rep(1, p)
names(approx_degree) <- names(degrees)
approx_degree[names(top_vertices)] <- 10

#some genes are isolated according to STRING database. 
#Identify them and give them degree 1 too
load("X_real_data.RData")
all_genes <- colnames(X[[1]])
isolated_acc_string <- all_genes %in% names(degrees)
isolated_acc_string <- all_genes[!isolated_acc_string]
approx_degree2 <- rep(1, length(isolated_acc_string))
names(approx_degree2) <- isolated_acc_string

#combine all the vertices
approx_degree <- c(approx_degree, approx_degree2)

#construct the weights
W_list <- constructWeights(approx_degree, K = 4)

save(list = c("G_string", "W_list", "top_vertices"), 
     file = "string_network_3%_hub10.Rdata")
