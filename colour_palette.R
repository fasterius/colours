#!/usr/bin/env Rscript

# Install missing packages (if applicable)
packages <- c("ggplot2", "reshape", "dplyr")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  message("installing missing packages ...")
  tryCatch (silent = TRUE,
            install.packages(setdiff(packages, rownames(installed.packages())),
                             repos = "http://cran.us.r-project.org"),
            warning = function(bc) {
              source("http://bioconductor.org/biocLite.R")
              biocLite(setdiff(packages, rownames(installed.packages())))
            },
            error = function(bc) {
              source("http://bioconductor.org/biocLite.R")
              biocLite(setdiff(packages, rownames(installed.packages())))
            })
}

library("ggplot2")
library("reshape")
library("dplyr")

# Read colours
data <- read.table("rgb_colours.txt", header = TRUE, sep = "\t")

# Convert to wide format
data <- melt(data, id.vars = "Colour")

# Add # to hex colours
data$value <- paste0("#", data$value)

# Factorise and order
data$Colour <- factor(data$Colour,
                      levels = c("Blue", "Teal", "Green", "Yellow", "Orange",
                                 "Red", "Pink", "Purple", "Grey"))
data$variable <- paste0(gsub("L", "", data$variable), " %")
data$variable <- factor(data$variable,
                        levels = c("20 %", "37 %", "60 %", "80 %"))

# Add id variable for correct ordering in plot
data$id <- paste0(data$Colour, data$variable)
data <- data %>% arrange(id)

# Define palette
palette <- data$value

# Plot
gg <- ggplot(data, aes(x = variable, y = Colour, fill = id)) +
    geom_tile() +
    theme(panel.background = element_blank(),
          axis.ticks = element_blank(),
          plot.title = element_text(hjust = 0.5)) +
    geom_text(aes(label = value), colour = "white") +
    scale_fill_manual(values = palette, breaks = palette) +
    labs(x     = "Lightness",
         y     = NULL,
         title = "Colour scheme based on #1954A6 from KTH")

# Save
ggsave("palette.png", gg, dpi = 300)
