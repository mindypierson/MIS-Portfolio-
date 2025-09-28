# Sales Summary Stored Procedure

Builds a summary of sales transactions for a given SaleID.

## What it does
- Aggregates line items (units, subtotal, first/last item time)
- Calculates tax and totals
- Error handling if SaleID not found
- Useful for building reporting tables or invoicing systems

## How to Run
```sql
EXEC dbo.BuildSaleSummary @SaleID = 1001;
