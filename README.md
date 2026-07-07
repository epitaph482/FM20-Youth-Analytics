# FM20 Youth Development Analytics

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![ggplot2](https://img.shields.io/badge/ggplot2-3399FF?style=for-the-badge&logo=r&logoColor=white)
![dplyr](https://img.shields.io/badge/dplyr-1565C0?style=for-the-badge&logo=r&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-FF9900?style=for-the-badge)

This project explores the "Efficiency Paradox" in Football Manager 2020: Do large academies produce better players, or do smaller ones develop talent more efficiently?

## Project Structure
* **`data/`**: Contains raw datasets (`.csv`) and the cleaned output (`development_efficiency_matrix_clean.csv`).
* **`scripts/`**: Contains the primary analysis pipeline (`analysis.R`).
* **`images/`**: Contains the high-fidelity visualization outputs.
* **`sql/`**: Contains the database extraction logic using SQL Window Functions.

## Key Insights
* **The Efficiency Paradox**: High-production clubs often show lower efficiency percentages as their vast talent pools dilute the average. 
* **Positional Specialization**: Smaller clubs frequently demonstrate superior development efficiency in high-potential prospects compared to global giants.

## Key Visualization
![Youth Development Matrix](images/youth_development_matrix.png)

## Data Pipeline & Methods
1. **Data Extraction**: Used SQL Window Functions (`RANK()` over `PARTITION BY`) to rank prospects within their specific academies and positions.
2. **Data Cleaning**: Applied a global encoding fix in R to handle international character sets across academy names.
3. **Visualization**: Used `ggplot2` with `viridis` scales to map development efficiency against current/potential ability metrics.

---
*Developed as a data analytics portfolio project by Ali.*
