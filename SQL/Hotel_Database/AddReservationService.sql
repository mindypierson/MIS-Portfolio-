-- AddReservationService.sql
-- Author: Mindy Pierson
-- Purpose: Add an extra service to an existing reservation with validation.

IF OBJECT_ID('dbo.AddReservationService','P') IS NOT NULL
    DROP PROCEDURE dbo.AddReservationService;
GO

CREATE PROCEDURE dbo.AddReservationService
    @ReservationID   INT,
    @ExtraServiceID  INT,
    @Price           NUMERIC(12,2),
    @ApprovedByGuest NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Ensure the Reservation exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Reservations WHERE ReservationID = @ReservationID)
    BEGIN
        RAISERROR('ReservationID %d not found.', 16, 1, @ReservationID);
        RETURN;
    END

    -- Ensure the Extra Service exists
    IF NOT EXISTS (SELECT 1 FROM dbo.ExtraServices WHERE ServiceID = @ExtraServiceID)
    BEGIN
        RAISERROR('ExtraServiceID %d not found.', 16, 1, @ExtraServiceID);
        RETURN;
    END

    -- Insert new service record
    INSERT INTO dbo.Reservation_ExtraServices
        (ReservationID, ExtraServiceID, Price, ApprovedByGuest)
    VALUES
        (@ReservationID, @ExtraServiceID, @Price, @ApprovedByGuest);

    -- Return inserted rows
    SELECT * FROM dbo.Reservation_ExtraServices WHERE ReservationID = @ReservationID;
END;
GO
