# Coffee Chain Sales Data Analysis

## Project Overview

The Coffee Chain Sales Analysis project focuses on evaluating the performance of a coffee chain across various locations in the U.S. The dataset, sourced from Kaggle, consists of 1,063 records with 21 attributes related to sales performance, costs, and market conditions.

### Tools and Techniques Used

- **SQL & MySQL**: Utilized for data manipulation and querying.
- **Normalization**: Applied to structure data into 3NF, eliminating redundancy and ensuring data integrity.
- **Dimensional Modeling**: Implemented both Star and Snowflake schemas to support complex queries and efficient data retrieval.

## Key Steps in the Analysis

### Data Loading and Normalization
- The raw data was loaded into MySQL and normalized into relational tables that conform to Third Normal Form (3NF). This ensured data integrity and reduced redundancy.

### Schema Creation
- A dimensional model was created, organizing data into a combination of fact and dimension tables. This structure facilitated easy analytical querying.

### Fact Tables
- Key metrics such as sales, targets, and expenses were included in fact tables.

### Dimension Tables
- Dimension tables included details such as product information, market data, and geographical data.

### Analytical Queries and Reporting
- Performed complex SQL queries to derive insights.
- Calculated key performance indicators (KPIs) including total expenses, margins, sales, and profits.
- Analyzed product and market performance, seasonal trends, and target achievements.
- Explored the correlation between inventory margins and sales volumes, and compared sales and expenses across different states.

## Outcomes and Insights

### Profitable Product Lines
- **Beans and Leaves** were identified as the most profitable product lines. Focusing on these could help maximize profit margins.

### State-Level Performance
- **California** emerged as the leader in sales, while **New York** reported the highest expenses. This suggests opportunities for optimizing costs and operations in New York.

### Target Sales & Profit Achievement
- Products like **Lemon Tea** and **Darjeeling Tea** consistently surpassed both sales and profit targets, highlighting strong market demand and effective sales strategies for these items.

### Market Analysis
- Major markets contributed significantly more to overall sales compared to smaller markets.

### Expense Management
- The **East** and **Central** markets were more profitable than other regions, suggesting more efficient operations or lower costs.

### Year-on-Year Sales Trends
- Sales experienced substantial growth from 2012 to 2014, followed by a 20% decline in 2015. However, inventory margins steadily increased each year, indicating improved profitability per product sold.


