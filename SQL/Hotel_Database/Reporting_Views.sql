-- Occupied room-nights by date (simple inline calendar)
CREATE OR ALTER VIEW dbo.vw_DailyRoomNights AS
SELECT r.RoomID, d.CalDate AS StayDate
FROM dbo.Reservations r
JOIN (
  SELECT TOP (3650) CAST(DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1, '2025-01-01') AS DATE) AS CalDate
  FROM sys.all_objects
) d ON d.CalDate >= r.CheckInDate AND d.CalDate < r.CheckOutDate
WHERE r.Status IN ('booked','checked_in','checked_out');

CREATE OR ALTER VIEW dbo.vw_OccupancyByDate AS
SELECT StayDate, COUNT(DISTINCT RoomID) AS RoomsOccupied
FROM dbo.vw_DailyRoomNights
GROUP BY StayDate;

CREATE OR ALTER VIEW dbo.vw_DailyRevenue AS
SELECT CONVERT(date, p.CreatedAt) AS RevenueDate,
       SUM(p.Amount) AS Revenue
FROM dbo.Payments p
GROUP BY CONVERT(date, p.CreatedAt);
