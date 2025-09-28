-- SampleData.sql
INSERT INTO dbo.Customers (Email, FirstName, LastName)
VALUES ('ali@example.com','Ali','Rivera'),('ben@example.com','Ben','Nguyen');

INSERT INTO dbo.Products (SKU, Title, Price)
VALUES ('SKU-TEE-001','Graphic Tee',24.99),
       ('SKU-CAP-010','Dad Cap',19.50);

-- Opening inventory
INSERT INTO dbo.InventoryTransactions (ProductID, QtyChange, Reason) VALUES
(1, 100, 'purchase'), (2, 80, 'purchase');

-- Create an order (header)
INSERT INTO dbo.Orders (CustomerID, OrderStatus, ShippingAmount, TaxAmount)
VALUES (1, 'open', 5.00, 0.00);

DECLARE @OrderID INT = SCOPE_IDENTITY();

-- Add items
INSERT INTO dbo.OrderItems (OrderID, ProductID, Qty, UnitPrice)
VALUES (@OrderID, 1, 2, 24.99), (@OrderID, 2, 1, 19.50);

-- Compute subtotal
UPDATE o
SET Subtotal = x.SumLines
FROM dbo.Orders o
JOIN (
  SELECT OrderID, SUM(LineSubtotal) AS SumLines
  FROM dbo.OrderItems GROUP BY OrderID
) x ON x.OrderID = o.OrderID
WHERE o.OrderID = @OrderID;

-- Record sale inventory out
INSERT INTO dbo.InventoryTransactions (ProductID, QtyChange, Reason, RelatedOrderID)
SELECT ProductID, -Qty, 'sale', @OrderID
FROM dbo.OrderItems WHERE OrderID = @OrderID;

-- Mark paid
UPDATE dbo.Orders SET OrderStatus='paid', PaidAt=SYSUTCDATETIME(), TaxAmount = Subtotal * 0.08 WHERE OrderID=@OrderID;

INSERT INTO dbo.Payments (OrderID, PaymentType, Amount) SELECT @OrderID, 'capture', TotalAmount FROM dbo.Orders WHERE OrderID=@OrderID;
