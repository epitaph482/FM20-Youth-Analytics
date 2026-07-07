# FM20 Youth Development Analytics

This project analyzes youth talent development strategies in Football Manager 2020. It goes beyond basic descriptive statistics to understand the "Efficiency Paradox" between a football club's size, its youth production capacity, and ultimate development success.

## Project Files
* **`development_efficiency_matrix_clean.csv`**: The processed dataset containing production metrics and efficiency calculations, extracted from a 144k+ rows raw dataset.
* **`fmcode.R`**: The R-based data cleaning and visualization script utilizing `ggplot2` and `dplyr`.
* **`youth_development_matrix.png`**: The final scatter plot visualization exported from the R pipeline.

## Key Insights
* **The Efficiency Paradox**: High-production clubs naturally show lower development efficiency percentages. Their prospects have higher potential ability (PA) ceilings, which demand longer and more rigorous developmental runways to reach full current ability (CA).
* **Positional Specialization**: Identifying top-tier positional talent requires granular comparison within specific academies, moving beyond broad CA/PA averages.

## Key Visualization
*The matrix below visualizes the relationship between Average Current Ability and Average Potential Ability across different academies, highlighting which clubs are most efficient at developing raw talent.*

![Youth Development Matrix](youth_development_matrix.png)

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
