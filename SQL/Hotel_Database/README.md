# Hotel Management System (SQL)

End-to-end demo of a hotel back office: reservations, extra services, checkout, payments, and reporting.

## Features
- **Availability-safe booking**: `CreateReservation` prevents overlapping stays per room
- **Extras & charges**: `AddReservationService` records optional services with pricing
- **Checkout & billing**: `CheckOut` computes room + services, adds tax, captures payment
- **Reporting**: views for occupancy and daily revenue

## Schema
- **Guests, RoomTypes, Rooms**
- **Reservations** (header with dates/status/rate)
- **ExtraServices, Reservation_ExtraServices**
- **Payments**

## How to Run
1. Create objects: run `Hotel_Core_DDL.sql`
2. Create procs: `CreateReservation.sql`, `AddReservationService.sql`, `CheckOut.sql`
3. Seed & test: `SampleData.sql`
4. Reporting: run `Reporting_Views.sql`, then:
   ```sql
   SELECT TOP 7 * FROM dbo.vw_OccupancyByDate ORDER BY StayDate DESC;
   SELECT TOP 7 * FROM dbo.vw_DailyRevenue ORDER BY RevenueDate DESC;
