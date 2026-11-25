A collection of SQL projects and practice exercises covering database design, data manipulation, and querying.

Files
File	Description
GestionTransport.sql	Transport management database: schema, sample data, and queries.
HospitalManagement.sql	Hospital management database, including practice with numeric functions.
subquery_practice.sql	29 exercises on subqueries, from basic to advanced.
Subquery Practice

subquery_practice.sql works with a sales/HR style database:

Customers, Orders, OrderDetails, Products, Categories, Employees, Departments

Topics covered:

Scalar subqueries (comparing against AVG, MAX)
IN / NOT IN (including NULL handling)
EXISTS / NOT EXISTS
Correlated subqueries (per-category and per-department comparisons)
Derived tables (subqueries in FROM)
Nth-highest values without LIMIT, TOP, or window functions
Relational division (customers who bought every product in a category)
Multi-condition challenges combining several techniques

How to Use
Clone the repository:
bash
   git clone https://github.com/danJunior243/Mysql-Project.git
Open a .sql file in MySQL Workbench (or any SQL client).
Run the schema and data sections first, then the queries.
Tools
MySQL
MySQL Workbench
Author

danJunior243 – GitHub profile
