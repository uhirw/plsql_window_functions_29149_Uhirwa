CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(50)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    region_id INT REFERENCES regions(region_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    sale_date DATE,
    quantity INT,
    total_amount NUMERIC(10,2)
);

INSERT INTO regions (region_name) VALUES
('Kigali'),
('Southern'),
('Northern'),
('Western');

INSERT INTO customers (first_name, last_name, region_id) VALUES
('Jean', 'Ndayishimiye', 1),
('Aline', 'Mukamana', 2),
('Eric', 'Uwimana', 1),
('Maria', 'Lopez', 3),
('Paul', 'Smith', 4),
('Chantal', 'Umutoni', 2);

INSERT INTO products (product_name, price) VALUES
('Laptop', 850.00),
('Smartphone', 450.00),
('Headphones', 60.00),
('Printer', 200.00),
('Tablet', 300.00);

INSERT INTO sales (customer_id, product_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2024-01-10', 1, 850.00),
(2, 2, '2024-01-15', 2, 900.00),
(3, 3, '2024-02-05', 3, 180.00),
(1, 2, '2024-02-20', 1, 450.00),
(4, 5, '2024-03-12', 2, 600.00),
(5, 4, '2024-03-25', 1, 200.00);
