WITH daily AS (
    SELECT
        CAST(OrderDate AS date) AS [Date],
        SUM(Quantity*UnitPrice*(1-ISNULL(Discount,0))) AS Revenue
    FROM Orders
    GROUP BY CAST(OrderDate AS date)
),
scored AS (
    SELECT
        [Date],
        Revenue,
        AVG(Revenue) OVER(ORDER BY [Date] ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS mu_30,
        STDEV(Revenue) OVER(ORDER BY [Date] ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS sigma_30
    FROM daily
)
SELECT
    [Date],
    Revenue,
    mu_30,
    sigma_30,
    CASE WHEN sigma_30 IS NULL OR sigma_30 = 0 THEN NULL
         ELSE (Revenue - mu_30) / sigma_30 END AS zscore,
    CASE WHEN sigma_30 > 0 AND ABS((Revenue - mu_30)/sigma_30) >= 3 THEN 1 ELSE 0 END AS IsAnomaly_3sigma
FROM scored
ORDER BY [Date];
