/*
1 - Top 10 customers by number of delivered orders, only from cities that have more than 100 customers registered.
*/
SELECT orders.customer_id, COUNT( orders.order_id), customers.customer_city
  FROM `olist.orders` orders
INNER JOIN `customers` customers
ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
AND customers.customer_city IN (
  SELECT
    customers.customer_city
  FROM
    `olist.customers` customers
  GROUP BY
    customers.customer_city
  HAVING
    COUNT(*) > 100
)
GROUP BY
    orders.customer_id, customers.customer_city

/*
 2 - All orders where the payment value is above the overall average payment value.
*/
SELECT orders.order_id
    FROM `olist.orders` orders
INNER JOIN
    `order_payments` order_pay
ON
orders.order_id = order_pay.order_id
WHERE order_pay.payment_value > (
    SELECT
        AVG(order_pay.payment_value) as prom_payment_value
    FROM
    `olist.order_payments` order_pay
)

/* 3. For each order, show order id, payment value, and the overall average payment value as a separate column. */

SELECT
  order_pay.order_id,
  order_pay.payment_value,
  (
    SELECT AVG(payment_value)
    FROM `olist.order_payments`
  ) AS AveragePayment
FROM `olist.order_payments` order_pay

/* 4 - Average number of items per order, from delivered orders only. */

SELECT
  AVG(items_per_order.item_count) AS AverageItemsPerOrder
FROM
  (
    SELECT COUNT(order_items.product_id) as item_count
    FROM `olist.orders` orders
    INNER JOIN `order_items` order_items
      ON orders.order_id = order_items.order_id
    WHERE orders.order_status = "delivered"
    GROUP BY order_items.order_id
  ) AS items_per_order


/* 5 - For each seller, show their total revenue only if it exceeds the average revenue of all sellers.. */
SELECT seller_id, SUM(price) AS total_revenue
FROM `olist.order_items` order_items
GROUP BY seller_id
HAVING
  total_revenue > (
    SELECT AVG(seller_total)
    FROM
      (
        SELECT SUM(price) AS seller_total
        FROM `olist.order_items`
        GROUP BY seller_id
      )
  )