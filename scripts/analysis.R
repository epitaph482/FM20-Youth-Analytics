# =========================================================================
# Project: FM20 Youth Development Analytics
# Script: Data Cleaning and Efficiency Visualization
# =========================================================================

library(ggplot2)
library(dplyr)
library(readr)

# Function to fix encoding issues across all character columns globally
fix_encoding <- function(df) {
  df %>% mutate_if(is.character, ~iconv(., from = "UTF-8", to = "ASCII//TRANSLIT"))
}

# 1. Load Data
# Using relative paths for portability
raw_data <- read.csv("data/development_efficiency_matrix.csv", stringsAsFactors = FALSE)
positional_data <- read.csv("data/positional_talent_analysis.csv", stringsAsFactors = FALSE)

# 2. Global Data Cleaning
# Fix encoding and filter out incomplete entries
clean_data <- fix_encoding(raw_data) %>%
  filter(!is.na(avg_current_ability) & !is.na(avg_potential_ability))

clean_positional <- fix_encoding(positional_data)

# 3. Visualization: Efficiency Matrix
development_matrix_plot <- ggplot(clean_data, aes(
  x = avg_current_ability, 
  y = avg_potential_ability, 
  color = development_efficiency_percentage, 
  size = young_player_count
)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "darkgray", show.legend = FALSE) +
  scale_color_viridis_c(option = "plasma", name = "Efficiency %") +
  labs(
    title = "Youth Development Efficiency Matrix",
    subtitle = "Relationship between Current Ability (CA) and Potential Ability (PA)",
    x = "Average Current Ability (CA) - Reached Potential",
    y = "Average Potential Ability (PA) - The Ceiling",
    size = "Player Count"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right"
  )

# 4. Save Output
ggsave("images/youth_development_matrix.png", plot = development_matrix_plot, width = 10, height = 6, dpi = 300)

# Overwrite clean data for repo
write.csv(clean_data, "data/development_efficiency_matrix_clean.csv", row.names = FALSE)
