-- Top products by revenue
SELECT TOP 5 p.SKU, p.Title, SUM(oi.LineSubtotal) AS Revenue
FROM dbo.OrderItems oi
JOIN dbo.Orders o ON o.OrderID = oi.OrderID AND o.OrderStatus IN ('paid','fulfilled')
JOIN dbo.Products p ON p.ProductID = oi.ProductID
GROUP BY p.SKU, p.Title
ORDER BY Revenue DESC;

-- Customers with highest lifetime spend
SELECT c.Email, c.FirstName, c.LastName, SUM(o.TotalAmount) AS LTV
FROM dbo.Customers c
JOIN dbo.Orders o ON o.CustomerID = c.CustomerID AND o.OrderStatus IN ('paid','fulfilled')
GROUP BY c.Email, c.FirstName, c.LastName
ORDER BY LTV DESC;

-- Inventory on hand
SELECT * FROM dbo.vw_InventoryOnHand ORDER BY SKU;

-- Daily sales trend
SELECT * FROM dbo.vw_DailySales ORDER BY SaleDate DESC;
