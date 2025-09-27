# Sales_Summary

Stored procedure to aggregate line items into a single sales summary row.

## What it does
- Validates the `SaleID` exists in `SalesHeader`
- Calculates **Subtotal** from `SalesDetail` (`Qty * UnitPrice`)
- Uses `TaxRate` from `SalesHeader` to compute **TaxAmount**
- Computes **Total = Subtotal + TaxAmount**
- Upserts the result into `SalesSummary`

## Tables (example schema)
- `SalesHeader(SaleID, CustomerID, SaleDate, TaxRate)`
- `SalesDetail(SaleID, LineNum, ItemID, Qty, UnitPrice)`
- `SalesSummary(SaleID, Subtotal, TaxAmount, Total, CalcDate)`

## How to run
1. Ensure the three tables exist (DDL in comments of the SQL file).
2. Load some sample `SalesHeader` and `SalesDetail` rows.
3. Execute:
   ```sql
   EXEC dbo.BuildSaleSummary @SaleID = 1001;
   SELECT * FROM SalesSummary WHERE SaleID = 1001;
