Retail Company is a mid-size retail business operating in East Africa. The Sales and Marketing department needs to analyze sales data to understand product performance, customer behavior, and sales trends over time.
Sales data is stored across multiple related tables, which makes direct analysis difficult.
This project applies SQL JOINs and Window Functions to generate insights that support marketing, sales, and inventory decisions.


TABLE1:REGIONS

| Column      | Data Type | Constraints |
| ----------- | --------- | ----------- |
| region_id   | SERIAL    | PRIMARY KEY |
| region_name | VARCHAR   | NOT NULL    |


TABLE2:CUSTOMERS

| Column      | Data Type | Constraints                      |
| ----------- | --------- | -------------------------------- |
| customer_id | SERIAL    | PRIMARY KEY                      |
| first_name  | VARCHAR   | NOT NULL                         |
| last_name   | VARCHAR   | NOT NULL                         |
| region_id   | INT       | FOREIGN KEY → regions(region_id) |


TABKE 3:PRODUCTS

| Column       | Data Type | Constraints |
| ------------ | --------- | ----------- |
| product_id   | SERIAL    | PRIMARY KEY |
| product_name | VARCHAR   | NOT NULL    |
| price        | NUMERIC   | NOT NULL    |


TABLE4:SALES

| Column       | Data Type | Constraints                          |
| ------------ | --------- | ------------------------------------ |
| sale_id      | SERIAL    | PRIMARY KEY                          |
| customer_id  | INT       | FOREIGN KEY → customers(customer_id) |
| product_id   | INT       | FOREIGN KEY → products(product_id)   |
| sale_date    | DATE      | NOT NULL                             |
| total_amount | NUMERIC   | NOT NULL                             |
| quantity     | INT       | NOT NULL                             |



ER DIAGRAM


     +---------+
     | regions |
     +---------+
     |region_id PK|
     |region_name |
     +---------+
          ^
          |
          | 1-to-many
          |
     +-----------+
     | customers |
     +-----------+
     |customer_id PK|
     |first_name    |
     |last_name     |
     |region_id FK  |
     +-----------+
          ^
          | 1-to-many
          |
     +--------+          +---------+
     | sales  |          | products|
     +--------+          +---------+
     |sale_id PK|        |product_id PK|
     |customer_id FK|<---|product_id    |
     |product_id FK|     |product_name  |
     |sale_date    |     |price         |
     |total_amount |     +---------+
     |quantity     |
     +--------+

INNER JOIN
-- Retrieve all sales with valid customer and product details
SELECT
    s.sale_id,
    c.first_name,
    c.last_name,
    p.product_name,
    s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id;

Business interpretation on Inner join
This query returns only sales records that are linked to existing customers and products. It confirms that each transaction is valid and properly connected across tables. This ensures accurate reporting of completed sales.

LEFT JOIN 
-- List customers with no recorded sales
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

Business Interpretation
This query identifies customers who have not made any purchases. In your data, Chantal Umutoni is one such customer. The company can target these inactive customers with promotions.

RIGHT JOIN
-- Find products that have no sales
SELECT
    p.product_id,
    p.product_name,
    s.sale_id
FROM sales s
RIGHT JOIN products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL;

Business Interpretation
This query shows products with no recorded sales. In this dataset, all products have been sold at least once, so no rows appear. It helps management identify underperforming products.

FULL OUTER JOIN
-- Show all customers and products including unmatched sales records
SELECT
    c.first_name,
    p.product_name,
    s.sale_id
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id
FULL OUTER JOIN products p ON s.product_id = p.product_id;

Business Interpretation
This query shows products with no recorded sales. In this dataset, all products have been sold at least once, so no rows appear. It helps management identify underperforming products.

SELF JOIN
-- Compare customers within the same region
SELECT
    c1.first_name,
    c1.last_name,
    c2.first_name,
    c2.last_name,
    c1.region_id
FROM customers c1
JOIN customers c2
ON c1.region_id = c2.region_id
AND c1.customer_id <> c2.customer_id;

Business Interpretation
This query compares customers in the same region. It shows customer clusters for regional analysis. For example, Jean and Eric are in region 1, while Aline and Chantal are in region 2.

Ranking functions
-- Rank products by total revenue within each region
SELECT
    r.region_name,
    p.product_name,
    SUM(s.total_amount) AS revenue,
    RANK() OVER (PARTITION BY r.region_name ORDER BY SUM(s.total_amount) DESC) AS rank_in_region
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
JOIN products p ON s.product_id = p.product_id
GROUP BY r.region_name, p.product_name;

Interpretation
This query ranks products by revenue within each region. For example, in Kigali, Laptop is rank 1 and Smartphone is rank 2. Management can prioritize top products for marketing.

Aggregate Window Functions
-- Calculate running total of sales over time
SELECT
    sale_date,
    SUM(total_amount) AS daily_sales,
    SUM(SUM(total_amount)) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

Interpretation
This query calculates cumulative sales over time. For example, total sales reach 3180 after the last sale. It is useful for tracking growth trends.

Navigation functions
-- Compare each month's sales with previous month's sales
SELECT
    sale_date,
    SUM(total_amount) AS monthly_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY sale_date) AS previous_month_sales
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

Interpretation
This query compares sales with the previous period. It highlights increases or decreases, such as January 15 compared to January 10. It helps assess performance trends.

Distribution functions
-- Divide customers into four spending groups based on total spent
SELECT
    c.customer_id,
    c.first_name,
    SUM(s.total_amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(s.total_amount)) AS spending_group
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name;

Interpretation
This query segments customers into four spending groups. For example, Jean is in group 4 (highest spending), Eric is in group 1 (lowest). This helps target marketing strategies by spending level.

Key Insights

Descriptive Analysis 

The analysis shows that a small number of products generate most of the total sales revenue across regions. Some customers purchase very frequently while others make only occasional purchases. Sales volumes also increase during certain months, indicating seasonal buying behavior.

Diagnostic Analysis 

High-performing products are popular because they are consistently purchased by repeat customers. Regions with higher sales have more active customers and higher transaction frequency. Seasonal trends occur due to promotions and increased demand during specific periods of the year.

Prescriptive Analysis 

The company should focus marketing efforts on top-performing products and high-value customer segments. Promotions can be scheduled during high-growth months to maximize revenue. Low-performing products should be reviewed for pricing, promotion, or possible discontinuation.

References

PostgreSQL Global Development Group. PostgreSQL Documentation.
https://www.postgresql.org/docs/   

Mode Analytics. SQL Window Functions Guide.
https://mode.com/sql-tutorial/sql-window-functions/

W3Schools. SQL JOIN Tutorial.
https://www.w3schools.com/sql/sql_join.asp


Integrity Statement

All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation.

Schema No1 screenshot


![image alt](https://github.com/uhirw/plsql_window_functions_29149_Uhirwa/blob/main/Screenshots/schema1.png)


Schema No2 screenshot


![image alt](https://github.com/uhirw/plsql_window_functions_29149_Uhirwa/blob/main/Screenshots/schema2.png)





