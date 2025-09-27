-- Hotel_Database_Creation.sql
-- Author: Mindy Pierson
-- Example schema and query

CREATE TABLE Guests (
  GuestID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100)
);

CREATE TABLE Rooms (
  RoomID INT PRIMARY KEY,
  RoomNumber VARCHAR(10),
  RoomType VARCHAR(20),
  NightlyRate DECIMAL(10,2)
);

CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY,
  GuestID INT REFERENCES Guests(GuestID),
  RoomID INT REFERENCES Rooms(RoomID),
  CheckIn DATE,
  CheckOut DATE
);

-- Sample join
-- SELECT g.FirstName, g.LastName, r.RoomNumber, b.CheckIn, b.CheckOut
-- FROM Bookings b
-- JOIN Guests g ON b.GuestID = g.GuestID
-- JOIN Rooms r ON b.RoomID = r.RoomID;
