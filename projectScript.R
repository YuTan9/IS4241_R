# This script will output a graph of the 1d network, for complete data and another 
# simplified data which only the top 100 in (or out) edges from each node are captured.
#
# Redirect the working directory (setwd() func) to the directory where the files are
# located.
#
# Author: Yu-Tang, Shen
setwd("/Users/yutang/Desktop/IS4241_R")
library(igraph)

#read data, forming graph
data = data.frame(read.csv(file = "input/onePointFiveDEdgelist_v2.csv", header = TRUE, sep = ","))
attach(data)
data[,1] = as.character(data[,1])
data[,2] = as.character(data[,2])
data = as.matrix(data)
g = graph.edgelist(data[,1:2], directed = TRUE)
E(g)$weight = as.numeric(data[,3])
V(g)[data[,2]]$impact = as.numeric(data[,4])
#some attribute can not be appended.
#set.vertex.attribute(g, "impact", as.numeric(data[,4]))

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

#get weighted in degree centrality regarding loops
write.csv(data.frame(as.matrix(strength(g, mode = "in", loops = TRUE))) ,file = "output/indeg.csv")

#get weighted out degree centrality regarding loops
write.csv(data.frame(as.matrix(strength(g, mode = "out", loops = TRUE))) ,file = "output/outdeg.csv")

#get unweighted in degree centality regardless of loops
indeg = data.frame(as.matrix(degree(g, mode="in", loops = FALSE)))

#get unweighted out degree centality regardless of loops
outdeg = data.frame(as.matrix(degree(g, mode="out", loops = FALSE)))

#forming vertex attribute frame for clustering
attr = data.frame(V(g)$name, indeg[,1], outdeg[,1], V(g)$impact)
names(attr)=c("Vertex", "Unweight in degree", "Unweight out degree", "Impact Factor")
#debugger
#write.csv(data.frame(as.matrix(attr)) ,file = "/Users/yutang/Desktop/attr.csv")
#

#clustering
library("cluster")
library("factoextra")
pam.res <- pam(attr, 3)
fviz_cluster(pam.res)
kmeans.cluster=kmeans(attr, centers=3)
