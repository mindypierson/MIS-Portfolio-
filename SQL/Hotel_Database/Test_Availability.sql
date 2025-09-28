-- Should raise "Room is not available..."
EXEC dbo.CreateReservation
  @GuestEmail='guest2@example.com', @FirstName='Ben', @LastName='Nguyen',
  @RoomID=1, @CheckInDate='2025-03-11', @CheckOutDate='2025-03-12', @NightlyRate=149.00;
