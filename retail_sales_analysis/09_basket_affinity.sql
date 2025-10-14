WITH basket AS (
    SELECT DISTINCT OrderID, ProductID FROM Orders
),
pairs AS (
    SELECT a.ProductID AS A, b.ProductID AS B
    FROM basket a
    JOIN basket b ON b.OrderID = a.OrderID AND b.ProductID > a.ProductID 
),
freq AS (
    SELECT
        A, B,
        COUNT(*) AS AB_cnt
    FROM pairs
    GROUP BY A, B
),
totals AS (
    SELECT ProductID, COUNT(*) AS cnt
    FROM basket
    GROUP BY ProductID
),
orders_cnt AS (SELECT COUNT(DISTINCT OrderID) AS N FROM basket)
SELECT
    f.A, f.B,
    f.AB_cnt,
    tA.cnt AS A_cnt,
    tB.cnt AS B_cnt,
    CAST(f.AB_cnt * 1.0 / o.N AS decimal(8,4)) AS support_AB,
    CAST(f.AB_cnt * 1.0 / tA.cnt AS decimal(8,4)) AS confidence_A_to_B,
    CAST(f.AB_cnt * 1.0 / tB.cnt AS decimal(8,4)) AS confidence_B_to_A,
    CAST((f.AB_cnt * 1.0 / o.N) / ((tA.cnt*1.0/o.N) * (tB.cnt*1.0/o.N)) AS decimal(8,3)) AS lift
FROM freq f
JOIN totals tA ON tA.ProductID = f.A
JOIN totals tB ON tB.ProductID = f.B
JOIN orders_cnt o ON 1=1
WHERE 
    f.AB_cnt >= 10   
ORDER BY 
    lift DESC, f.AB_cnt DESC;
