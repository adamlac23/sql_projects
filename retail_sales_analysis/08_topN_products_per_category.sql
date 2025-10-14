WITH prod_rev AS (
    SELECT
        p.Category,
        p.ProductName,
        SUM(Quantity * UnitPrice * (1 - ISNULL(Discount, 0))) AS Revenue
    FROM Orders o
    JOIN Products p ON p.ProductID = o.ProductID
    GROUP BY p.Category, p.ProductName
),
ranked AS (
    SELECT
        Category, ProductName, Revenue,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Revenue DESC) AS rn
    FROM prod_rev
)
SELECT Category, ProductName, Revenue
FROM ranked
WHERE rn <= 3
ORDER BY Category, Revenue DESC;
