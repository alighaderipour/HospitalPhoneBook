-- Table: Sections
CREATE TABLE Sections (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    SectionName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
use phonebooks
-- Table: Jobs
CREATE TABLE Jobs (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    JobTitle NVARCHAR(100) NOT NULL,
    SectionID INT NOT NULL,
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE
);

-- Table: PhoneTypes
CREATE TABLE PhoneTypes (
    PhoneTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PhoneTypeName NVARCHAR(30) NOT NULL UNIQUE
);

-- Table: PhoneNumbers
CREATE TABLE PhoneNumbers (
    PhoneID INT IDENTITY(1,1) PRIMARY KEY,
    JobID INT NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    PhoneTypeID INT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
    FOREIGN KEY (PhoneTypeID) REFERENCES PhoneTypes(PhoneTypeID)
);

-- Table: Users
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    SectionID INT NOT NULL,
    JobID INT NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    is_admin BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    password NVARCHAR(255) UNIQUE,
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);


------------------------inserts-----------------
INSERT INTO Sections (SectionName, Description)
VALUES
('IT Department', 'Handles software and hardware infrastructure'),
('HR Department', 'Manages hiring and employee relations');


INSERT INTO Jobs (JobTitle, SectionID)
VALUES
('Software Engineer', 1),
('Recruiter', 2);

INSERT INTO PhoneTypes (PhoneTypeName)
VALUES
('Office'),
('Mobile'),
('Home');


INSERT INTO PhoneNumbers (JobID, PhoneNumber, PhoneTypeID)
VALUES
(1, '+1234567890', 2),
(2, '+9876543210', 1);

INSERT INTO Users (FirstName, LastName, SectionID, JobID, Email, is_admin, IsActive, password)
VALUES
('John', 'Doe', 1, 1, 'john.doe@example.com', 0, 1, 'securepassword123'),
('Jane', 'Smith', 2, 2, 'jane.smith@example.com', 1, 1, 'adminpass456');