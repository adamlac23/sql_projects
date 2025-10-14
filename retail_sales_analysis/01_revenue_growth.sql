WITH monthly AS (
  SELECT
      YEAR(OrderDate) AS [Year],
      MONTH(OrderDate) AS [Month],
      SUM(Quantity * UnitPrice * (1 - ISNULL(Discount,0))) AS Revenue
  FROM Orders
  GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT
    m.[Year],
    m.[Month],
    m.Revenue,
    LAG(m.Revenue) OVER(ORDER BY m.[Year], m.[Month]) AS PrevMonthRevenue,
    LAG(m.Revenue, 12) OVER(ORDER BY m.[Year], m.[Month]) AS PrevYearRevenue,
    CASE WHEN LAG(m.Revenue) OVER(ORDER BY m.[Year], m.[Month]) = 0 THEN NULL
         ELSE ROUND( (m.Revenue - LAG(m.Revenue) OVER(ORDER BY m.[Year], m.[Month]))
                      *100.0 / NULLIF(LAG(m.Revenue) OVER(ORDER BY m.[Year], m.[Month]),0), 2) END AS MoM_GrowthPct,
    CASE WHEN LAG(m.Revenue,12) OVER(ORDER BY m.[Year], m.[Month]) = 0 THEN NULL
         ELSE ROUND( (m.Revenue - LAG(m.Revenue,12) OVER(ORDER BY m.[Year], m.[Month]))
                      *100.0 / NULLIF(LAG(m.Revenue,12) OVER(ORDER BY m.[Year], m.[Month]),0), 2) END AS YoY_GrowthPct
FROM monthly m
ORDER BY m.[Year], m.[Month];