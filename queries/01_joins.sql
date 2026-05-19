/*
1 — Top 10 product categories by total revenue from delivered orders
*/

SELECT  SUM(order_items.price) as Total_Revenue, products.product_category_name
    FROM `olist.products` products
INNER JOIN `olist.order_items` order_items ON products.product_id = order_items.product_id
INNER JOIN `olist.orders` orders ON  order_items.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY products.product_category_name
ORDER BY Total_Revenue DESC


/* 2 — Top 10 sellers by number of delivered orders and average ticket */
SELECT sellers.seller_id,COUNT(DISTINCT orders.order_id) count_orders_deliv, AVG(order_items.price) as ticket_avg
    FROM `olist.sellers` sellers
INNER JOIN `olist.order_items` order_items ON sellers.seller_id = order_items.seller_id
INNER JOIN `olist.orders` orders ON order_items.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY  sellers.seller_id
ORDER BY count_orders_deliv DESC
LIMIT 10

/* 3 - Products with no associated orders (never sold) */
SELECT products.product_id, order_items.order_id
    FROM `olist.products` products LEFT JOIN `olist.order_items` order_items
ON products.product_id = order_items.product_id
WHERE order_items.order_id IS NULL
-- La query no trae ningun producto ya que al menos una vez fue vendido


/*4 - All delivered orders with their review score (NULL if no review) */
SELECT orders.order_id, order_review.review_score
FROM `olist.orders` orders
LEFT JOIN  `olist.order_reviews` order_review ON orders.order_id = order_review.order_id
WHERE orders.order_status = "delivered"

/*
5 - Customers with exactly one delivered order (no repeat purchases)
*/
SELECT customers.customer_id, COUNT(DISTINCT orders.order_id) as total_orders_p_client
    FROM `olist.customers` customers
LEFT JOIN  `olist.orders` orders ON customers.customer_id= orders.customer_id
WHERE orders.order_status = "delivered"
GROUP BY  customers.customer_id
HAVING total_orders_p_client = 1

/*
6 - Average review score per product category, ranked best to worst
*/

SELECT products.product_category_name, AVG(order_review.review_score) as Score_Cat
  FROM `project-olist-496723.olist.orders` orders
INNER JOIN `project-olist-496723.olist.order_reviews` order_review
ON orders.order_id = order_review.order_id
INNER JOIN `project-olist-496723.olist.order_items` order_items
ON order_review.order_id = order_items.order_id
INNER JOIN `project-olist-496723.olist.products` products
ON order_items.product_id = products.product_id
GROUP BY products.product_category_name
ORDER BY Score_Cat DESC
