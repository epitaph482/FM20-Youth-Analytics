# =========================================================================
# Project: FM20 Youth Development Analytics
# Script: Data Cleaning and Development Efficiency Visualization
# =========================================================================

library(ggplot2)
library(dplyr)
library(readr)

setwd("C:/Temp")

raw_data <- read.csv("development_efficiency_matrix.csv")

# -------------------------------------------------------------------------
# ADIM 1: Nokta At?????? Karakter D??zeltme (Standart ??ngiliz Alfabesi)
# -------------------------------------------------------------------------
clean_data <- raw_data %>%
  mutate(club = case_when(
    grepl("Espa", club) ~ "Villa Espanola",       # ?? yerine n
    grepl("Magdalena", club) ~ "Union Magdalena", # ?? yerine o
    grepl("Sarmiento", club) ~ "Sarmiento (Junin)",# ?? yerine i
    TRUE ~ club
  )) %>%
  filter(!is.na(avg_current_ability) & !is.na(avg_potential_ability))

# -------------------------------------------------------------------------
# ADIM 2: G??rselle??tirme (Efficiency Matrix)
# -------------------------------------------------------------------------
development_matrix_plot <- ggplot(clean_data, aes(x = avg_potential_ability, y = avg_current_ability, color = club)) +
  geom_point(alpha = 0.7, size = 3) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "darkgray") +
  labs(
    title = "Youth Development Efficiency Matrix",
    subtitle = "Relationship between Average Potential Ability (PA) and Current Ability (CA)",
    x = "Average Potential Ability (PA) - The Ceiling",
    y = "Average Current Ability (CA) - Reached Potential",
    color = "Academy"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right"
  )

# -------------------------------------------------------------------------
# ADIM 3: Grafi??i Kaydetme
# -------------------------------------------------------------------------
ggsave("youth_development_matrix.png", plot = development_matrix_plot, width = 10, height = 6, dpi = 300)
