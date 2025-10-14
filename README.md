# SQL Projects

This repository showcases my SQL experience through business analytics and data warehousing use cases.  
All queries are written in **T-SQL (SQL Server)** and focus on practical, real-world insights.

---

## Project 1: Retail Sales Analysis
**Goal:** Analyze retail sales performance, customer behavior, and profitability over time.

### Expected Schema
- **Customers**(CustomerID, CustomerName, Segment, City, State, Country)  
- **Products**(ProductID, Category, SubCategory, ProductName)  
- **Orders**(OrderID, OrderDate, ShipDate, CustomerID, ProductID, Quantity, UnitPrice, Discount, ShippingCost)

---

### Files Overview

- `retail_sales_analysis/01_revenue_growth.sql` – monthly revenue with MoM and YoY growth *(window functions, LAG)*  
- `retail_sales_analysis/02_top_customers.sql` – top customers by revenue and profit margin *(ranking, RANK)*  
- `retail_sales_analysis/03_profitability_by_category.sql` – category/subcategory profitability *(GROUP BY, CASE)*  
- `retail_sales_analysis/04_monthly_kpi.sql` – monthly KPI summary *(Revenue, Profit, Margin)*  
- `retail_sales_analysis/05_rolling_30d_revenue.sql` – rolling 30-day revenue using recursive CTE + window SUM()  
- `retail_sales_analysis/06_cohort_retention.sql` – cohort analysis of customer retention (first order → repeat orders)  
- `retail_sales_analysis/07_rfm_segmentation.sql` – RFM segmentation using `NTILE()` and window scores  
- `retail_sales_analysis/08_topN_products_per_category.sql` – Top-N products by revenue in each category *(ROW_NUMBER)*  
- `retail_sales_analysis/09_basket_affinity.sql` – simple market basket analysis with support, confidence, and lift  
- `retail_sales_analysis/10_anomaly_zscore.sql` – anomaly detection on daily revenue via rolling z-score

---

### Output Examples
Example dashboards or BI layers could visualize:
- Monthly revenue and MoM growth trends  
- Retention heatmap by cohort month  
- RFM segmentation distribution  
- Top 10 products per category  
- Daily anomalies highlighted on time-series plots  

---

### Repository Structure
sql_projects/
├── retail_sales_analysis/
│   ├── 01_revenue_growth.sql
│   ├── 02_top_customers.sql
│   ├── 03_profitability_by_category.sql
│   ├── 04_monthly_kpi.sql
│   ├── 05_rolling_30d_revenue.sql
│   ├── 06_cohort_retention.sql
│   ├── 07_rfm_segmentation.sql
│   ├── 08_topN_products_per_category.sql
│   ├── 09_basket_affinity.sql
│   ├── 10_anomaly_zscore.sql
├── docs/
└── README.md