-- TestRefund.sql (assumes Ecommerce_Core sample data ran and OrderID=1 exists)
DECLARE @OrderID INT = 1;

-- Pick an item to refund (adjust ID if needed)
SELECT TOP 1 @OrderID = o.OrderID
FROM dbo.Orders o WHERE o.OrderStatus IN ('paid','fulfilled') ORDER BY o.OrderID;

DECLARE @OrderItemID INT;
SELECT TOP 1 @OrderItemID = oi.OrderItemID
FROM dbo.OrderItems oi WHERE oi.OrderID = @OrderID;

EXEC dbo.ProcessRefund @OrderID = @OrderID, @OrderItemID = @OrderItemID, @RefundQty = 1, @Reason = 'customer_return';

SELECT * FROM dbo.Payments WHERE OrderID = @OrderID ORDER BY PaymentID DESC;
SELECT * FROM dbo.InventoryTransactions WHERE RelatedOrderID = @OrderID ORDER BY InventoryTxnID DESC;
SELECT OrderID, OrderStatus FROM dbo.Orders WHERE OrderID = @OrderID;
