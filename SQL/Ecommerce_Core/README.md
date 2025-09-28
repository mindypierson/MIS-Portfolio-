# Ecommerce_Core (Shopify-style schema)

Normalized core tables for an online store: customers, products, orders, order items, payments, fulfillments, and inventory transactions.

## Entities
- **Customers** — account/profile info
- **Products** — catalog, price, status
- **Orders** — header (customer, status, totals, dates)
- **OrderItems** — line items (qty, unit price)
- **Payments** — transactions (auth/capture/refund)
- **Fulfillments** — shipment records
- **InventoryTransactions** — stock in/out adjustments

## Highlights
- Enforces FKs and basic constraints
- Computes order totals from items
- Tracks inventory movement for auditability

## How to use
1. Run `Ecommerce_Core_DDL.sql` to create tables.
2. (Optional) Run `SampleData.sql` to seed demo data.
3. Use `SampleQueries.sql` to explore KPIs (daily sales, top products, inventory on hand).

## Tools
- SQL Server (tested on 2019+). Easy to adapt to Postgres/MySQL.
