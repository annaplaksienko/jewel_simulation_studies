#are there isolated vertices?
union <- do.call(union, G_list_graph)
gsize(union)
vcount(union)
isolated <- which(degree(union) == 0)
union_no_iso <- delete.vertices(union, isolated)
gsize(union_no_iso)
vcount(union_no_iso)

G_list_plot <- lapply(G_list_graph, function(x) delete.vertices(x, isolated))
G_ws_plot <- delete.vertices(G_ws, isolated)

E(G_ws_plot)$color <- "dimgrey"

G_specific <- lapply(G_list_plot, function(x) difference(x, G_ws_plot))
colours_k <- c("red2", "chartreuse4", "darkturquoise", "deeppink3")
K <- length(colours_k)
for (k in 1:K) {
  E(G_specific[[k]])$color <- colours_k[k]
}

G_list_plot2 <- lapply(G_specific, function(x) union(x, G_ws_plot))
for (k in 1:K) {
  edge_colors <- edge_attr(G_list_plot2[[k]], "color_1")
  specific <- which(is.na(edge_attr(G_list_plot2[[k]], "color_1")))
  edge_colors[specific] <- edge_attr(G_list_plot2[[k]], "color_2")[specific]
  G_list_plot2[[k]] <- set_edge_attr(G_list_plot2[[k]], "color", 
                                     value = edge_colors)
}


vsize <- 0
vcol <- "white"
vfrcol <- "grey"
vlabcex <- 0.7
vlabcol <- "darkslateblue"
vlabfont <- 2
layout <- layout_nicely(G_list_plot[[1]])

par(mar = c(1, 1, 1, 1) + .1)
par(mfrow = c(2, 2))
plot.igraph(G_list_plot2[[3]], layout = layout,
            vertex.size = vsize, vertex.color = vcol, 
            vertex.frame.color = vfrcol, vertex.label.cex = vlabcex, 
            vertex.label.color = vlabcol, vertex.label.font = vlabfont,
            main = "Luminal A")
plot.igraph(G_list_plot2[[4]], layout = layout,
            vertex.size = vsize, vertex.color = vcol, 
            vertex.frame.color = vfrcol, vertex.label.cex = vlabcex, 
            vertex.label.color = vlabcol, vertex.label.font = vlabfont,
            main = "Luminal B")
plot.igraph(G_list_plot2[[1]], layout = layout,
            vertex.size = vsize, vertex.color = vcol, 
            vertex.frame.color = vfrcol, vertex.label.cex = vlabcex, 
            vertex.label.color = vlabcol, vertex.label.font = vlabfont,
            main = "Basal-like")
plot.igraph(G_list_plot2[[2]], layout = layout,
            vertex.size = vsize, vertex.color = vcol, 
            vertex.frame.color = vfrcol, vertex.label.cex = vlabcex, 
            vertex.label.color = vlabcol, vertex.label.font = vlabfont,
            main = "HER2-enriched")

