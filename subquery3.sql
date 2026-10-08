/* =====================================================================
   SQL Subquery Practice
   ---------------------------------------------------------------------
   Topics: scalar subqueries, IN / NOT IN, EXISTS / NOT EXISTS,
           correlated subqueries, derived tables, relational division.
   Dialect: T-SQL (SQL Server)

   Tables: Customers, Orders, OrderDetails, Products, Categories,
           Employees, Departments
   ===================================================================== */


/* ---------------------------------------------------------------------
   0. Explore the data
   --------------------------------------------------------------------- */
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Products;
SELECT * FROM Categories;
SELECT * FROM Employees;
SELECT * FROM Departments;


/* ---------------------------------------------------------------------
   1. Products priced above the average product price
   --------------------------------------------------------------------- */
SELECT *
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);


/* ---------------------------------------------------------------------
   2. Most expensive product
   --------------------------------------------------------------------- */
SELECT *
FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products);


/* ---------------------------------------------------------------------
   3. Customers who placed at least one order
   --------------------------------------------------------------------- */
SELECT *
FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders)
ORDER BY CustomerID;


/* ---------------------------------------------------------------------
   4. Customers with no orders
   Note: NOT IN returns no rows if the subquery contains a NULL,
         so NULLs are filtered out explicitly.
   --------------------------------------------------------------------- */
SELECT *
FROM Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Orders
    WHERE CustomerID IS NOT NULL
)
ORDER BY CustomerID;


/* ---------------------------------------------------------------------
   5. Employees earning above the average salary
   --------------------------------------------------------------------- */
SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
ORDER BY EmployeeID;


/* ---------------------------------------------------------------------
   6. Products more expensive than their category's average
   --------------------------------------------------------------------- */
SELECT *
FROM Products AS p1
WHERE p1.Price > (
    SELECT AVG(p2.Price)
    FROM Products AS p2
    WHERE p2.CategoryID = p1.CategoryID
);


/* ---------------------------------------------------------------------
   7. Customers from countries that have at least one order
   --------------------------------------------------------------------- */
SELECT *
FROM Customers
WHERE Country IN (
    SELECT DISTINCT c2.Country
    FROM Customers AS c2
    INNER JOIN Orders AS o ON o.CustomerID = c2.CustomerID
)
ORDER BY CustomerID;


/* ---------------------------------------------------------------------
   8. Customers with at least one completed order
   --------------------------------------------------------------------- */
SELECT *
FROM Customers AS c
WHERE EXISTS (
    SELECT 1
    FROM Orders AS o
    WHERE o.CustomerID = c.CustomerID
      AND o.Status = 'Completed'
)
ORDER BY c.CustomerID;


/* ---------------------------------------------------------------------
   9. Products that have never been ordered
   --------------------------------------------------------------------- */
SELECT *
FROM Products
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM OrderDetails
    WHERE ProductID IS NOT NULL
)
ORDER BY ProductID;


/* ---------------------------------------------------------------------
   10. Employees in departments that have someone earning > 100,000
   --------------------------------------------------------------------- */
SELECT *
FROM Employees AS e1
WHERE EXISTS (
    SELECT 1
    FROM Employees AS e2
    WHERE e2.DepartmentID = e1.DepartmentID
      AND e2.Salary > 100000.00
)
ORDER BY e1.EmployeeID;


/* ---------------------------------------------------------------------
   11. Departments with at least one employee earning above
       the overall average salary
   --------------------------------------------------------------------- */
SELECT *
FROM Departments AS d
WHERE EXISTS (
    SELECT 1
    FROM Employees AS e
    WHERE e.DepartmentID = d.DepartmentID
      AND e.Salary > (SELECT AVG(Salary) FROM Employees)
);


/* ---------------------------------------------------------------------
   12. Customers with at least one single order over $1,000
   --------------------------------------------------------------------- */
SELECT *
FROM Customers AS c
WHERE EXISTS (
    SELECT 1
    FROM Orders AS o
    WHERE o.CustomerID = c.CustomerID
      AND o.TotalAmount > 1000
);


/* ---------------------------------------------------------------------
   13. Compare every product's price with its category average
   --------------------------------------------------------------------- */
SELECT p1.ProductName,
       p1.Price,
       p1.CategoryID,
       (SELECT AVG(p2.Price)
        FROM Products AS p2
        WHERE p2.CategoryID = p1.CategoryID) AS CategoryAvgPrice,
       p1.Price - (SELECT AVG(p3.Price)
                   FROM Products AS p3
                   WHERE p3.CategoryID = p1.CategoryID) AS DiffFromAvg
