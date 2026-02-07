SELECT
    s.sale_id,
    c.first_name,
    c.last_name,
    p.product_name,
    s.total_amount
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id;

SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

SELECT
    p.product_id,
    p.product_name
FROM sales s
RIGHT JOIN products p ON s.product_id = p.product_id
WHERE s.sale_id IS NULL;

SELECT
    c.first_name,
    p.product_name,
    s.sale_id
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id
FULL OUTER JOIN products p ON s.product_id = p.product_id;

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
