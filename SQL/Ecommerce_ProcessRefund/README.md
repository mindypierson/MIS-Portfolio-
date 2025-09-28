# Ecommerce_ProcessRefund

Stored procedure to process a line-item refund:
- Validates order, item, and refundable quantity
- Creates a negative payment record (refund)
- Inserts an inventory transaction to add stock back
- Updates order status to `refunded` or `partial_refund` as appropriate

## How to run
1. Ensure `Ecommerce_Core` schema is created and seeded.
2. Run `ProcessRefund.sql` to create the procedure.
3. Execute:
   ```sql
   EXEC dbo.ProcessRefund @OrderID = 1, @OrderItemID = 2, @RefundQty = 1, @Reason = 'customer_return';

SELECT * FROM dbo.Payments WHERE OrderID = 1 ORDER BY PaymentID DESC;
SELECT * FROM dbo.InventoryTransactions WHERE RelatedOrderID = 1 ORDER BY InventoryTxnID DESC;
SELECT OrderID, OrderStatus FROM dbo.Orders WHERE OrderID = 1;
