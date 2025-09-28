-- Hotel_Core_DDL.sql

-- Guests
CREATE TABLE dbo.Guests (
  GuestID INT IDENTITY(1,1) PRIMARY KEY,
  Email VARCHAR(255) UNIQUE NOT NULL,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Phone VARCHAR(30) NULL,
  CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Room types
CREATE TABLE dbo.RoomTypes (
  RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
  Code VARCHAR(20) UNIQUE NOT NULL,   -- e.g., KING, QN-DBL
  BaseRate DECIMAL(10,2) NOT NULL CHECK (BaseRate >= 0)
);

-- Rooms
CREATE TABLE dbo.Rooms (
  RoomID INT IDENTITY(1,1) PRIMARY KEY,
  RoomNumber VARCHAR(10) UNIQUE NOT NULL,
  RoomTypeID INT NOT NULL FOREIGN KEY REFERENCES dbo.RoomTypes(RoomTypeID),
  IsActive BIT NOT NULL DEFAULT 1
);

-- Reservations (header)
CREATE TABLE dbo.Reservations (
  ReservationID INT IDENTITY(1,1) PRIMARY KEY,
  GuestID INT NOT NULL FOREIGN KEY REFERENCES dbo.Guests(GuestID),
  RoomID INT NOT NULL FOREIGN KEY REFERENCES dbo.Rooms(RoomID),
  CheckInDate DATE NOT NULL,
  CheckOutDate DATE NOT NULL,
  Status VARCHAR(20) NOT NULL DEFAULT 'booked',  -- booked, checked_in, checked_out, cancelled
  NightlyRate DECIMAL(10,2) NOT NULL CHECK (NightlyRate >= 0),
  Subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
  TaxAmount DECIMAL(12,2) NOT NULL DEFAULT 0,
  TotalAmount AS (Subtotal + TaxAmount) PERSISTED,
  CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Extra services catalog (spa, parking, breakfast)
CREATE TABLE dbo.ExtraServices (
  ServiceID INT IDENTITY(1,1) PRIMARY KEY,
  ServiceName VARCHAR(100) UNIQUE NOT NULL
);

-- Reservation ↔ Extra services
CREATE TABLE dbo.Reservation_ExtraServices (
  ReservationID INT NOT NULL FOREIGN KEY REFERENCES dbo.Reservations(ReservationID),
  ExtraServiceID INT NOT NULL FOREIGN KEY REFERENCES dbo.ExtraServices(ServiceID),
  Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
  ApprovedByGuest NVARCHAR(100) NULL,
  CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  CONSTRAINT PK_Res_Svc PRIMARY KEY (ReservationID, ExtraServiceID, CreatedAt)
);

-- Payments
CREATE TABLE dbo.Payments (
  PaymentID INT IDENTITY(1,1) PRIMARY KEY,
  ReservationID INT NOT NULL FOREIGN KEY REFERENCES dbo.Reservations(ReservationID),
  PayType VARCHAR(20) NOT NULL,  -- auth, capture, refund
  Amount DECIMAL(12,2) NOT NULL CHECK (Amount >= 0),
  CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Helpful indexes
CREATE INDEX IX_Reservations_Room_Dates ON dbo.Reservations(RoomID, CheckInDate, CheckOutDate);
CREATE INDEX IX_Reservations_Guest ON dbo.Reservations(GuestID, CheckInDate);
