# Reservation_ExtraServices

Stored procedure that safely adds an extra service (e.g., spa, breakfast, late checkout) to an existing reservation.

## What it does
- Validates that the `ReservationID` exists in `Reservations`
- Validates that the `ExtraServiceID` exists in `ExtraServices`
- Inserts a new record into `Reservation_ExtraServices`
- Returns the updated extra services list for the reservation

## Tables (example schema)
- **Reservations** — core reservation records
- **ExtraServices** — available add-on services
- **Reservation_ExtraServices** — join table of reservations to extra services with price and approval info

## How to Run
1. Make sure `Reservations`, `ExtraServices`, and `Reservation_ExtraServices` tables exist.
2. Execute the procedure:
   ```sql
   EXEC dbo.AddReservationService
        @ReservationID = 1001,
        @ExtraServiceID = 5,
        @Price = 29.99,
        @ApprovedByGuest = 'Yes';

   ## Tools
- SQL Server Management Studio (SSMS)
- Tested on SQL Server 2019
