# FM20 Youth Development Analytics

This project analyzes youth talent development strategies in Football Manager 2020. It goes beyond basic statistics to understand the "Efficiency Paradox" between club size, production capacity, and development success.

## Project Structure
* **`data/`**: Processed datasets including production metrics and efficiency matrices.
* **`sql/`**: Advanced SQL queries utilizing Window Functions (e.g., `RANK()`, `PARTITION BY`) for positional scouting.
* **`scripts/`**: R-based visualization pipelines using `ggplot2` to analyze development trends.
* **`figures/`**: Analytical outputs highlighting key development trends.

## Key Insights
* **The Efficiency Paradox**: High-production clubs naturally show lower development efficiency percentages because their prospects have higher potential ceilings that require longer developmental runways.
* **Positional Specialization**: By utilizing `RANK()` window functions, this project identifies top-tier positional talent, allowing for more granular scouting beyond simple CA/PA metrics.

## Key Visualization
![Development Matrix](youth_development_matrix.png)

## Tools & Technologies
* **SQL**: Data cleaning, grouping, and complex window function analysis.
* **R**: Statistical visualization and trend analysis.
* **Methodology**: End-to-end data pipeline from raw database logs to actionable insights.

---
*Developed as a data science portfolio project.*
