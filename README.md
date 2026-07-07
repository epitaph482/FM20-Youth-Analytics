# FM20 Youth Development Analytics

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![ggplot2](https://img.shields.io/badge/ggplot2-3399FF?style=for-the-badge&logo=r&logoColor=white)
![dplyr](https://img.shields.io/badge/dplyr-1565C0?style=for-the-badge&logo=r&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-FF9900?style=for-the-badge)

This project analyzes youth talent development strategies in Football Manager 2020. It goes beyond basic descriptive statistics to understand the "Efficiency Paradox" between a football club's size, its youth production capacity, and ultimate development success.

## Project Structure
* **`data/`**: Contains the raw and processed datasets, including `development_efficiency_matrix_clean.csv`.
* **`scripts/`**: Includes `fmcode.R`, the R-based data cleaning and visualization pipeline.
* **`images/`**: Houses the final visualizations, such as `youth_development_matrix.png`.

## Key Insights
* **The Efficiency Paradox**: High-production clubs naturally show lower development efficiency percentages. Their prospects have higher potential ability (PA) ceilings, which demand longer and more rigorous developmental runways to reach full current ability (CA).
* **Positional Specialization**: Identifying top-tier positional talent requires granular comparison within specific academies, moving beyond broad CA/PA averages.

## Key Visualization
*The matrix below visualizes the relationship between Average Current Ability and Average Potential Ability across different academies, highlighting which clubs are most efficient at developing raw talent.*

![Youth Development Matrix](images/youth_development_matrix.png)

## Technical Implementation: SQL Window Functions
The foundational data for this matrix was extracted from a large PostgreSQL database. To accurately rank youth prospects relative to their peers within the same academy and position, the data pipeline utilizes SQL Window Functions. 

**Example snippet from the positional ranking query:**
```sql
SELECT 
    club,
    name,
    best_position,
    ca AS current_ability,
    pa AS potential_ability,
    RANK() OVER (PARTITION BY club, best_position ORDER BY pa DESC) as positional_rank
FROM 
    fm20_dev_data
WHERE 
    age <= 19
ORDER BY 
    club, positional_rank;
