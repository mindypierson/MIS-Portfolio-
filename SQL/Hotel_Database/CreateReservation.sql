IF OBJECT_ID('dbo.CreateReservation','P') IS NOT NULL DROP PROCEDURE dbo.CreateReservation;
GO
CREATE PROCEDURE dbo.CreateReservation
  @GuestEmail   VARCHAR(255),
  @FirstName    VARCHAR(100),
  @LastName     VARCHAR(100),
  @RoomID       INT,
  @CheckInDate  DATE,
  @CheckOutDate DATE,
  @NightlyRate  DECIMAL(10,2)
AS
BEGIN
  SET NOCOUNT ON;

  IF @CheckOutDate <= @CheckInDate
  BEGIN RAISERROR('CheckOutDate must be after CheckInDate',16,1); RETURN; END

  -- Overlap check: [in,out) vs existing
  IF EXISTS (
    SELECT 1 FROM dbo.Reservations r
    WHERE r.RoomID = @RoomID
      AND r.Status IN ('booked','checked_in')
      AND @CheckInDate < r.CheckOutDate
      AND @CheckOutDate > r.CheckInDate
  )
  BEGIN RAISERROR('Room is not available for the selected dates.',16,1); RETURN; END

  -- Upsert guest by email
  DECLARE @GuestID INT;
  SELECT @GuestID = GuestID FROM dbo.Guests WHERE Email = @GuestEmail;
  IF @GuestID IS NULL
  BEGIN
    INSERT INTO dbo.Guests(Email, FirstName, LastName) VALUES(@GuestEmail,@FirstName,@LastName);
    SET @GuestID = SCOPE_IDENTITY();
  END

  INSERT INTO dbo.Reservations(GuestID, RoomID, CheckInDate, CheckOutDate, NightlyRate)
  VALUES(@GuestID, @RoomID, @CheckInDate, @CheckOutDate, @NightlyRate);
END
GO
