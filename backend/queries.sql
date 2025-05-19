-- Sections table: Stores organizational sections/departments
CREATE TABLE Sections (
    SectionID INT PRIMARY KEY IDENTITY(1,1),
    SectionName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL
);

-- Jobs table: Stores job roles within the organization
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    JobTitle NVARCHAR(100) NOT NULL,
    SectionID INT NOT NULL,
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE CASCADE
);

-- PhoneTypes table: Stores types of phone numbers (e.g., Mobile, Office)
CREATE TABLE PhoneTypes (
    PhoneTypeID INT PRIMARY KEY IDENTITY(1,1),
    PhoneTypeName NVARCHAR(30) NOT NULL UNIQUE
);

-- PhoneNumbers table: Stores phone numbers associated with jobs
CREATE TABLE PhoneNumbers (
    PhoneID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL, -- Increased length for international formats
    PhoneTypeID INT NULL, -- Changed to INT to match PhoneTypes
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
    FOREIGN KEY (PhoneTypeID) REFERENCES PhoneTypes(PhoneTypeID) ON DELETE SET NULL
);

-- Users table: Stores user information, linking to section and job
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    SectionID INT NOT NULL,
    JobID INT NOT NULL,
    Email NVARCHAR(100) NULL UNIQUE, -- Reintroduced for contact/login
    is_admin BIT NOT NULL DEFAULT 0, -- Admin flag
    IsActive BIT NOT NULL DEFAULT 1, -- Active or inactive status
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID) ON DELETE NO ACTION,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE NO ACTION
);

-- 1. Insert Sections
INSERT INTO Sections (SectionName, Description)
VALUES
    ('IT', 'Information Technology Department'),
    ('HR', 'Human Resources Department');

-- 2. Insert Jobs (with proper Section relationships)
INSERT INTO Jobs (JobTitle, SectionID)
VALUES
    ('Programmer', 1),          -- IT Section (SectionID 1)
    ('IT Manager', 1),          -- IT Section
    ('HR Specialist', 2);       -- HR Section (SectionID 2)

-- 3. Insert Phone Types
INSERT INTO PhoneTypes (PhoneTypeName)
VALUES
    ('Mobile'),
    ('Office'),
    ('Fax');

-- 4. Insert Phone Numbers for Jobs
INSERT INTO PhoneNumbers (JobID, PhoneNumber, PhoneTypeID)
VALUES
    -- Programmer (JobID 1) numbers
    (1, '+1-555-123-4567', 1),  -- Mobile
    (1, '+1-555-765-4321', 2),  -- Office

    -- IT Manager (JobID 2) numbers
    (2, '+1-555-888-9999', 2),  -- Office
    (2, '+1-555-222-3333', 1),  -- Mobile

    -- HR Specialist (JobID 3) numbers
    (3, '+1-555-444-5555', 1);  -- Mobile

-- 5. Insert Users
INSERT INTO Users (FirstName, LastName, SectionID, JobID, Email, is_admin, IsActive)
VALUES
    ('John', 'Doe', 1, 1, 'john.doe@company.com', 0, 1),       -- Programmer
    ('Jane', 'Smith', 1, 2, 'jane.smith@company.com', 1, 1),   -- IT Manager (admin)
    ('Alice', 'Johnson', 2, 3, 'alice.j@company.com', 0, 1);   -- HR Specialist



	UPDATE PhoneNumbers
SET PhoneNumber = '+1-555-NEW-NUMB'
WHERE JobID = 1 AND PhoneTypeID = 2


UPDATE Users
SET is_admin = 1
WHERE UserID = 3