# This script will output a graph of the 1d network, for complete data and another 
# simplified data which only the top 100 in (or out) edges from each node are captured.
#
# Redirect the working directory (setwd() func) to the directory where the files are
# located.
#
# Author: Yu-Tang, Shen
library(igraph)
setwd("/Users/yutang/Desktop/R")

simplifiedData = read.csv(file = "SimplifiedData.csv", header = FALSE, sep = ",")
sel = simplifiedData[1:2]
sinet = graph_from_edgelist(as.matrix(sel, directed = TRUE))
E(sinet)$weight = 1/simplifiedData[,3]
egos = c("MIS QUART", "INFORM MANAGE-AMSTER", "INFORM SYST RES", "J ASSOC INF SYST", "COMPUT HUM BEHAV")
V(sinet)$label.cex<-ifelse(V(sinet)$name %in% egos, 1, .3)
V(sinet)$label.color<-ifelse(V(sinet)$name %in% egos, "red", "blue")
V(sinet)$color<-ifelse(V(sinet)$name %in% egos, "red", "blue")
V(sinet)$size<-ifelse(V(sinet)$name %in% egos, 10, 2)
V(sinet)$label.dist<-ifelse(V(sinet)$name %in% egos, 1, 0)
plot.igraph(sinet,edge.arrow.size = .3, edge.width = .5, margin = -0.2)
#plot.igraph(sinet,vertex.size = 2, vertex.label.cex = .3 ,edge.arrow.size = .3, edge.width = .5)
