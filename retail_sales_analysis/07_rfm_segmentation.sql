/*
Cel: segmentacja klientów wg RFM.
Techniki: okna + NTILE(4) -> kwartyle (1=low .. 4=high).
Tabele: Orders(OrderDate, CustomerID, Quantity, UnitPrice, Discount)
*/
WITH rfm AS (
    SELECT
        o.CustomerID,
        DATEDIFF(day, MAX(CAST(o.OrderDate AS date)), CAST(GETDATE() AS date)) AS RecencyDays,
        COUNT(*) AS Frequency,
        SUM(Quantity * UnitPrice * (1 - ISNULL(Discount,0))) AS Monetary
    FROM Orders o
    GROUP BY o.CustomerID
),
scored AS (
    SELECT
        CustomerID,
        RecencyDays,
        Frequency,
        Monetary,
        5 - NTILE(5) OVER (ORDER BY RecencyDays)      AS R_Score,  -- im mniejsza recency tym lepiej
        NTILE(5) OVER (ORDER BY Frequency)            AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary)             AS M_Score
    FROM rfm
)
SELECT
    CustomerID,
    RecencyDays, Frequency, Monetary,
    R_Score, F_Score, M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM,
    CASE
        WHEN R_Score>=4 AND F_Score>=4 AND M_Score>=4 THEN 'Champions'
        WHEN R_Score>=4 AND F_Score>=3 THEN 'Loyal'
        WHEN R_Score<=2 AND F_Score<=2 AND M_Score<=2 THEN 'At Risk'
        ELSE 'Regular'
    END AS Segment
FROM scored
ORDER BY M_Score DESC, F_Score DESC;
