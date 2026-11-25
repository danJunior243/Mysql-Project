CREATE TABLE customers (
    customer_id  SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) UNIQUE,
    city         VARCHAR(50),
    country      VARCHAR(50),
    signup_date  DATE DEFAULT CURRENT_DATE,
    is_vip       BOOLEAN DEFAULT FALSE
);

CREATE TABLE categories (
    category_id  SERIAL PRIMARY KEY,
    name         VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    category_id  INT REFERENCES categories(category_id),
    price        NUMERIC(10,2),
    stock        INT DEFAULT 0,
    is_active    BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers(customer_id),
    order_date   DATE DEFAULT CURRENT_DATE,
    status       VARCHAR(20)   -- 'pending', 'shipped', 'delivered', 'cancelled'
);

CREATE TABLE order_items (
    order_id     INT REFERENCES orders(order_id),
    product_id   INT REFERENCES products(product_id),
    quantity     INT,
    unit_price   NUMERIC(10,2),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE reviews (
    review_id    SERIAL PRIMARY KEY,
    product_id   INT REFERENCES products(product_id),
    customer_id  INT REFERENCES customers(customer_id),
    rating       INT CHECK (rating BETWEEN 1 AND 5)
);

INSERT INTO customers (full_name, email, city, country, signup_date, is_vip) VALUES
('Alice Martin', 'alice@mail.com', 'Toronto',   'Canada', '2024-01-15', TRUE),
('Bob Tremblay', 'bob@mail.com',   'Montreal',  'Canada', '2024-06-02', FALSE),
('Chloe Dupont', 'chloe@mail.com', 'Paris',     'France', '2025-02-20', FALSE),
('David Kim',    'david@mail.com', 'Vancouver', 'Canada', '2025-09-10', TRUE),
('Emma Rossi',   'emma@mail.com',  'Rome',      'Italy',  '2026-03-05', FALSE);

INSERT INTO categories (name) VALUES ('Laptops'), ('Phones'), ('Books'), ('Accessories');

INSERT INTO products (name, category_id, price, stock, is_active) VALUES
('UltraBook 14',     1, 1200.00, 10,  TRUE),
('Raptor X Gaming',  1, 2200.00, 3,   TRUE),
('Pixel Phone',      2, 800.00,  0,   TRUE),
('Old Phone Model',  2, 300.00,  5,   FALSE),
('SQL Mastery',      3, 45.00,   50,  TRUE),
('The Long Night',   3, 20.00,   100, TRUE),
('USB-C Cable',      4, 15.00,   200, TRUE),
('Wireless Mouse',   4, 35.00,   0,   TRUE);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-10-01', 'delivered'),
(1, '2026-11-10', 'shipped'),
(2, '2026-10-15', 'cancelled'),
(3, '2026-11-01', 'pending'),
(4, '2026-09-20', 'delivered'),
(3, '2026-11-15', 'delivered');

INSERT INTO order_items VALUES
(1, 1, 1, 1200.00), (1, 5, 2, 45.00),
(2, 6, 3, 20.00),   (2, 7, 2, 15.00),
(3, 3, 1, 800.00),
(4, 5, 1, 45.00),   (4, 6, 2, 20.00),
(5, 2, 1, 2200.00),
(6, 7, 4, 15.00),   (6, 8, 1, 35.00);

INSERT INTO reviews (product_id, customer_id, rating) VALUES
(1, 1, 5), (5, 1, 4), (5, 3, 5), (2, 4, 3), (6, 1, 2), (7, 3, 4);


SELECT * FROM customers;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM reviews;


/*Create a view v_customer_contacts that shows only the full_name and email of all customers.*/




CREATE OR REPLACE VIEW v_customer_contacts AS
SELECT full_name,email
FROM customers;

SELECT * 
FROM v_customer_contacts;

/*Create a view v_canadian_customers that shows the name and city of customers in Canada.*/
CREATE  VIEW v_canadian_customers AS
SELECT full_name,city
FROM customers
WHERE country='Canada';

SELECT * 
FROM v_canadian_customers;


/*Create a view v_vip_customers that shows all the columns for VIP customers only*/

CREATE VIEW v_vip_customers AS
SELECT *
FROM customers
WHERE is_vip=true;

SELECT *
FROM v_vip_customers;

/*Create a view v_cheap_products that shows the name and price of products under 50*/


CREATE VIEW v_cheap_products AS
SELECT name,price
FROM products
WHERE price < 50;

SELECT *
FROM v_cheap_products;

/*Create a view v_out_of_stock that shows the active products with stock 0.*/

CREATE VIEW v_out_of_stock AS
SELECT name
FROM products
WHERE is_active=true AND stock =0;

SELECT *
FROM v_out_of_stock;

/*Create a view v_delivered_orders that shows only delivered orders.*/
CREATE VIEW v_delivered_orders AS
SELECT *
FROM orders
WHERE status ='delivered';

SELECT *
FROM v_delivered_orders;

/*Use v_canadian_customers to find the customers in Toronto.*/

SELECT *
FROM v_canadian_customers
WHERE city='Toronto';

/*Use v_cheap_products to find the cheapest product.*/

SELECT *
FROM v_cheap_products
ORDER BY price ASC
LIMIT 1;

/*Use v_vip_customers to count how many VIP customers there are*/

SELECT COUNT(*)
FROM v_vip_customers;

/*Use v_delivered_orders to show the delivered orders placed in November 2026*/

SELECT *
FROM v_delivered_orders
WHERE order_date >= '2026-11-01' AND order_date < '2026-12-01';

/*Delete v_customer_contacts with DROP VIEW, then create it again with the city column added*/
DROP VIEW v_customer_contacts;

DROP VIEW v_canadian_customers;
CREATE OR REPLACE VIEW v_customer_contacts AS
SELECT full_name,email,city
FROM customers;

/*Create a view v_prices_with_tax that shows each product’s name, its price, and a column price_with_tax (price × 1.13), rounded to 2 decimals.*/

CREATE VIEW v_prices_with_tax AS
SELECT name,price,ROUND(price *1.13,2) AS price_with_tax
FROM products;

SELECT *
FROM v_prices_with_tax;

/*Create a view v_order_lines that shows order_id, product_id, quantity, unit_price and line_total (quantity × unit_price).*/
CREATE VIEW v_order_lines AS
SELECT order_id,product_id,
         quantity,
		 unit_price,
		 (quantity*unit_price) AS line_total
FROM order_items;

SELECT * 
FROM v_order_lines;

/*Create a view v_customer_location that shows each customer’s name and one column location like Toronto, Canada.*/
DROP VIEW v_customer_location ;
CREATE  VIEW v_customer_location AS
SELECT full_name, city || ', ' || country AS location
FROM customers;

SELECT * 
FROM v_customer_location;

/*Create a view v_stock_status that shows each product’s name, its stock, and a column that says 'Out of stock' if stock is 0, 
Low' if stock is under 10, and 'OK' otherwise. (Use CASE WHEN.)*/

DROP VIEW v_stock_status;
CREATE  VIEW v_stock_status AS
SELECT name,stock,
       CASE 
	     WHEN stock =0 THEN 'Out of stock'
		 WHEN stock < 10 THEN 'Low'
	   ELSE 
	      'OK'
        END AS stock_status
FROM products;	

SELECT * 
FROM v_stock_status;

/*Create a view v_products_with_category that shows each product’s name, price and category name.*/

CREATE VIEW v_products_with_category AS
SELECT p.name,p.price,c.name AS nom_categorie
FROM products AS p
INNER JOIN categories AS c ON c.category_id =p.category_id;

SELECT * 
FROM v_products_with_category;

/*Create a view v_orders_with_customer that shows the order ID, date, status and customer name.*/
CREATE OR REPLACE VIEW v_orders_with_customer AS
SELECT o.order_id,o.order_date,c.full_name,o.status
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id=o.customer_id;

SELECT *
FROM v_orders_with_customer;


/*Create a view v_review_details that shows the product name, the customer name and the rating.*/

CREATE VIEW v_review_details AS
SELECT p.name,c.full_name,r.rating
FROM reviews AS r
INNER JOIN products AS p ON p.product_id = r.product_id
INNER JOIN customers AS c ON c.customer_id = r.customer_id;

SELECT *
FROM v_review_details;

/*Create a view v_order_full that joins 4 tables to show: order ID, customer name, product name, quantity and line total.*/

CREATE OR REPLACE VIEW v_order_full AS
SELECT o.order_id,
       c.full_name AS customer_name,
       p.name AS product_name,
       oi.quantity,
       oi.quantity * oi.unit_price AS line_total
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON oi.order_id = o.order_id
INNER JOIN products AS p ON p.product_id = oi.product_id;
SELECT *
FROM v_order_full;

/*Use v_review_details to find all the reviews with a rating of 4 or more, sorted by*/
SELECT *
FROM v_review_details
WHERE rating >= 4
ORDER BY rating DESC;

/*Create a view v_orders_per_customer that shows each customer’s name and 
their number of orders. Emma (no orders) should appear with 0. (Hint: LEFT JOIN.)*/
DROP VIEW v_orders_per_customer;
CREATE VIEW v_orders_per_customer AS
SELECT c.customer_id,c.full_name,COUNT(o.order_id) AS numberofOrders
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id=c.customer_id
GROUP BY full_name,c.customer_id;

SELECT *
FROM v_orders_per_customer;

/*Create a view v_category_stats that shows, for each category, the number of products, 
the average price, the cheapest price and the most expensive price.*/
DROP VIEW v_category_stats;
CREATE VIEW v_category_stats AS
SELECT c.name,COUNT(p.product_id) AS nombreofProducts,
     ROUND(AVG(p.price),2) AS averagePrice,
	  MIN(p.price) AS minimumPrice ,
	  MAX(p.price) AS maximumPrice
FROM  categories AS c
INNER JOIN products AS p ON p.category_id = c.category_id
GROUP BY c.name ;

SELECT *
FROM v_category_stats;


/*Create a view v_order_totals that shows each order ID, the customer name, the status and the order total*/
DROP VIEW v_order_totals;
CREATE VIEW v_order_totals AS
SELECT o.order_id,c.full_name AS customer_Name,o.status AS order_Status,SUM(ord.unit_price*ord.quantity) AS order_total
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
INNER JOIN order_items AS ord ON ord.order_id = o.order_id
GROUP BY o.order_id,c.full_name;

SELECT *
FROM v_order_totals;

/*Create a view v_product_ratings that shows each product’s name, its average rating rounded to 1 decimal, and its number of reviews.*/
DROP VIEW v_product_ratings;
CREATE VIEW v_product_ratings AS
SELECT p.name,ROUND(AVG(r.rating),1) AS average_rating,COUNT(review_id) AS nombreofReviews
FROM products AS p
LEFT JOIN reviews AS r ON r.product_id = p.product_id
GROUP BY p.name;

SELECT *
FROM v_product_ratings;


/*Use v_order_totals to find the orders with a total over 100 that weren’t cancelled.*/

SELECT *
FROM v_order_totals
WHERE order_total > 100 AND order_status != 'cancelled';

/*Create a view v_sales_by_category that shows each category’s total revenue, not counting cancelled orders*/
CREATE VIEW v_sales_by_category AS
SELECT c.name,SUM(ord.quantity * unit_price) AS total_revenue
FROM categories AS c
INNER JOIN products AS p ON p.category_id =c.category_id
INNER JOIN order_items AS ord ON ord.product_id = p.product_id
INNER JOIN orders AS o ON o.order_id = ord.order_id
WHERE o.status != 'cancelled'
GROUP BY c.name;

SELECT *
FROM v_sales_by_category;

/*Create a view v_above_avg_products that shows the products whose price is above the average price.*/

CREATE VIEW v_above_avg_products
SELECT p.name







































SELECT * 
FROM v_canadian_customers;



 
























