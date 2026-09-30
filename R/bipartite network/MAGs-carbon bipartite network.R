# Load required packages
library(tidyverse)
library(igraph)
library(ggraph)
library(reshape2)
library(vegan) 
# ==================== 1. Data reading and preprocessing ====================

# Read data (adjust the actual path as needed)
carbon_data <- read.table("carbon.txt", header = TRUE, row.names = 1, check.names = FALSE)
mags_data <- read.table("mags.txt", header = TRUE, row.names = 1, check.names = FALSE)

# Check whether sample names are consistent
intersect_ids <- intersect(rownames(carbon_data), rownames(mags_data))
cat("Number of matched samples:", length(intersect_ids), "\n")

# Extract data for matched samples
carbon_matched <- carbon_data[intersect_ids, , drop = FALSE]
mags_matched <- mags_data[intersect_ids, , drop = FALSE]

# Filter out MAGs and carbon sources with zero abundance across all samples
mags_filtered <- mags_matched[, colSums(mags_matched) > 0, drop = FALSE]
carbon_filtered <- carbon_matched[, colSums(carbon_matched) > 0, drop = FALSE]

# ==================== 2. Calculate microbe-carbon associations ====================

# Method: calculate Spearman correlation coefficients (or other metrics such as co-occurrence frequency)
# Calculate correlations for each MAG and each carbon source

mags_names <- colnames(mags_filtered)
carbons_names <- colnames(carbon_filtered)

# Store association results
associations <- data.frame(
  MAG = character(),
  Carbon = character(),
  Correlation = numeric(),
  P_value = numeric(),
  stringsAsFactors = FALSE
)

# Calculate correlations (Spearman used here as an example)
for (mag in mags_names) {
  for (carbon in carbons_names) {
    # Skip columns with zero variance
    if (sd(mags_filtered[[mag]], na.rm = TRUE) == 0 || 
        sd(carbon_filtered[[carbon]], na.rm = TRUE) == 0) {
      next
    }
    
    test <- cor.test(mags_filtered[[mag]], 
                     carbon_filtered[[carbon]], 
                     method = "spearman",
                     use = "pairwise.complete.obs")
    
    associations <- rbind(associations, data.frame(
      MAG = mag,
      Carbon = carbon,
      Correlation = test$estimate,
      P_value = test$p.value,
      stringsAsFactors = FALSE
    ))
  }
}

# ==================== 3. Filter significant associations ====================

# Set thresholds: significant correlation (p < 0.05) and absolute correlation coefficient > 0.6
sig_associations <- associations %>%
  filter(P_value < 0.05, abs(Correlation) > 0.6)

# Distinguish positive and negative correlations
sig_associations$Type <- ifelse(sig_associations$Correlation > 0, "Positive", "Negative")

# Check the number of significant associations
cat("Number of significant associations:", nrow(sig_associations), "\n")

# ==================== 4. Build bipartite network ====================

# Create graph object
graph <- graph_from_data_frame(
  d = sig_associations[, c("MAG", "Carbon")],
  directed = FALSE
)

# Add node attributes: type (MAG or carbon source)
V(graph)$type <- ifelse(V(graph)$name %in% mags_names, "MAG", "Carbon")
V(graph)$color <- ifelse(V(graph)$type == "MAG", "#1f78b4", "#33a02c")
V(graph)$shape <- ifelse(V(graph)$type == "MAG", "circle", "square")

# Add edge attributes: positive/negative correlation
E(graph)$correlation <- sig_associations$Correlation
E(graph)$color <- ifelse(sig_associations$Type == "Positive", "red", "blue")

# ==================== 5. Visualization ====================

library(ggraph)

# Calculate node degree (number of connected edges)
V(graph)$degree <- degree(graph)

p1 <- ggraph(graph, layout = "fr") +
  # Draw edges
  geom_edge_link(
    aes(width = abs(correlation), color = correlation),
    alpha = 0.7
  ) +
  scale_edge_color_gradient2(
    low = "blue", mid = "white", high = "red",
    midpoint = 0,
    name = "Correlation"
  ) +
  # Draw MAG nodes (circles)
  geom_node_point(
    data = function(x) subset(x, type == "MAG"),
    aes(size = degree),
    color = "#1f78b4",
    shape = 16
  ) +
  # Draw carbon source nodes (squares)
  geom_node_point(
    data = function(x) subset(x, type == "Carbon"),
    aes(size = degree),
    color = "#33a02c",
    shape = 15
  ) +
  # Node labels
  geom_node_text(
    aes(label = name, filter = degree > 2),
    repel = TRUE,
    size = 3,
    max.overlaps = 20
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )

print(p1)

# Save association results as a CSV file
write.csv(sig_associations, "significant_associations.csv", row.names = FALSE)