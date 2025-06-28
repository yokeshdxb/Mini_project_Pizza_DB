-- ===============================================
-- 🍕 Pizza Sales Analysis Project using MySQL
-- Author: Yokesh Kumar Sundararaman
-- GitHub: https://github.com/yokeshdxb/Mini_project_Pizza_DB.git
-- ===============================================

USE pizza_db;

-- ================================
-- 🔍 Explore the Tables
-- ================================
SELECT * FROM order_details LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM pizzas LIMIT 10;
SELECT * FROM pizza_types LIMIT 10;

-- ================================
-- 📌 Question 1: Total Orders Placed
-- ================================
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- ================================
-- 💰 Question 2: Total Revenue from Pizza Sales
-- ================================
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p ON od.pizza_id = p.pizza_id;

-- ================================
-- 🔝 Question 3: Highest Priced Pizza
-- ================================
SELECT pt.name, p.price
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Subquery Method
SELECT pt.name
FROM pizza_types AS pt
WHERE pt.pizza_type_id = (
    SELECT pizza_type_id
    FROM pizzas
    WHERE price = (SELECT MAX(price) FROM pizzas)
);

-- ================================
-- 📏 Question 4: Most Common Pizza Size Ordered
-- ================================
SELECT p.size, COUNT(*) AS order_count
FROM pizzas AS p
JOIN order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC
LIMIT 1;

-- ================================
-- 🏆 Question 5: Top 5 Most Ordered Pizza Types (by Quantity)
-- ================================
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

-- ================================
-- 🧮 Question 6: Total Quantity by Pizza Category
-- ================================
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- ================================
-- ⏰ Question 7: Order Distribution by Hour
-- ================================
SELECT HOUR(time) AS hour_of_day, COUNT(order_id) AS order_count
FROM orders
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- ================================
-- 📦 Question 8: Category-wise Pizza Order Distribution
-- ================================
SELECT pt.category, COUNT(od.order_id) AS number_of_orders
FROM pizza_types AS pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY number_of_orders DESC;

-- ================================
-- 📅 Question 9: Average Pizzas Ordered Per Day
-- ================================
SELECT FLOOR(AVG(daily_quantity)) AS avg_pizzas_per_day
FROM (
    SELECT o.date, SUM(od.quantity) AS daily_quantity
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.date
) AS sub;

-- ================================
-- 💸 Question 10: Top 3 Pizza Types by Revenue
-- ================================
SELECT pt.name, FLOOR(SUM(od.quantity * p.price)) AS revenue
FROM pizza_types AS pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- ================================
-- 📊 Question 11: Category-wise % Revenue Contribution
-- ================================
SELECT pt.category,
       ROUND((SUM(od.quantity * p.price) / (
           SELECT SUM(od2.quantity * p2.price)
           FROM order_details od2
           JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id
       ) * 100), 2) AS revenue_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- ================================
-- 📈 Question 12: Cumulative Revenue Over Time
-- ================================
SELECT o.date,
       FLOOR(SUM(od.quantity * p.price)) AS daily_revenue,
       FLOOR(SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date)) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date;

-- ================================
-- 🥇 Question 13: Top 3 Revenue Pizzas by Category
-- ================================
SELECT name, revenue
FROM (
    SELECT pt.category, pt.name,
           FLOOR(SUM(od.quantity * p.price)) AS revenue,
           RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rank_
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON od.pizza_id = p.pizza_id
    GROUP BY pt.category, pt.name
) AS ranked
WHERE rank_ <= 3;
