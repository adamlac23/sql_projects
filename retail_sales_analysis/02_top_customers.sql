WITH cust AS (
  SELECT
      O.CustomerID,
      SUM(Quantity * UnitPrice * (1 - ISNULL(Discount,0))) AS Revenue,
      SUM( (Quantity * UnitPrice * (1 - ISNULL(Discount,0))) - ISNULL(ShippingCost,0) ) AS GrossProfit
  FROM Orders O
  GROUP BY O.CustomerID
),
ranked AS (
  SELECT
      C.CustomerName,
      c.Revenue,
      c.GrossProfit,
      CASE WHEN c.Revenue=0 THEN 0 ELSE ROUND(c.GrossProfit*1.0/c.Revenue,3) END AS ProfitMargin,
      RANK() OVER(ORDER BY c.Revenue DESC) AS rnk
  FROM cust c
  JOIN Customers C ON C.CustomerID = c.CustomerID
)
SELECT TOP 10 *
FROM ranked
ORDER BY rnk;
