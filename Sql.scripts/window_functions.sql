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

SELECT
    sale_date,
    SUM(total_amount) AS daily_sales,
    SUM(SUM(total_amount)) OVER (
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

SELECT
    sale_date,
    SUM(total_amount) AS daily_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY sale_date) AS previous_sales
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

SELECT
    c.customer_id,
    c.first_name,
    SUM(s.total_amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(s.total_amount)) AS spending_quartile
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name;

SELECT
    sale_date,
    SUM(total_amount) AS daily_sales,
    AVG(SUM(total_amount)) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM sales
GROUP BY sale_date
ORDER BY sale_date;
