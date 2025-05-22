CREATE DATABASE phonebooks
COLLATE Arabic_100_CI_AI_SC_UTF8;


use phonebooks
-- Table: Sections
CREATE TABLE Sections (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    SectionName NVARCHAR(100)  COLLATE Arabic_100_CI_AI_SC_UTF8 NOT NULL  UNIQUE,
    Description NVARCHAR(255)
);

-- Table: Jobs
CREATE TABLE Jobs (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    JobTitle NVARCHAR(100) COLLATE Arabic_100_CI_AI_SC_UTF8 NOT NULL,
    SectionID INT NOT NULL,
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE
);

-- Table: PhoneTypes
CREATE TABLE PhoneTypes (
    PhoneTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PhoneTypeName NVARCHAR(30) COLLATE Arabic_100_CI_AI_SC_UTF8 NOT NULL UNIQUE
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
    FirstName NVARCHAR(50) COLLATE Arabic_100_CI_AI_SC_UTF8 NOT NULL,
    LastName NVARCHAR(50) COLLATE Arabic_100_CI_AI_SC_UTF8 NOT NULL,
    SectionID INT NOT NULL,
    JobID INT NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    is_admin BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    password NVARCHAR(255) ,
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID)
);


------------------------inserts-----------------
INSERT INTO Sections (SectionName, Description)
VALUES
(N'فاوا', N'فناوری'),
(N'اسناد', N'اسناد و مدارک پزشکی');


INSERT INTO Jobs (JobTitle, SectionID)
VALUES
(N'کارشناس فاوا', 1),
(N'کارشناس ترخیص', 2);

INSERT INTO PhoneTypes (PhoneTypeName)
VALUES
(N'دفتر'),
(N'موبايل'),
(N'اتاق');


INSERT INTO PhoneNumbers (JobID, PhoneNumber, PhoneTypeID)
VALUES
(1, '09131958575', 2),
(2, '09131958511', 1);

INSERT INTO Users (FirstName, LastName, SectionID, JobID, Email, is_admin, IsActive, password)
VALUES
(N'علی', N'قادری پور', 1, 1, 'john.doe@example.com', 1, 1, '1'),
(N'رضا', N'کریمی', 2, 2, 'jane.smith@example.com', 1, 1, '2');

INSERT INTO Users (FirstName, LastName, SectionID, JobID, Email, is_admin, IsActive, password)
VALUES
(N'محمود', N'گيشين زاده', 1, 1, 'ja2ne.smith@example.com', 1, 1, '3');