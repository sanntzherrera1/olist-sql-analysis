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
