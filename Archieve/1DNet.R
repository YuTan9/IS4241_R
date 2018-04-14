# This script will output a graph of the 1d network, for complete data and another 
# simplified data which only the top 100 in (or out) edges from each node are captured.
#
# Redirect the working directory (setwd() func) to the directory where the files are
# located.
#
# Author: Yu-Tang, Shen
library(igraph)
setwd("/Users/yutang/Desktop/IS4241_R")

data = read.csv(file = "1p5.csv", header = FALSE, sep = ",")
el = data[1:2]
inet = graph_from_edgelist(as.matrix(el, directed = TRUE))
E(inet)$weight = 1/data[,3]
egos = c("MIS QUART", "INFORM MANAGE-AMSTER", "INFORM SYST RES", "J ASSOC INF SYST", "COMPUT HUM BEHAV")
V(inet)$label.cex<-ifelse(V(inet)$name %in% egos, 1, .3)
V(inet)$label.color<-ifelse(V(inet)$name %in% egos, "red", "blue")
V(inet)$color<-ifelse(V(inet)$name %in% egos, "red", "blue")
V(inet)$size<-ifelse(V(inet)$name %in% egos, 10, 2)
V(inet)$label.dist<-ifelse(V(inet)$name %in% egos, 1, 0)
E(inet)$label <- E(inet)$weight
plot.igraph(inet,edge.arrow.size = .3, edge.width = .5, margin = -0.1)
#plot.igraph(inet,vertex.size = 2, vertex.label.cex = .3 ,edge.arrow.size = .3, edge.width = .5)
