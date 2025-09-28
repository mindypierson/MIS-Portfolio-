**Paste:**
```sql
-- ProcessRefund.sql
-- Author: Mindy Pierson

IF OBJECT_ID('dbo.ProcessRefund','P') IS NOT NULL
  DROP PROCEDURE dbo.ProcessRefund;
GO

CREATE PROCEDURE dbo.ProcessRefund
  @OrderID      INT,
  @OrderItemID  INT,
  @RefundQty    INT,
  @Reason       VARCHAR(64) = 'customer_return'
AS
BEGIN
  SET NOCOUNT ON;

  IF @RefundQty <= 0
  BEGIN
    RAISERROR('RefundQty must be > 0', 16, 1);
    RETURN;
  END

  -- Validate order exists and is paid/fulfilled
  IF NOT EXISTS (SELECT 1 FROM dbo.Orders WHERE OrderID = @OrderID AND OrderStatus IN ('paid','fulfilled','partial_refund'))
  BEGIN
    RAISERROR('Order not found or not refundable state.', 16, 1);
    RETURN;
  END

  -- Get order item info
  DECLARE @ProductID INT, @UnitPrice DECIMAL(12,2), @OrigQty INT;
  SELECT @ProductID = oi.ProductID,
         @UnitPrice = oi.UnitPrice,
         @OrigQty   = oi.Qty
  FROM dbo.OrderItems oi WHERE oi.OrderItemID = @OrderItemID AND oi.OrderID = @OrderID;

  IF @ProductID IS NULL
  BEGIN
    RAISERROR('OrderItem not found for this Order.', 16, 1);
    RETURN;
  END

  -- Compute refundable qty (simplified: assume no prior refunds)
  IF @RefundQty > @OrigQty
  BEGIN
    RAISERROR('RefundQty exceeds original quantity.', 16, 1);
    RETURN;
  END

  -- Refund amount (no tax/shipping proration in this simple demo)
  DECLARE @RefundAmount DECIMAL(12,2) = @RefundQty * @UnitPrice;

  -- Record inventory back in
  INSERT INTO dbo.InventoryTransactions (ProductID, QtyChange, Reason, RelatedOrderID)
  VALUES (@ProductID, @RefundQty, 'refund', @OrderID);

  -- Record negative payment
  INSERT INTO dbo.Payments (OrderID, PaymentType, Amount)
  VALUES (@OrderID, 'refund', @RefundAmount);

  -- Update order status: full vs partial
  -- (Simplified: if refund qty == original qty for the item, flag partial_refund unless all items refunded)
  DECLARE @TotalItems INT, @TotalRefunded INT;

  SELECT @TotalItems = SUM(Qty) FROM dbo.OrderItems WHERE OrderID = @OrderID;

  -- Approximation: treat this refund as items returned; in a fuller model we'd track per-item refund history
  SET @TotalRefunded = 0; -- not tracking cumulative in this demo

  UPDATE dbo.Orders
    SET OrderStatus = CASE
      WHEN @RefundQty = @OrigQty AND @TotalItems = @OrigQty THEN 'refunded' -- very simplified
      ELSE 'partial_refund'
    END
  WHERE OrderID = @OrderID;
END;
GO
