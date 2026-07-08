# =========================================================================
# Project: FM20 Youth Development Analytics
# Script: Data Cleaning and Efficiency Visualization
# =========================================================================

library(ggplot2)
library(dplyr)
library(readr)

# 1. Load Data
raw_data <- read_csv("data/development_efficiency_matrix.csv", show_col_types = FALSE)
positional_data <- read_csv("data/positional_talent_analysis.csv", show_col_types = FALSE)

# 2. Global Data Cleaning
# 100% ASCII-only code to prevent ANY RStudio parsing errors on Windows.
# Comprehensive dictionary for all Spanish/Catalan/Turkish double-mojibake characters.
fix_encoding <- function(df) {
  rep_dict <- list()
  
  # Turkish & Basic Spanish
  rep_dict[[intToUtf8(c(195, 402, 194, 339))]] <- intToUtf8(220) # Ü
  rep_dict[[intToUtf8(c(195, 402, 194, 188))]] <- intToUtf8(252) # ü
  rep_dict[[intToUtf8(c(195, 402, 194, 177))]] <- intToUtf8(241) # ñ
  rep_dict[[intToUtf8(c(195, 402, 194, 179))]] <- intToUtf8(243) # ó
  rep_dict[[intToUtf8(c(195, 402, 194, 173))]] <- intToUtf8(237) # í
  rep_dict[[intToUtf8(c(195, 402, 194, 161))]] <- intToUtf8(225) # á
  rep_dict[[intToUtf8(c(195, 402, 194, 169))]] <- intToUtf8(233) # é
  
  # Missing Catalan & Extended Spanish characters
  rep_dict[[intToUtf8(c(195, 402, 194, 186))]] <- intToUtf8(250) # ú (Araújo)
  rep_dict[[intToUtf8(c(195, 402, 194, 163))]] <- intToUtf8(227) # ã (Trincão)
  rep_dict[[intToUtf8(c(195, 402, 194, 160))]] <- intToUtf8(224) # à (Adrià, Fernández)
  
  # The Final Bosses (Euro and Left Quote fix)
  rep_dict[[intToUtf8(c(195, 402, 194, 8364))]] <- intToUtf8(192) # À (Àlex)
  rep_dict[[intToUtf8(c(195, 402, 194, 8220))]] <- intToUtf8(211) # Ó (Óscar)
  
  df %>% mutate_if(is.character, ~{
    x <- .
    for (bad_char in names(rep_dict)) {
      x <- gsub(bad_char, rep_dict[[bad_char]], x, fixed = TRUE)
    }
    x
  })
}

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

# 5. Export Clean Data
write_excel_csv(clean_data, "data/development_efficiency_matrix_final.csv")
write_excel_csv(clean_positional, "data/positional_talent_analysis_final.csv")

# 6. Load the corrupted data
raw_ranking <- read_csv("data/youth_academies_ranking.csv", show_col_types = FALSE)
raw_capacity <- read_csv("data/youth_production_capacity.csv", show_col_types = FALSE)

# 7. The Ultimate ASCII-Only Dictionary Function
fix_encoding <- function(df) {
  rep_dict <- list()
  
  rep_dict[[intToUtf8(c(195, 402, 194, 339))]] <- intToUtf8(220) # Ü
  rep_dict[[intToUtf8(c(195, 402, 194, 188))]] <- intToUtf8(252) # ü
  rep_dict[[intToUtf8(c(195, 402, 194, 177))]] <- intToUtf8(241) # ñ
  rep_dict[[intToUtf8(c(195, 402, 194, 179))]] <- intToUtf8(243) # ó (Fixes Gijón)
  rep_dict[[intToUtf8(c(195, 402, 194, 173))]] <- intToUtf8(237) # í
  rep_dict[[intToUtf8(c(195, 402, 194, 161))]] <- intToUtf8(225) # á
  rep_dict[[intToUtf8(c(195, 402, 194, 169))]] <- intToUtf8(233) # é
  rep_dict[[intToUtf8(c(195, 402, 194, 186))]] <- intToUtf8(250) # ú
  rep_dict[[intToUtf8(c(195, 402, 194, 163))]] <- intToUtf8(227) # ã
  rep_dict[[intToUtf8(c(195, 402, 194, 160))]] <- intToUtf8(224) # à
  rep_dict[[intToUtf8(c(195, 402, 194, 8364))]] <- intToUtf8(192) # À
  rep_dict[[intToUtf8(c(195, 402, 194, 8220))]] <- intToUtf8(211) # Ó
  
  df %>% mutate_if(is.character, ~{
    x <- .
    for (bad_char in names(rep_dict)) {
      x <- gsub(bad_char, rep_dict[[bad_char]], x, fixed = TRUE)
    }
    x
  })
}

# 8. Clean and Export
clean_ranking <- fix_encoding(raw_ranking)
clean_capacity <- fix_encoding(raw_capacity)

write_excel_csv(clean_ranking, "data/youth_academies_ranking_clean.csv")
write_excel_csv(clean_capacity, "data/youth_production_capacity_clean.csv")
