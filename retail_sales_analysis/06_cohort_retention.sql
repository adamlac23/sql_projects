WITH first_order AS (
    SELECT CustomerID, MIN(CAST(OrderDate AS date)) AS FirstOrderDate
    FROM Orders
    GROUP BY CustomerID
),
labeled AS (
    SELECT
        o.CustomerID,
        CAST(o.OrderDate AS date) AS OrderDate,
        DATEFROMPARTS(YEAR(f.FirstOrderDate), MONTH(f.FirstOrderDate), 1) AS CohortMonth,
        DATEDIFF(month,
                 DATEFROMPARTS(YEAR(f.FirstOrderDate), MONTH(f.FirstOrderDate), 1),
                 DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1)) AS PeriodM
    FROM Orders o
    JOIN first_order f ON f.CustomerID = o.CustomerID
),
base AS (
    SELECT CohortMonth, PeriodM, COUNT(DISTINCT CustomerID) AS ActiveCustomers
    FROM labeled
    GROUP BY CohortMonth, PeriodM
),
cohort_size AS (
    SELECT CohortMonth, COUNT(DISTINCT CustomerID) AS CohortCustomers
    FROM labeled
    WHERE PeriodM = 0
    GROUP BY CohortMonth
)
SELECT
    b.CohortMonth,
    b.PeriodM,
    b.ActiveCustomers,
    CAST(b.ActiveCustomers * 1.0 / cs.CohortCustomers AS decimal(5,2)) AS RetentionRate
FROM base b
JOIN cohort_size cs ON cs.CohortMonth = b.CohortMonth
WHERE b.PeriodM BETWEEN 0 AND 12 
ORDER BY b.CohortMonth, b.PeriodM;
