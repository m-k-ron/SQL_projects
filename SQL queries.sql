/** Queries in MySQL **/

/* menu_items table */

-- 1. View the menu_items table.
SELECT * FROM menu_items;

-- 2. Find the number of items on the menu.
SELECT COUNT(*)
FROM menu_items;

-- 3. What are the least and most expensive items on the menu?
SELECT *
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items) OR price = (SELECT MIN(price) FROM menu_items);

-- 4. How many Italian dishes are on the menu?
SELECT COUNT(*)
FROM menu_items
WHERE category = 'Italian';

-- 5. What are the least and most expensive Italian dishes on the menu?
SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC;

-- 6. How many dishes are in each category?
SELECT COUNT(menu_item_id) AS count, category
FROM menu_items
GROUP BY category;

-- 7. What is the average dish price within each category?
SELECT category, AVG(price) AS average_price
FROM menu_items
GROUP BY category;

/* order_details table */

-- 1. View the order_details table.
SELECT * FROM order_details;

-- 2. What is the date range of the table?
SELECT  MIN(order_date), MAX(order_date)
FROM order_details

-- 3. How many orders were made within this date range?
SELECT COUNT(DISTINCT order_id) 
FROM order_details;

-- 4. How many items were ordered within this date range?
SELECT COUNT(item_id) 
FROM order_details;

-- 5. Which orders had the most number of items?
SELECT order_id, COUNT(item_id)
FROM order_details
GROUP BY order_id
ORDER BY COUNT(item_id) DESC
;

-- 6. How many orders had more than 12 items?
SELECT COUNT(*) FROM
(SELECT order_id, COUNT(item_id)
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12) AS num_orders

-- 7. What is the average number of items ordered per order?
SELECT AVG(num_items) FROM
(SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id) AS avg_items
;

/* combining both tables */

-- 1. Combine the menu_items and order_details tables into a single table.
/* checking both tables */
SELECT * FROM menu_items;
SELECT * FROM order_details;

SELECT * FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id;

-- 2. What were the least and most ordered items? What categories were they in?
SELECT item_name, COUNT(order_details_id) AS num_purchases
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY item_name
ORDER BY num_purchases;

-- 3.What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spend
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

-- 4. View the details of the highest spend order. What insights can you gather from the results?
SELECT category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id = '440'
GROUP BY category;

-- 5. View the details of the top 5 highest spend orders. What insights can you gather from the results?
SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
WHERE order_id IN ('440', '2075', '1956', '330', '2675')
GROUP BY order_id, category;

/* extra */

-- 6. What is the average spend per order?
SELECT order_id, AVG(price) AS average_spend
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY order_id;

-- 7. What is the average spend per item?
SELECT item_id, item_name, AVG(price) AS average_spend
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY item_id, item_name;

-- 8. What is the average spend per category?
SELECT category, AVG(price) AS average_spend
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY category;

-- 9. What is the average spend per category per order?
SELECT category, order_id, AVG(price) AS average_spend
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY category, order_id;

-- 10. What is the average spend per category per item?
SELECT category, item_id, AVG(price) AS average_spend
FROM order_details od
LEFT JOIN menu_items mi
ON od.item_id = mi.menu_item_id
GROUP BY category, item_id;