FROM Products AS p1
ORDER BY p1.CategoryID, p1.Price DESC;


/* ---------------------------------------------------------------------
   14. Employees earning more than their department's average
   --------------------------------------------------------------------- */
SELECT e1.FirstName,
       e1.LastName,
       e1.Salary,
       e1.DepartmentID
FROM Employees AS e1
WHERE e1.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employees AS e2
    WHERE e2.DepartmentID = e1.DepartmentID
);


/* ---------------------------------------------------------------------
   15. Each customer's highest-value order
   --------------------------------------------------------------------- */
SELECT c.CustomerID,
       o.OrderID,
       o.TotalAmount
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount = (
    SELECT MAX(o2.TotalAmount)
    FROM Orders AS o2
    WHERE o2.CustomerID = c.CustomerID
)
ORDER BY c.CustomerID;


/* ---------------------------------------------------------------------
   16. Employees who earn more than their manager
   --------------------------------------------------------------------- */
SELECT e1.FirstName,
       e1.LastName,
       e1.Salary
FROM Employees AS e1
WHERE e1.Salary > (
    SELECT e2.Salary
    FROM Employees AS e2
    WHERE e2.EmployeeID = e1.ManagerID
);


/* ---------------------------------------------------------------------
   17. Most expensive product in each category
   --------------------------------------------------------------------- */
SELECT p1.CategoryID,
       p1.ProductName,
       p1.Price
FROM Products AS p1
WHERE p1.Price = (
    SELECT MAX(p2.Price)
    FROM Products AS p2
    WHERE p2.CategoryID = p1.CategoryID
)
ORDER BY p1.CategoryID;


/* ---------------------------------------------------------------------
   18. Customers whose total spending is above the average total
       spending of all customers who have placed orders
   --------------------------------------------------------------------- */
SELECT c.CustomerID,
       c.FirstName,
       SUM(o.TotalAmount) AS TotalSpent
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName
HAVING SUM(o.TotalAmount) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(o1.TotalAmount) AS CustomerTotal
        FROM Orders AS o1
        GROUP BY o1.CustomerID
    ) AS CustomerTotals
);


/* ---------------------------------------------------------------------
   19. Second-highest salary
   --------------------------------------------------------------------- */
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employees
WHERE Salary < (SELECT MAX(Salary) FROM Employees);


/* ---------------------------------------------------------------------
   20. Third-highest salary
   --------------------------------------------------------------------- */
SELECT MAX(e1.Salary) AS ThirdHighestSalary
FROM Employees AS e1
WHERE e1.Salary < (
    SELECT MAX(e2.Salary)
    FROM Employees AS e2
    WHERE e2.Salary < (SELECT MAX(e3.Salary) FROM Employees AS e3)
);


/* ---------------------------------------------------------------------
   21. Categories whose average price is above the overall average
   --------------------------------------------------------------------- */
SELECT c.CategoryID,
       c.CategoryName,
       AVG(p.Price) AS AvgCategoryPrice
FROM Categories AS c
INNER JOIN Products AS p ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING AVG(p.Price) > (SELECT AVG(Price) FROM Products);


/* ---------------------------------------------------------------------
   22. Customers who bought at least one product priced above
       the overall average product price
   --------------------------------------------------------------------- */
SELECT DISTINCT c.CustomerID,
       c.FirstName
FROM Customers AS c
INNER JOIN Orders       AS o   ON o.CustomerID  = c.CustomerID
INNER JOIN OrderDetails AS od  ON od.OrderID    = o.OrderID
INNER JOIN Products     AS p   ON p.ProductID   = od.ProductID
WHERE p.Price > (SELECT AVG(Price) FROM Products);


/* ---------------------------------------------------------------------
   23. Customers who bought EVERY product in a category (CategoryID = 1)
   Relational division with double NOT EXISTS:
   "there is no product in category 1 that this customer has NOT bought"
   --------------------------------------------------------------------- */
SELECT c.CustomerID,
       c.FirstName
FROM Customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM Products AS p
    WHERE p.CategoryID = 1
      AND NOT EXISTS (
          SELECT 1
          FROM Orders AS o
          INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
          WHERE o.CustomerID = c.CustomerID
            AND od.ProductID = p.ProductID
      )
);


