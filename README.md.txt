# SQL + Power BI E-Commerce Sales Analysis

## 📌 Overview
This project is an end-to-end e-commerce sales analysis built using SQL in Google BigQuery and Power BI.  
The goal is to transform raw transactional data into a structured analytical model, generate business-focused insights, and present the results through an interactive dashboard.

## ❓ Business Questions
This project focuses on the following questions:
- How do sales and profit change over time?
- Which categories and products perform best?
- How do returns and cancellations affect performance?
- How is customer value distributed across segments?

## 🛠 Tools & Technologies
- **SQL / Google BigQuery:** For data processing and analytical queries.
- **Power BI:** For data modeling and interactive reporting.
- **DAX:** For creating business metrics and KPIs.

## 🔄 Methodology
This project followed a structured data analysis workflow:
1. **Dataset Creation & Loading:** Worked with a custom e-commerce dataset generated with AI assistance and loaded it into Google BigQuery for analysis.
2. **Data Validation:** Used SQL to validate the dataset through null checks, duplicate checks, ID format checks, and relationship consistency checks across fact and dimension tables.
3. **Data Preparation & Transformation:** Created analytical fields such as gross sales, net sales, profit, return flags, and time-based attributes to support reporting and business analysis.
4. **Customer Segmentation:** Applied RFM analysis in SQL to evaluate customer behavior based on Recency, Frequency, and Monetary value.
5. **Data Modeling & Visualization:** Used a star schema structure to support analysis and built an interactive Power BI dashboard for exploring sales performance, profitability, returns, and customer segments.

## 📂 Dataset
Instead of working with widely repeated sample datasets often used in entry-level portfolio projects, I chose to build this project on a **custom dataset created with AI assistance**.  
The goal was to create a more original project while simulating a realistic e-commerce business scenario.

The dataset was designed in a **Star Schema** structure for analytical reporting, with `fact_sales` as the central fact table and supporting dimension tables such as:
- `dim_date`
- `dim_customer`
- `dim_product`
- `dim_store`
- `dim_payment_method`

## 🛠️ Data Model
The project follows a **Star Schema** to support efficient reporting and analysis.

![Data Model](powerbi/data_model.png)

- **Fact Table:** `fact_sales` (Contains transactional data and metrics).
- **Dimension Tables:** `dim_customer`, `dim_product`, `dim_date`, `dim_store`, and `dim_payment_method`.
- **Relationship:** **1:N (One-to-Many)** relationships established between dimensions and fact table.

## 🧹 Data Preparation
The dataset was validated in SQL through null checks, duplicate checks, ID validation, and relationship consistency checks. Additional analytical fields such as **gross sales, net sales, profit, and return flags** were created to support reporting.

## 📊 Key Analyses
- **KPI Summary:** Tracking core business health metrics.
- **Sales Trend Analysis:** Identifying growth patterns over time.
- **Profitability Analysis:** Evaluating margin performance by category.
- **Return & Cancellation Analysis:** Analyzing the impact of lost sales.
- **Customer Segmentation (RFM):** Classifying customers into value-based segments.
- **Holiday / Seasonality Analysis:** Measuring performance during peak periods.

## 🖼 Dashboard Preview

### Sales Performance Overview
![Sales Performance Overview](powerbi/sales_performance_overview.png)
This page shows overall sales, profit, orders, and general performance trends.

### Sales Analysis
![Sales Analysis](powerbi/sales_analysis.png)
This page shows category performance, channel contribution, profitability, and return behavior.

### Customer Segmentation
![Customer Segmentation](powerbi/customer_segmentation.png)
This page shows RFM-based customer segments and their contribution to total revenue.

## 💡 Key Insights
- The **Loyal Customers** segment generated **$74.08M in net sales** and made up **50.63%** of total segment revenue, showing that retention should be a key business focus.
- **Electronics** ranked first in both sales and profitability, reaching **$82M in sales** and a **26.2% profit margin**, making it the strongest category for both revenue and margin growth.
- Sales reached their highest levels in **November and December** in both years. **November 2025** was the strongest month, with nearly **$18M** in sales, suggesting clear opportunities for seasonal planning.
- The **Beauty** category almost **doubled in 2025** compared to 2024, making it one of the most improved categories and a strong area to watch for future growth.
- The **Web** channel accounted for **50.7%** of total sales, making it the strongest sales channel overall and an important focus for channel strategy.
- **Fashion** had the highest return rate at **10.6%**, pointing to a clear opportunity to reduce return-related losses.
- **Grocery** had the lowest profit margin at **11.1%** and the lowest return rate at **3.2%**, suggesting a stable but lower-return category where margin improvement could be explored.

## 📚 What I Learned
Through this project, I improved my skills in:
- Writing analytical SQL queries using CTEs and window functions.
- Validating and preparing data for reporting.
- Building a Star Schema for analytical reporting.
- Creating business-focused KPIs using **DAX**.
- Designing user-centric, interactive Power BI dashboards.
- Translating raw data into actionable business insights.

## ✅ Conclusion
This project helped me strengthen both my technical and analytical skills by combining SQL, data modeling, and dashboard design in a realistic business scenario.
