/*
1 — ¿Cuáles son las 10 categorías de productos que más revenue generan en órdenes entregadas?
*/

SELECT  SUM(order_items.price) as Total_Revenue, products.product_category_name
FROM `olist.products` products
INNER JOIN `olist.order_items` order_items ON products.product_id = order_items.product_id
INNER JOIN `olist.orders` orders ON  order_items.order_id = orders.order_id
WHERE orders.order_status = 'delivered'
GROUP BY products.product_category_name
ORDER BY Total_Revenue DESC