/* ---------------------------------------------------------------------
   24. Customers with more orders than the average number of orders
       per customer (average taken over customers who have ordered)
   --------------------------------------------------------------------- */
SELECT c.CustomerID,
       c.FirstName,
       COUNT(o.OrderID) AS NumberOfOrders
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName
HAVING COUNT(o.OrderID) > (
    SELECT AVG(CAST(OrderCount AS DECIMAL(10, 2)))
    FROM (
        SELECT COUNT(o2.OrderID) AS OrderCount
        FROM Orders AS o2
        GROUP BY o2.CustomerID
    ) AS CustomerOrderCounts
);


/* ---------------------------------------------------------------------
   25. Customers whose most recent order's total is greater than
       their previous order's total
   --------------------------------------------------------------------- */
SELECT c.CustomerID,
       c.FirstName,
       o.TotalAmount             AS MostRecentAmount,
       prevOrder.TotalAmount     AS PreviousAmount
FROM Customers AS c
INNER JOIN Orders AS o ON o.CustomerID = c.CustomerID
INNER JOIN (
    SELECT o1.CustomerID,
           o1.TotalAmount,
           o1.OrderDate
    FROM Orders AS o1
    WHERE o1.OrderDate = (
        SELECT MAX(o2.OrderDate)
        FROM Orders AS o2
        WHERE o2.CustomerID = o1.CustomerID
          AND o2.OrderDate < (
              SELECT MAX(o3.OrderDate)
              FROM Orders AS o3
              WHERE o3.CustomerID = o1.CustomerID
          )
    )
) AS prevOrder ON prevOrder.CustomerID = c.CustomerID
WHERE o.OrderDate = (
    SELECT MAX(o4.OrderDate)
    FROM Orders AS o4
    WHERE o4.CustomerID = c.CustomerID
)
  AND o.TotalAmount > prevOrder.TotalAmount;


/* ---------------------------------------------------------------------
   26. Products never included in an order with status 'Completed'
   --------------------------------------------------------------------- */
SELECT p.ProductName
FROM Products AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderDetails AS od
    INNER JOIN Orders AS o ON o.OrderID = od.OrderID
    WHERE od.ProductID = p.ProductID
      AND o.Status = 'Completed'
);


/* ---------------------------------------------------------------------
   27. Employees whose salary is above their department's average
       but below their department's highest salary
   --------------------------------------------------------------------- */
SELECT e1.EmployeeID,
       e1.FirstName,
       e1.LastName,
       e1.Salary,
       e1.DepartmentID
FROM Employees AS e1
WHERE e1.Salary > (
    SELECT AVG(e2.Salary)
    FROM Employees AS e2
    WHERE e2.DepartmentID = e1.DepartmentID
)
  AND e1.Salary < (
    SELECT MAX(e3.Salary)
    FROM Employees AS e3
    WHERE e3.DepartmentID = e1.DepartmentID
);


/* ---------------------------------------------------------------------
   28. Customer loyalty challenge
   Customers who have:
     - placed at least 3 orders
     - never had a cancelled order
     - spent more than the average customer spending
   --------------------------------------------------------------------- */
SELECT c.CustomerID,
       c.FirstName
FROM Customers AS c
WHERE (
    SELECT COUNT(*)
    FROM Orders AS o1
    WHERE o1.CustomerID = c.CustomerID
) >= 3
  AND NOT EXISTS (
    SELECT 1
    FROM Orders AS o2
    WHERE o2.CustomerID = c.CustomerID
      AND o2.Status = 'Cancelled'
)
  AND (
    SELECT SUM(o3.TotalAmount)
    FROM Orders AS o3
    WHERE o3.CustomerID = c.CustomerID
) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(TotalAmount) AS CustomerTotal
        FROM Orders
        GROUP BY CustomerID
    ) AS CustomerSpending
);


/* ---------------------------------------------------------------------
   29. Second-most expensive product in each category
       (no TOP, LIMIT, or window functions)
   A product is 2nd-most expensive if exactly one distinct price
   in its category is higher than its own.
   --------------------------------------------------------------------- */
SELECT p1.CategoryID,
       p1.ProductName,
       p1.Price
FROM Products AS p1
WHERE 1 = (
    SELECT COUNT(DISTINCT p2.Price)
    FROM Products AS p2
    WHERE p2.CategoryID = p1.CategoryID
      AND p2.Price > p1.Price
)
ORDER BY p1.CategoryID;