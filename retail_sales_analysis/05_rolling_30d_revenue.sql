WITH dates AS (  
    SELECT MIN(CAST(OrderDate AS date)) AS d, MAX(CAST(OrderDate AS date)) AS maxd
    FROM Orders
), cal AS (
    SELECT d AS [Date], maxd FROM dates
    UNION ALL
    SELECT DATEADD(day, 1, [Date]), maxd FROM cal WHERE [Date] < maxd
), daily AS (
    SELECT
        c.[Date],
        SUM(Quantity * UnitPrice * (1 - ISNULL(Discount,0))) AS DailyRevenue
    FROM cal c
    LEFT JOIN Orders o
      ON CAST(o.OrderDate AS date) = c.[Date]
    GROUP BY c.[Date]
)
SELECT
    [Date],
    DailyRevenue,
    SUM(DailyRevenue) OVER (
        ORDER BY [Date]
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS Rolling30dRevenue
FROM daily
ORDER BY [Date]
