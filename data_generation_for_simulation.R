library(jewel)

path <- "/home/anna/0_jewel/jewel_simulation_studies/data"
setwd(path)

#initialize the variables
{
  #how many classes do you want?
  K <- 3
  #how many vertices should each graph have, i.e., 
  #how many variables in each dataset?
  p <- 100
  #how many samples?
  n <- 50
  #what should the sparsity be? Graphs will have mp - (2m - 1) edges.
  m <- 1
  #power of preferential attachment: bigger it is, more prominent are hubs
  power <- 1
  #number of iterations of rewire algorithm will be p * perc. 
  #So bigger perc – bigger difference between graphs
  perc <- 0.08
  
  filename <- paste("G_X", p, m, power, perc, ".Rdata", sep = "_")
  
  nruns <- 5
}

#generate data 
{
  CommonG_list <- vector(mode = "list", length = nruns)
  G_list <- vector(mode = "list", length = nruns)
  X_list <- vector(mode = "list", length = nruns)
  for (i in 1:nruns){ 
    #you can add makePlot = FALSE, verbose = FALSE if you have many runs
    simData <- generateData_rewire(K, n, p, perc = perc,
                                   m = m, power = power)
    CommonG_list[[i]] <- simData$CommonGraph
    G_list[[i]] <- simData$Graphs
    X_list[[i]] <- simData$Data
  }
  remove(simData)
  
  names(CommonG_list) <- names(G_list) <- names(X_list) <-
    sapply(1:nruns, function(i) sprintf("Run_%i", i))
  
  #compute size of graphs and average difference over nruns
  size <- m * p - 2 * m + 1
  common_size <- round(mean(sapply(CommonG_list, function(x) sum(x) / 2)))
  diff <- 100 - round(common_size / size * 100)
  
  comment(G_list) <- paste("Size of each graph is", size, "edges.")
  print(comment(G_list))
  comment(CommonG_list) <- paste("Average size of the common part is ", common_size, 
                                 " edges. Average difference is ", diff, "%.", sep = "")
  print(comment(CommonG_list))
  
  print("Min and maximum degree in each realisation:")
  sapply(G_list, function(x) min(rowSums(x[[1]])))
  sapply(G_list, function(x) max(rowSums(x[[1]])))

  save(list = c("CommonG_list", "G_list", "X_list"), file = filename)
}




