SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS coffee_orders;

USE coffee_orders;

SHOW DATABASES;

SHOW TABLES;

CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(255),
    order_date DATE,
    customer_id VARCHAR(255),
    product_id VARCHAR(255),
    quantity INT
);

SELECT * FROM orders;

TRUNCATE TABLE orders;

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(255),
    customer_name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255),
    address_line_1 VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    postcode VARCHAR(255),
    loyalty_card VARCHAR(255)
);

SELECT * FROM customers;

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(255),
    coffee_type VARCHAR(255),
    roast_type VARCHAR(255),
    size FLOAT(7, 3),
    unit_price FLOAT(7, 3),
    price_per_100g FLOAT(7, 3),
    profit FLOAT(7, 5)
);

SELECT * FROM products;

-- Sales over time - using CTE
WITH total_sales AS (
    SELECT
            DATE_FORMAT(O.order_date, '%m') AS OrderMonth, DATE_FORMAT(O.order_date, '%Y') AS OrderYear,
            CASE
                WHEN P.coffee_type = 'Rob' THEN 'Robusta'
                WHEN P.coffee_type = 'Exc' THEN 'Excelsa'
                WHEN P.coffee_type = 'Ara' THEN 'Arabica'
                ELSE 'Liberica'
            END AS CoffeeTypeName,
            (O.quantity * P.unit_price) AS sales
    FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
    ON O.customer_id = C.customer_id AND O.product_id = P.product_id
)
SELECT
    OrderYear, OrderMonth,
    ROUND(SUM(CASE WHEN CoffeeTypeName = 'Robusta' THEN sales END)) AS Robusta,
    ROUND(SUM(CASE WHEN CoffeeTypeName = 'Excelsa' THEN sales END)) AS Excelsa,
    ROUND(SUM(CASE WHEN CoffeeTypeName = 'Arabica' THEN sales END)) AS Arabica,
    ROUND(SUM(CASE WHEN CoffeeTypeName = 'Liberica' THEN sales END)) AS Liberica
FROM total_sales
GROUP BY OrderYear, OrderMonth
ORDER BY OrderYear, OrderMonth;

-- Sales over time
SELECT
    R.OrderYear,
    R.OrderMonth,
    ROUND(
        SUM(
            CASE
                WHEN R.CoffeeTypeName = 'Robusta' THEN R.sales
            END
        )
    ) AS Robusta,
    ROUND(
        SUM(
            CASE
                WHEN R.CoffeeTypeName = 'Excelsa' THEN R.sales
            END
        )
    ) AS Excelsa,
    ROUND(
        SUM(
            CASE
                WHEN R.CoffeeTypeName = 'Arabica' THEN R.sales
            END
        )
    ) AS Arabica,
    ROUND(
        SUM(
            CASE
                WHEN R.CoffeeTypeName = 'Liberica' THEN R.sales
            END
        )
    ) AS Liberica
FROM
    (
        SELECT
            DATE_FORMAT(O.order_date, '%m') AS OrderMonth,
            DATE_FORMAT(O.order_date, '%Y') AS OrderYear,
            CASE
                WHEN P.coffee_type = 'Rob' THEN 'Robusta'
                WHEN P.coffee_type = 'Exc' THEN 'Excelsa'
                WHEN P.coffee_type = 'Ara' THEN 'Arabica'
                ELSE 'Liberica'
            END AS CoffeeTypeName,
            (O.quantity * P.unit_price) AS sales
        FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
        ON O.customer_id = C.customer_id AND O.product_id = P.product_id
    ) AS R
GROUP BY R.OrderYear, R.OrderMonth
ORDER BY R.OrderYear, R.OrderMonth;

-- Sales by country
SELECT R.country AS 'Country', ROUND(SUM(sales)) AS SumOfSales
FROM
    (
        SELECT C.country, (O.quantity * P.unit_price) AS sales
        FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
        ON O.customer_id = C.customer_id AND O.product_id = P.product_id
    ) AS R
GROUP BY R.country
ORDER BY R.country;


-- Top 5 Customers by Sales
SELECT R.customer_name AS CustomerName, ROUND(SUM(R.sales)) AS SumOfSales
FROM
    (
        SELECT C.customer_name, (O.quantity * P.unit_price) AS sales
        FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
        ON O.customer_id = C.customer_id AND O.product_id = P.product_id
    ) AS R
GROUP BY R.customer_name
ORDER BY  SumOfSales DESC
LIMIT 5;
