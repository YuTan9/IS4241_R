# This script will output a graph of the 1d network, for complete data and another 
# simplified data which only the top 100 in (or out) edges from each node are captured.
#
# Redirect the working directory (setwd() func) to the directory where the files are
# located.
#
# Author: Yu-Tang, Shen
setwd("/Users/zengxi/Desktop/Year4Sem2/IS4241/Project/R_code")
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
V(g)[data[,1]]$impact = as.numeric(data[,4])

adj=get.adjacency(g,attr='weight')
write.csv(as.matrix(adj) , file = "output/adjMatrixNoloop.csv", row.names = TRUE)

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
indegUnweighted = data.frame(as.matrix(degree(g, mode="in", loops = FALSE)))

outdegUnweighted = data.frame(as.matrix(degree(g, mode="out", loops = FALSE)))

indegWeighteded = data.frame(as.matrix(strength(g, mode = "in", loops = FALSE)))

outdegWeighteded = data.frame(as.matrix(strength(g, mode = "out", loops = FALSE)))

ev = eigen(adj)
betw <- betweenness(g)
closenesses <- closeness(g)


#forming vertex attribute frame for clustering
attr = data.frame(V(g)$name, betw, Re(ev$values), indegUnweighted[,1], outdegUnweighted[,1], indegWeighteded[,1], outdegWeighteded[,1], closenesses)
names(attr)=c("Journal", "Betweenness Centrality", "Eigenvalue", "Unweighted in degree", "Unweighted out degree", "Weighted in degree", "Weighted out degree", "Closeness Centrality")
#debugger
#write.csv(data.frame(as.matrix(attr)) ,file = "output/attr.csv")


#normalize data for clustering
normed = attr[, -c(1, 1)] # extract the first column (the factor / name)
m <- apply(normed, 2, mean) # get mean, 2 means column
sd <- apply(normed, 2, sd) # standard error
normed <- scale(normed, m, sd)

distance <- dist(normed) # calculate Euclidean distance

#clustering
library("cluster")
library("factoextra")

#visualize the distance, which will be used for clustering
#visualized <- fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

#determine best number of clusters
fviz_nbclust(normed, kmeans, method = "gap_stat")


#k-means clustering (nonhierarchical)
kc5 <- kmeans(normed, 5)
kc5 # get information of clusters
# kc5$centers --> view mean 

# plot clusters with color
# plot(attribute1 ~ attribute 2, normed, col = kc5$cluster)


pam.res <- pam(attr, 3)
fviz_cluster(pam.res)
kmeans.cluster=kmeans(attr, centers=3)
