-- Ecommerce_Core_DDL.sql
-- Author: Mindy Pierson

-- Customers
CREATE TABLE dbo.Customers (
  CustomerID       INT IDENTITY(1,1) PRIMARY KEY,
  Email            VARCHAR(255) UNIQUE NOT NULL,
  FirstName        VARCHAR(100) NOT NULL,
  LastName         VARCHAR(100) NOT NULL,
  CreatedAt        DATETIME2    NOT NULL DEFAULT SYSUTCDATETIME(),
  IsActive         BIT          NOT NULL DEFAULT 1
);

-- Products
CREATE TABLE dbo.Products (
  ProductID        INT IDENTITY(1,1) PRIMARY KEY,
  SKU              VARCHAR(64) UNIQUE NOT NULL,
  Title            VARCHAR(255) NOT NULL,
  Price            DECIMAL(12,2) NOT NULL CHECK (Price >= 0),
  IsActive         BIT           NOT NULL DEFAULT 1,
  CreatedAt        DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Orders (header)
CREATE TABLE dbo.Orders (
  OrderID          INT IDENTITY(1,1) PRIMARY KEY,
  CustomerID       INT NOT NULL FOREIGN KEY REFERENCES dbo.Customers(CustomerID),
  OrderStatus      VARCHAR(32) NOT NULL DEFAULT 'open', -- open, paid, fulfilled, cancelled, refunded, partial_refund
  Subtotal         DECIMAL(12,2) NOT NULL DEFAULT 0,
  TaxAmount        DECIMAL(12,2) NOT NULL DEFAULT 0,
  ShippingAmount   DECIMAL(12,2) NOT NULL DEFAULT 0,
  TotalAmount      AS (Subtotal + TaxAmount + ShippingAmount) PERSISTED,
  CreatedAt        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  PaidAt           DATETIME2 NULL
);

-- Order items (lines)
CREATE TABLE dbo.OrderItems (
  OrderItemID      INT IDENTITY(1,1) PRIMARY KEY,
  OrderID          INT NOT NULL FOREIGN KEY REFERENCES dbo.Orders(OrderID),
  ProductID        INT NOT NULL FOREIGN KEY REFERENCES dbo.Products(ProductID),
  Qty              INT NOT NULL CHECK (Qty > 0),
  UnitPrice        DECIMAL(12,2) NOT NULL CHECK (UnitPrice >= 0),
  LineSubtotal     AS (Qty * UnitPrice) PERSISTED
);

-- Payments
CREATE TABLE dbo.Payments (
  PaymentID        INT IDENTITY(1,1) PRIMARY KEY,
  OrderID          INT NOT NULL FOREIGN KEY REFERENCES dbo.Orders(OrderID),
  PaymentType      VARCHAR(32) NOT NULL, -- auth, capture, refund
  Amount           DECIMAL(12,2) NOT NULL CHECK (Amount >= 0),
  CreatedAt        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Fulfillments (shipments)
CREATE TABLE dbo.Fulfillments (
  FulfillmentID    INT IDENTITY(1,1) PRIMARY KEY,
  OrderID          INT NOT NULL FOREIGN KEY REFERENCES dbo.Orders(OrderID),
  Carrier          VARCHAR(64) NULL,
  TrackingNumber   VARCHAR(64) NULL,
  ShippedAt        DATETIME2 NULL
);

-- Inventory movements (append-only)
CREATE TABLE dbo.InventoryTransactions (
  InventoryTxnID   INT IDENTITY(1,1) PRIMARY KEY,
  ProductID        INT NOT NULL FOREIGN KEY REFERENCES dbo.Products(ProductID),
  QtyChange        INT NOT NULL, -- +inbound, -outbound
  Reason           VARCHAR(32) NOT NULL, -- purchase, sale, refund, adjustment
  RelatedOrderID   INT NULL,
  CreatedAt        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Helper view: Inventory on Hand
CREATE VIEW dbo.vw_InventoryOnHand AS
SELECT p.ProductID, p.SKU, p.Title,
       SUM(t.QtyChange) AS OnHand
FROM dbo.Products p
LEFT JOIN dbo.InventoryTransactions t ON t.ProductID = p.ProductID
GROUP BY p.ProductID, p.SKU, p.Title;

-- Helper view: Daily Sales (paid orders)
CREATE VIEW dbo.vw_DailySales AS
SELECT CONVERT(date, o.PaidAt) AS SaleDate,
       SUM(o.Subtotal) AS Subtotal,
       SUM(o.TaxAmount) AS TaxAmount,
       SUM(o.ShippingAmount) AS ShippingAmount,
       SUM(o.TotalAmount) AS Total
FROM dbo.Orders o
WHERE o.PaidAt IS NOT NULL
GROUP BY CONVERT(date, o.PaidAt);
