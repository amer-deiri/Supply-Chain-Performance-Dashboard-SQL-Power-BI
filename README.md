### Project Title

__Supply Chain Optimization Dashboard: Supplier & Logistics Performance__

### Project Overview :

This project provides a comprehensive SQL- and Power BI-based analytics solution for evaluating supply chain performance across 5,000 orders (2021–2023). 
The analysis covers supplier reliability, logistics efficiency, delivery performance, and quality metrics — delivering actionable insights that identify a 10–15% cost reduction potential and key bottlenecks in manufacturing lead times.

Key focus: Identify bottlenecks, top suppliers, and cost-saving opportunities to support supply chain decision-making and improve customer satisfaction.

Business Impact: 80.34% on-time delivery; $500K avg freight/order volume; 3.61% damage rate—actionable insights to reduce costs by 10–15%.

![Overall KPI Summary Table from SQL Query]( https://github.com/amer-deiri/Supply-Chain-Performance-Analysis-Using-SQL/blob/main/Overall%20KPI%20Summary%20Table%20from%20SQL%20Query.png)

### Dataset Used : 

- suppliers.csv (3 rows): Supplier ID & Name (AG group, H7L group, Star group).

- details.csv (5,000 rows): Order details—Manufacturing/Delivery Time (days), Units Shipped (~625K total), Damaged Units, Returns, Supplier, Raw Material Lead Time.

- order statuses.csv (5,000 rows): Order Number, Date, Status (On Time/Late), Freight Cost (~$100 avg).

Total: 5,000 unique orders; No missing keys; Merged on Order Number & Supplier ID.

### Tools Used

- SQL Server: Core analysis (CREATE DB, Queries, Joins, Aggregations, Cleaning).
- SSMS (SQL Server Management Studio): Execution, exploration, & visualization.
- Pandas (for validation): Data verification (not production).
- Suggested: Power BI/Tableau for interactive dashboards from SQL views.

### KPIs and Business Questions Answered
## Core KPIs


| KPI | Value | Insight |
|-----|-------|---------| 
|Total Orders| 5,000 | Stable volume |
|Total Units Shipped | 625,099 | High throughput | 
|Avg Raw Material Lead Time | 4.01 days | Efficient sourcing |
| Avg Manufacturing Time | 5.53 days | Bottleneck here | 
| Avg Delivery Time| 2.50 days | Strong logistics | 
| Avg Freight Cost| $100.14 | Optimize for savings | 
| On-Time Delivery Rate| 80.34% | Room for 90% target | 
| Damage Rate| 3.61% | $22K lost value | 
| Return Rate | 1.63% | Quality issue | 


### Questions Answered

- Which supplier performs best? H7L (81% on-time, 1,719 orders).
- Logistics bottlenecks? Manufacturing (5.53 days avg); Late orders have +0.04 days delivery.
- Cost/Quality correlations? Low; Damaged unrelated to lead times.
- Improvement areas? AG group (worst on-time: 80%).

### Transformation / Preparation / Data Cleaning Process

1- Import: **CREATE DATABASE SupplyChainDB;** Bulk load CSVs.

2- Explore: **COUNT(*)** (5K rows/table); **sp_help;** Duplicates/NULLs (0).

3- Clean:


| Step | SQL |
|------|-----|
| Remove Duplicates | **DELETE ... HAVING COUNT(*) > 1** | 
| NULLs → 0 | **UPDATE Damaged_Units/Returns = 0** | 
| Data Types | **TRY_CONVERT(DATE)** for Order_Date; DECIMAL for Freight | 

4- Merge: **JOIN** on Order_Number/Supplier_id.

5- Validate: No orphans; 100% match.

![SQL Cleaning Queries & Execution Plan]( https://github.com/amer-deiri/Supply-Chain-Performance-Analysis-Using-SQL/blob/main/datacleaning%20_1.png)
![SQL Cleaning Queries & Execution Plan]( https://github.com/amer-deiri/Supply-Chain-Performance-Analysis-Using-SQL/blob/main/datacleaning%20_2.png)
![SQL Cleaning Queries & Execution Plan]( https://github.com/amer-deiri/Supply-Chain-Performance-Analysis-Using-SQL/blob/main/datacleaning%20_3.png)



### Exploratory Data Analysis (EDA)

- Uniques: Status: 2 (On Time 80%, Late 20%); Suppliers: Balanced (~1,600–1,700 orders each).
- Distributions: Lead Times: 2–6 days (std=1.4); Damaged: 0–9/order (mean=4.52).
- Correlations: Raw Lead vs Delivery: -0.017 (negligible).
- Outliers: 983 Late orders (19.7%); Highest freight: ~$150.

### Dashboard

SQL-Powered Interactive Views (Run in SSMS/Power BI):

1- Overview Page: KPI cards + Pie (On-Time vs Late).

2- Supplier Comparison: Bar charts (Orders, On-Time %, Damaged).

3- Trends Page: Line (Lead Times by Supplier) + Heatmap (Freight by Status).


Sample Query Output:

| Supplier | Orders | On-Time % | Avg Damaged |
|----------|--------|-----------|-------------|
H7L      | 1,719  | 81.0     | 4.55 |
Star     | 1,665  | 80.1     | 4.49 | 
AG       | 1,616  | 80.0     | **4.41** (Best) |

![SSMS Results Grid]( https://github.com/amer-deiri/Supply-Chain-Performance-Analysis-Using-SQL/blob/main/SSMS%20Results%20Grid.png)

### Data Analysis & Results

- Supplier Breakdown:

| Supplier | Orders | Units,On-Time % | Avg Damaged | Avg Freight |
|----------|--------|-----------------|-------------|-------------|
| H7L | 1,719 | 213,939 | 81.0 | 4.55 | $99.82 |
| Star| 1,665 | 207,540 | 80.1 | 4.49 | $100.36 |
| AG | 1,616 | 203,620 | 80.0 | 4.41 | $100.25 |

- Late Orders: 983 (19.7%); Avg Del Time: 2.54 days (vs 2.48 on-time).
- Costs: $500,700 total freight; Damaged: ~22,500 units lost.

### Project Insights

- Strengths: Fast delivery (2.5 days); Balanced suppliers.
- Weaknesses: Manufacturing delay primary bottleneck; 20% late rate impacts satisfaction.
- Opportunities: H7L excels in reliability—increase allocation; AG best quality.
- Risks: 3.61% damage erodes margins; No strong correlations = systemic issues.

### Recommendations

1- Prioritize H7L: +10% volume for 81% on-time.

2- Manufacturing Fix: Target <5 days via automation/training.

3- Quality Program: Partner with AG for damage reduction (Target: <3%).

4- Freight Optimization: Negotiate bulk rates (Save 10–15%).

5- Monitor Late Orders: Alert on >3-day delivery.

6- Next Steps: Power BI dashboard + Monthly refresh; Forecast with ML.



![Supplier Performance Chart]( https://github.com/amer-deiri/Supply-Chain-Performance-Analysis-Using-SQL/blob/main/Supplier%20Performance%20Chart.png)

