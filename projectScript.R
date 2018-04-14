# This script will output a graph of the 1d network, for complete data and another 
# simplified data which only the top 100 in (or out) edges from each node are captured.
#
# Redirect the working directory (setwd() func) to the directory where the files are
# located.
#
# Author: Yu-Tang, Shen
setwd("/Users/yutang/Desktop/IS4241_R")
library(igraph)

data = read.csv(file = "input/onePointFiveDEdgelist.csv", header = FALSE, sep = ",")
data[,1] = as.character(data[,1])
data[,2] = as.character(data[,2])
data = as.matrix(data)
g = graph.edgelist(data[,1:2], directed = TRUE)
E(g)$weight = as.numeric(data[,3])

# get adjacency matrix
adj=get.adjacency(g,attr='weight')
write.csv(as.matrix(adj) , file = "output/adjMatrix.csv", row.names = TRUE)



# print out formatted graph
el = data[1:2]
egos = c("MIS QUART", "INFORM MANAGE-AMSTER", "INFORM SYST RES", "J ASSOC INF SYST", "COMPUT HUM BEHAV", "ORGAN DYN", "EUR REV")
V(g)$label<-ifelse(V(g)$name %in% egos, V(g)$name, " ")
V(g)$label.cex<-ifelse(V(g)$name %in% egos, 1, .3)
V(g)$label.color<-ifelse(V(g)$name %in% egos, "red", "blue")
V(g)$color<-ifelse(V(g)$name %in% egos, "red", "blue")
V(g)$size<-ifelse(V(g)$name %in% egos, 10, 2)
V(g)$label.dist<-ifelse(V(g)$name %in% egos, 1, 0)
E(g)$label <- E(g)$weight
plot.igraph(g,edge.arrow.size = .3, edge.width = .5, margin = -0.1)
plot.igraph(g,edge.arrow.size = .3, edge.width = .5)
#plot.igraph(g,vertex.size = 2, vertex.label.cex = .3 ,edge.arrow.size = .3, edge.width = .5)


#get weighted in degree centrality regardless of loops
write.csv(as.matrix(strength(g, mode = "out", loops = TRUE)) ,file = "output/outdeg.csv")

#get weighted out degree centrality regardless of loops
write.csv(as.matrix(strength(g, mode = "in", loops = TRUE)) ,file = "output/indeg.csv")
