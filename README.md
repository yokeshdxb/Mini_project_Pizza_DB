# 🍕 Pizza Sales Analysis using MySQL

## 📊 Project Overview

This project demonstrates the use of **MySQL** to analyze sales data from a fictional pizza business. Using raw order data, I extracted valuable business insights such as revenue trends, product performance, customer ordering behavior, and top-performing pizzas.

This project simulates the kind of SQL backend logic used in BI dashboards or retail reporting systems. All queries were written and executed manually to demonstrate analytical thinking and SQL proficiency.

---

## 🗂️ Dataset Description

This project uses 4 interrelated tables from a pizza ordering system:

| Table Name      | Description                                                |
|-----------------|------------------------------------------------------------|
| `orders`        | Stores the order date and time (`order_id`, `date`, `time`)|
| `order_details` | Contains each pizza ordered per order with quantity info   |
| `pizzas`        | Contains `pizza_id`, `pizza_type_id`, `size`, and `price`  |
| `pizza_types`   | Contains `pizza_type_id`, `name`, and `category`           |

---

## 🎯 Business Questions Answered

1. ✅ How many total orders were placed?
2. ✅ What is the total revenue generated from pizza sales?
3. ✅ Which is the highest-priced pizza?
4. ✅ What is the most commonly ordered pizza size?
5. ✅ Which are the top 5 most ordered pizza types by quantity?
6. ✅ What is the total quantity sold by each pizza category?
7. ✅ How are orders distributed by hour of the day?
8. ✅ What is the average number of pizzas ordered per day?
9. ✅ What is the revenue share of each pizza category?
10. ✅ How has the revenue grown cumulatively over time?
11. ✅ Which are the top 3 pizzas by revenue for each category?

---

## 📈 Sample Insights

- 🔝 The **top 3 revenue-generating pizza types** are mostly from the **"Classic" and "Deluxe"** categories.
- 🕒 Most orders are placed between **12 PM and 2 PM**, indicating a lunch-time peak.
- 📦 **Large pizzas** are the most frequently ordered size.
- 💰 The **"Deluxe" category** generates the highest revenue share among all pizza categories.

---

## 🧠 SQL Concepts and Skills Applied

- SQL Joins (INNER JOIN, IMPLICIT JOIN)
- Aggregation (`SUM`, `COUNT`, `AVG`, `MAX`)
- Grouping & Sorting
- Subqueries
- Date/Time functions (`HOUR()`, `DATE()`)
- Rounding (`ROUND()`, `FLOOR()`, `CEIL()`)
- Window Functions (`RANK() OVER (PARTITION BY ...)`)

---

## 🗃️ Project Structure

pizza-sales-sql-project/
│
├── pizza_sales_analysis.sql       # All SQL queries grouped by question
├── README.md                      # Project overview and documentation
├── schema_overview.png            # (Optional) ER diagram
├── sample_outputs.png             # (Optional) Screenshots of sample outputs


🧾 Example SQL Query
Here’s a sample query used to find the top 3 revenue-generating pizzas per category:

SELECT name, revenue
FROM (
    SELECT pt.category, pt.name,
           FLOOR(SUM(od.quantity * p.price)) AS revenue,
           RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rank_
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON od.pizza_id = p.pizza_id
    GROUP BY pt.category, pt.name
) ranked
WHERE rank_ <= 3;

🙌 Acknowledgements
Thanks to my mentors Raja, Pranav, Chirag and Sandhya for their continuous guidance and support during this project.
