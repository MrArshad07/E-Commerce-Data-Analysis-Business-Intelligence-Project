select count(*)from ecommerce_data;
#droping some unusefull columns
ALTER TABLE ecommerce_data
DROP COLUMN order_item_id,
DROP COLUMN review_creation_date,
DROP COLUMN review_answer_timestamp,
DROP COLUMN product_weight_g ,
DROP COLUMN product_length_cm,
DROP COLUMN product_height_cm,
DROP COLUMN product_width_cm;

-- 1.Top 10 States by Revenue
SELECT 
    customer_state, 
    SUM(price + freight_value) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_data
GROUP BY customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- 2.Top 10 Cities by Number of Orders ,Which cities have the highest order volume?
SELECT 
    customer_city, 
    COUNT(order_id) AS total_orders
FROM ecommerce_data
GROUP BY customer_city
ORDER BY total_orders DESC
LIMIT 10;

-- 3.Top 5 Product Categories by Average Review Score
SELECT 
    product_category_name,
    AVG(review_score) AS avg_review_score,
    COUNT(review_id) AS total_reviews
FROM ecommerce_data
WHERE review_score IS NOT NULL
GROUP BY product_category_name
ORDER BY avg_review_score DESC
LIMIT 5;

-- .4Delivery Performance: Average Delivery Time per State
SELECT 
    customer_state,
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days,
    COUNT(order_id) AS total_orders
FROM ecommerce_data
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY customer_state
ORDER BY avg_delivery_days ASC;

-- 5. Customer Segmentation by Total Order Value,Who are the high-value customers?
SELECT 
    customer_unique_id,
    COUNT(order_id) AS total_orders,
    SUM(price + freight_value) AS total_order_value
FROM ecommerce_data
GROUP BY customer_unique_id
ORDER BY total_order_value DESC
LIMIT 10;

-- 6. Monthly Trend Analysis: Revenue & Orders
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(order_id) AS total_orders,
    SUM(price + freight_value) AS total_revenue
FROM ecommerce_data
GROUP BY order_month
ORDER BY order_month;

-- 7. Fast vs Normal Delivery Flag for Logistics Insight,Which orders were fast delivery vs normal delivery?
SELECT
    customer_city,
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days,
    COUNT(order_id) AS total_orders,
    CASE 
        WHEN AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) <= 5 THEN 'Fast Delivery'
        ELSE 'Normal Delivery'
    END AS delivery_type
FROM ecommerce_data
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY customer_city
ORDER BY avg_delivery_days ASC;

