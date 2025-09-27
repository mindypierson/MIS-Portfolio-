-- BuildSaleSummary.sql
-- Author: <Your Name>
-- Purpose: Aggregate line items into a sales summary table.

-- Example base tables (comment out if they already exist)
-- CREATE TABLE SalesHeader (
--   SaleID       INT PRIMARY KEY,
--   CustomerID   INT,
--   SaleDate     DATE,
--   TaxRate      DECIMAL(5,2) -- e.g., 8.5 means 8.5%
-- );
-- CREATE TABLE SalesDetail (
--   SaleID     INT,
--   LineNum    INT,
--   ItemID     INT,
--   Qty        INT,
--   UnitPrice  DECIMAL(10,2),
--   CONSTRAINT PK_SalesDetail PRIMARY KEY (SaleID, LineNum)
-- );
-- CREATE TABLE SalesSummary (
--   SaleID     INT PRIMARY KEY,
--   Subtotal   DECIMAL(12,2),
--   TaxAmount  DECIMAL(12,2),
--   Total      DECIMAL(12,2),
--   CalcDate   DATETIME DEFAULT CURRENT_TIMESTAMP
-- );

-- Stored procedure:
-- Rebuilds/refreshes the summary row for a given SaleID.
-- Notes:
--  • Validates that the SaleID exists.
--  • Calculates subtotal from detail lines.
--  • Uses header.TaxRate to compute tax and total.
--  • Upserts into SalesSummary.

-- If your DB is SQL Server:
-- DROP PROCEDURE IF EXISTS dbo.BuildSaleSummary;
-- GO
-- CREATE PROCEDURE dbo.BuildSaleSummary @SaleID INT
-- AS
-- BEGIN
--   SET NOCOUNT ON;

--   IF NOT EXISTS (SELECT 1 FROM SalesHeader WHERE SaleID = @SaleID)
--   BEGIN
--     RAISERROR('SaleID not found', 16, 1);
--     RETURN;
--   END

--   DECLARE @TaxRate DECIMAL(5,2);
--   SELECT @TaxRate = TaxRate FROM SalesHeader WHERE SaleID = @SaleID;

--   DECLARE @Subtotal DECIMAL(12,2);
--   SELECT @Subtotal = SUM(CAST(Qty AS DECIMAL(12,2)) * UnitPrice)
--   FROM SalesDetail
--   WHERE SaleID = @SaleID;

--   IF @Subtotal IS NULL SET @Subtotal = 0;

--   DECLARE @TaxAmount DECIMAL(12,2) = (@Subtotal * (@TaxRate/100.0));
--   DECLARE @Total     DECIMAL(12,2) = @Subtotal + @TaxAmount;

--   MERGE SalesSummary AS tgt
--   USING (SELECT @SaleID AS SaleID) AS src
--   ON (tgt.SaleID = src.SaleID)
--   WHEN MATCHED THEN
--     UPDATE SET Subtotal = @Subtotal, TaxAmount = @TaxAmount,
--                Total = @Total, CalcDate = CURRENT_TIMESTAMP
--   WHEN NOT MATCHED THEN
--     INSERT (SaleID, Subtotal, TaxAmount, Total)
--     VALUES (@SaleID, @Subtotal, @TaxAmount, @Total);
-- END
-- GO

-- If your DB is MySQL / MariaDB, you can translate RAISERROR -> SIGNAL and MERGE -> INSERT ... ON DUPLICATE KEY UPDATE.

-- Sample test:
-- EXEC dbo.BuildSaleSummary @SaleID = 1001;
-- SELECT * FROM SalesSummary WHERE SaleID = 1001;
