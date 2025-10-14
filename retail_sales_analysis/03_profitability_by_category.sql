SELECT
    P.Category,
    P.SubCategory,
    SUM(Quantity * UnitPrice * (1 - ISNULL(Discount,0))) AS Revenue,
    SUM((Quantity * UnitPrice * (1 - ISNULL(Discount,0))) - ISNULL(ShippingCost,0)) AS GrossProfit,
    CASE WHEN SUM(Quantity * UnitPrice * (1 - ISNULL(Discount,0))) = 0 THEN 0
         ELSE ROUND(
              SUM((Quantity*UnitPrice*(1-ISNULL(Discount,0))) - ISNULL(ShippingCost,0))
              *1.0 / SUM(Quantity*UnitPrice*(1-ISNULL(Discount,0))), 3) END AS ProfitMargin
FROM Orders O
JOIN Products P ON P.ProductID = O.ProductID
GROUP BY P.Category, P.SubCategory
ORDER BY GrossProfit DESC;
