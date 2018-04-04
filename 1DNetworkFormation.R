# This script will output a graph of the 1d network, for complete data and another 
# simplified data which only the top 100 in (or out) edges from each node are captured.
#
# Redirect the working directory (setwd() func) to the directory where the files are
# located.
#
# Author: Yu-Tang, Shen
library(igraph)
setwd("/Users/yutang/Desktop/R")

data = read.csv(file = "CompleteData.csv", header = FALSE, sep = ",")
el = data[1:2]
inet = graph_from_edgelist(as.matrix(el, directed = TRUE))
E(inet)$weight = 1/data[,3]
plot.igraph(inet,vertex.size = 2, vertex.label.cex = .3 ,edge.arrow.size = .3, edge.width = .5)

simplifiedData = read.csv(file = "SimplifiedData.csv", header = FALSE, sep = ",")
sel = simplifiedData[1:2]
sinet = graph_from_edgelist(as.matrix(sel, directed = TRUE))
E(sinet)$weight = 1/simplifiedData[,3]
plot.igraph(sinet,vertex.size = 2, vertex.label.cex = .3 ,edge.arrow.size = .3, edge.width = .5)
