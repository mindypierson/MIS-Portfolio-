INSERT INTO dbo.RoomTypes(Code, BaseRate) VALUES ('KING',149.00),('QN-DBL',129.00);
INSERT INTO dbo.Rooms(RoomNumber, RoomTypeID) VALUES ('201',1),('202',1),('301',2);

EXEC dbo.CreateReservation
  @GuestEmail='guest1@example.com', @FirstName='Alex', @LastName='Rivera',
  @RoomID=1, @CheckInDate='2025-03-10', @CheckOutDate='2025-03-13', @NightlyRate=149.00;

INSERT INTO dbo.ExtraServices(ServiceName) VALUES ('Breakfast'),('Parking');
EXEC dbo.AddReservationService @ReservationID=1, @ExtraServiceID=1, @Price=15.00, @ApprovedByGuest='Yes';
EXEC dbo.AddReservationService @ReservationID=1, @ExtraServiceID=2, @Price=10.00, @ApprovedByGuest='Yes';

EXEC dbo.CheckOut @ReservationID=1, @TaxRatePct=10.0;
