# Data Analysis On CoffeeSalesDataset

Analyzing a Coffee Sales dataset that can be approached using Excel for data manipulation and basic visualization, Power BI for data visualization and interactive dashboard creation, and using SQL for data querying. Here is how each tool can be utilized in the analysis process:

## Coffee Sales Dashboard using Excel
![Screenshot (55)](https://github.com/yaminitulabandula/CoffeeSalesDashboard/assets/113737709/22daa913-0806-4ffe-b75e-400ce2ca1108)


## Coffee Sales Dashboard using PowerBI
![Screenshot (56)](https://github.com/yaminitulabandula/CoffeeSalesDashboard/assets/113737709/86febe9b-f94c-4afd-86ca-4c20c8cf3a5c)

## Data Analysis using SQL
###### Sales over time
```
mysql> WITH total_sales AS ( 
    ->     SELECT
    ->             DATE_FORMAT(O.order_date, '%m') AS OrderMonth, DATE_FORMAT(O.order_date, '%Y') AS OrderYear,
    ->             CASE
    ->                 WHEN P.coffee_type = 'Rob' THEN 'Robusta'
    ->                 WHEN P.coffee_type = 'Exc' THEN 'Excelsa'
    ->                 WHEN P.coffee_type = 'Ara' THEN 'Arabica'
    ->                 ELSE 'Liberica'
    ->             END AS CoffeeTypeName,
    ->             (O.quantity * P.unit_price) AS sales
    ->     FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
    ->     ON O.customer_id = C.customer_id AND O.product_id = P.product_id
    -> )
    -> SELECT
    ->     OrderYear, OrderMonth,
    ->     ROUND(SUM(CASE WHEN CoffeeTypeName = 'Robusta' THEN sales END)) AS Robusta,
    ->     ROUND(SUM(CASE WHEN CoffeeTypeName = 'Excelsa' THEN sales END)) AS Excelsa,
    ->     ROUND(SUM(CASE WHEN CoffeeTypeName = 'Arabica' THEN sales END)) AS Arabica,
    ->     ROUND(SUM(CASE WHEN CoffeeTypeName = 'Liberica' THEN sales END)) AS Liberica
    -> FROM total_sales
    -> GROUP BY OrderYear, OrderMonth
    -> ORDER BY OrderYear, OrderMonth;
```
```
+-----------+------------+---------+---------+---------+----------+
| OrderYear | OrderMonth | Robusta | Excelsa | Arabica | Liberica |
+-----------+------------+---------+---------+---------+----------+
| 2019      | 01         |     123 |     306 |     187 |      213 |
| 2019      | 02         |     172 |     129 |     252 |      434 |
| 2019      | 03         |     126 |     349 |     225 |      321 |
| 2019      | 04         |     159 |     681 |     307 |      534 |
| 2019      | 05         |      68 |      83 |      54 |      194 |
| 2019      | 06         |     372 |     678 |     163 |      171 |
| 2019      | 07         |     201 |     274 |     345 |      184 |
| 2019      | 08         |     166 |      71 |     335 |      134 |
| 2019      | 09         |     493 |     166 |     179 |      439 |
| 2019      | 10         |     214 |     154 |     302 |      216 |
| 2019      | 11         |      96 |      63 |     313 |      351 |
| 2019      | 12         |     211 |     527 |     266 |      187 |
| 2020      | 01         |     179 |      66 |      47 |      275 |
| 2020      | 02         |     430 |     429 |     745 |      194 |
| 2020      | 03         |     232 |     271 |     130 |      281 |
| 2020      | 04         |     240 |     347 |      27 |      148 |
| 2020      | 05         |      59 |     542 |     255 |       83 |
| 2020      | 06         |     141 |     357 |     585 |      355 |
| 2020      | 07         |     415 |     227 |     431 |      236 |
| 2020      | 08         |     140 |      78 |      22 |       61 |
| 2020      | 09         |     303 |     195 |     126 |       89 |
| 2020      | 10         |     174 |     523 |     376 |      441 |
| 2020      | 11         |     104 |     143 |     515 |      347 |
| 2020      | 12         |      77 |     485 |      96 |       94 |
| 2021      | 01         |     160 |     140 |     258 |      280 |
| 2021      | 02         |      81 |     284 |     342 |      252 |
| 2021      | 03         |     253 |     468 |     418 |      405 |
| 2021      | 04         |     106 |     242 |     102 |      555 |
| 2021      | 05         |     273 |     133 |     235 |      267 |
| 2021      | 06         |      88 |     136 |     430 |      210 |
| 2021      | 07         |     199 |     394 |     109 |       61 |
| 2021      | 08         |     374 |     289 |     288 |      126 |
| 2021      | 09         |     221 |     410 |     841 |      171 |
| 2021      | 10         |     256 |     260 |     299 |      585 |
| 2021      | 11         |     189 |     566 |     323 |      538 |
| 2021      | 12         |     212 |     148 |     399 |      388 |
| 2022      | 01         |     147 |     166 |     113 |      844 |
| 2022      | 02         |      54 |     134 |     115 |       91 |
| 2022      | 03         |     400 |     175 |     278 |      463 |
| 2022      | 04         |     200 |     290 |     198 |       89 |
| 2022      | 05         |     304 |     212 |     193 |      292 |
| 2022      | 06         |     379 |     426 |     180 |      170 |
| 2022      | 07         |     142 |     247 |     247 |      271 |
| 2022      | 08         |      71 |      41 |     116 |       16 |
+-----------+------------+---------+---------+---------+----------+
44 rows in set (0.01 sec)
```

###### Sales by country
```
mysql> SELECT R.country AS 'Country', ROUND(SUM(sales)) AS SumOfSales
    -> FROM
    ->     (
    ->         SELECT C.country, (O.quantity * P.unit_price) AS sales
    ->         FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
    ->         ON O.customer_id = C.customer_id AND O.product_id = P.product_id
    ->     ) AS R
    -> GROUP BY R.country
    -> ORDER BY R.country;
```
```
+----------------+------------+
| Country        | SumOfSales |
+----------------+------------+
| Ireland        |       6697 |
| United Kingdom |       2799 |
| United States  |      35639 |
+----------------+------------+
3 rows in set (0.01 sec)
```

###### Top 5 Customers by Sales
```
mysql> SELECT R.customer_name AS CustomerName, ROUND(SUM(R.sales)) AS SumOfSales
    -> FROM
    ->     (
    ->         SELECT C.customer_name, (O.quantity * P.unit_price) AS sales
    ->         FROM orders AS O INNER JOIN customers AS C INNER JOIN products AS P
    ->         ON O.customer_id = C.customer_id AND O.product_id = P.product_id
    ->     ) AS R
    -> GROUP BY R.customer_name
    -> ORDER BY  SumOfSales DESC
    -> LIMIT 5;
```
```
+-----------------+------------+
| CustomerName    | SumOfSales |
+-----------------+------------+
| Allis Wilmore   |        317 |
| Brenn Dundredge |        307 |
| Terri Farra     |        289 |
| Nealson Cuttler |        282 |
| Don Flintiff    |        278 |
+-----------------+------------+
5 rows in set (0.01 sec)
```


This dashboard provides a comprehensive overview of coffee sales data, presenting trends, volumes, and key metrics that drive business decisions for a coffee retailer. The data is represented through various interactive elements, allowing for a granular analysis of sales performance over time, by country, and customer purchasing behavior.

## Interactive Filters

The dashboard features interactive filters that allow users to refine the data displayed:

- **Order Date:** A timeline filter from January 2019 to January 2020, enabling the selection of specific months for data inspection.
- **Roast Type Name:** Options to filter by the type of coffee roast, including Dark, Light, and Medium.
- **Size:** Filters for the package size, ranging from small packets (0.2 Kg) to larger bags (2.5 Kg).
- **Loyalty Card:** A toggle to differentiate between sales made to loyalty card holders and regular customers.

## Sales Analysis

### Total Sales Over Time

A multi-line chart illustrates the monthly sales figures for different coffee types:

- **Arabica:** Represented by a blue line.
- **Excelsa:** Represented by an orange line.
- **Liberica:** Represented by a gray line.
- **Robusta:** Represented by a yellow line.

The chart spans from January 2019 to July 2022, showing fluctuations in sales with certain months experiencing significant peaks indicative of high demand or successful marketing campaigns.

### Sales By Country

A horizontal bar chart displays the total sales broken down by country, highlighting the market share and sales volume in:

- **United States:** Leading with significant sales, a clear indicator of a strong customer base.
- **Ireland:** Showing moderate sales figures.
- **United Kingdom:** The smallest sales volume among the three, which may suggest room for growth or increased marketing efforts.

### Top 5 Customers By Sales

A vertical bar chart identifies the top five customers contributing to sales. This ranking helps in recognizing the most valuable customers and understanding individual buyer behavior.

1. **Allis Wilmore**
2. **Brenn Dundredge**
3. **Terri Farra**
4. **Nealson Cuttler**
5. **Don Flintiff**

Each customer's contribution to sales is denoted by the length of the bar, with labels indicating the exact sales figures.

## Conclusion

The Coffee Sales Dashboard serves as an essential tool for monitoring sales performance, understanding customer preferences, and making informed decisions for future business strategies. By providing a clear visual representation of key data points, the dashboard empowers business users to identify trends, capitalize on opportunities, and address challenges within the coffee market.

