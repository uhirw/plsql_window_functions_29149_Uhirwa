Retail Company is a mid-size retail business operating in East Africa. The Sales and Marketing department needs to analyze sales data to understand product performance, customer behavior, and sales trends over time.
Sales data is stored across multiple related tables, which makes direct analysis difficult.
This project applies SQL JOINs and Window Functions to generate insights that support marketing, sales, and inventory decisions.

INNER JOIN
SELECT
    s.sale_id,
    c.first_name,
    c.last_name,
    p.product_name,
    s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id;

LEFT JOIN 
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

RIGHT JOIN
SELECT
    p.product_id,
    p.product_name,
    s.sale_id
FROM sales s
RIGHT JOIN products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL;

FULL OUTER JOIN
SELECT
    c.first_name,
    p.product_name,
    s.sale_id
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id
FULL OUTER JOIN products p ON s.product_id = p.product_id;

SELF JOIN
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

Ranking functions
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

Aggregate Window Functions
SELECT
    sale_date,
    SUM(total_amount) AS daily_sales,
    SUM(SUM(total_amount)) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

Navigation functions
SELECT
    sale_date,
    SUM(total_amount) AS monthly_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY sale_date) AS previous_month_sales
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

Distribution functions
SELECT
    c.customer_id,
    c.first_name,
    SUM(s.total_amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(s.total_amount)) AS spending_group
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name;


Key Insights

The analysis shows that electronic products generate the highest revenue across regions. Several customers have not made any purchases, indicating potential targets for marketing campaigns. Sales performance varies across different time periods, suggesting seasonal patterns. Customer segmentation reveals clear differences in spending behavior that can be used for targeted promotions.

References

PostgreSQL Official Documentation
PostgreSQL Window Functions Documentation
W3Schools SQL JOINs and Window Functions

Integrity Statement

All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation.

Schema No1 screenshot


![image alt](https://github.com/uhirw/plsql_window_functions_29149_Uhirwa/blob/main/Screenshots/schema1.png)


Schema No2 screenshot


![image alt](https://github.com/uhirw/plsql_window_functions_29149_Uhirwa/blob/main/Screenshots/schema2.png)





