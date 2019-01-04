#!/usr/bin/env Rscript

library("ggplot2")
library("reshape")
library("dplyr")

# Read colours
data <- read.table("~/local/scripts/misc/colour_palette.txt",
                  header = TRUE,
                  sep    = "\t")

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
         title = "Colour scheme based on #1954a6 from KTH")

# Save
ggsave("~/local/scripts/colour_palette.png", gg, dpi = 300)
