🍔 Swiggy Data Analysis | SQL, Star Schema & Power BI
📌 Project Overview

This project is an end-to-end analytics case study on Swiggy food delivery data, focusing on data modeling, SQL transformation, and business visualization.

Raw transactional data was modeled into a Star Schema using SQL and then used in Power BI to build an interactive business performance dashboard.

The dataset is a public Swiggy dataset from Kaggle, used strictly for educational and case-study purposes.

🎯 Business Objectives

Design a reporting-ready data model

Track orders, revenue, and customer behavior

Enable fast and scalable analytics using a star schema

Build an interactive dashboard for business decision-making

🧱 Data Modeling (Star Schema)

A Star Schema was designed to optimize analytical queries and Power BI performance.

⭐ Fact Table

fact_orders

order_id

order_date

total_amount

quantity

rating

delivery_type

payment_method_id

customer_id

restaurant_id

city_id

🌟 Dimension Tables

dim_date – date, month, quarter, year

dim_customer – customer_id, customer details

dim_restaurant – restaurant, category

dim_city – city, state

dim_payment – payment method (Online, COD, Wallet)

This structure enables:

Faster aggregations

Clean relationships in Power BI

Scalable reporting design

📁 SQL scripts for schema creation are available in the Data Modeling folder.

🛠 Tools & Technologies

SQL – Data cleaning, transformation, star schema design

Power BI – DAX, KPIs, interactive dashboards

CSV / Excel – Raw dataset

GitHub – Version control

🧹 Data Processing (SQL)

Cleaned raw transactional data

Normalized entities into dimension tables

Loaded transformed data into fact and dimension tables

Validated relationships for analytical accuracy

📊 Power BI Dashboard Features
🔹 KPIs

Total Orders

Total Revenue

Average Order Value

Average Rating

🔹 Analysis

Monthly Orders & Revenue Trends

Payment Method Contribution

City-wise Performance

Interactive filters & navigation

📸 Dashboard screenshots available in the Dashboard folder.

📈 Key Insights

Online payments dominate revenue contribution

Clear seasonality observed in monthly performance

Star schema improved report performance and clarity

City-level analysis highlights high-performing regions

🚀 How to Use

Review SQL scripts for star schema creation

Explore fact & dimension relationships

Open the Power BI file to interact with dashboards

📌 Disclaimer

This project uses publicly available data for learning purposes only and does not represent internal Swiggy analytics.

👤 About Me

Actively seeking entry-level Data Analyst / SQL / Power BI roles.

🔗 LinkedIn: https://www.linkedin.com/in/anilkumar-budda-5a240128b
📧 Email: anilkumar.budda44@gmail.com
