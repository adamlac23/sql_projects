WITH base AS (
  SELECT
      YEAR(OrderDate) AS [Year],
      MONTH(OrderDate) AS [Month],
      Quantity * UnitPrice * (1 - ISNULL(Discount,0)) AS Revenue,
      (Quantity * UnitPrice * (1 - ISNULL(Discount,0)) - ISNULL(ShippingCost,0))     AS GrossProfit
  FROM Orders
)
SELECT
    [Year],
    [Month],
    SUM(Revenue) AS TotalRevenue,
    SUM(GrossProfit) AS TotalGrossProfit,
    CASE WHEN SUM(Revenue)=0 THEN 0
         ELSE ROUND(SUM(GrossProfit)*1.0/SUM(Revenue), 3) END AS ProfitMargin
FROM base
GROUP BY [Year], [Month]
ORDER BY [Year], [Month];
