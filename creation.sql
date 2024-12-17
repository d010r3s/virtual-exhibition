CREATE TABLE Artists (
    ArtistID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Country VARCHAR(100),
    YearsActive VARCHAR(50),
    Biography TEXT
);

CREATE TABLE Exhibits (
    ExhibitID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ArtistID INT REFERENCES Artists(ArtistID),
    YearCreated INTEGER,
    Style VARCHAR(100),
    Description TEXT
);

CREATE TABLE Events (
    EventID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Date DATE,
    Time TIME,
    Location VARCHAR(255),
    Organizer VARCHAR(255),
    ParticipantCount INTEGER DEFAULT 0
);

CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    RegistrationCount INTEGER DEFAULT 0
);

CREATE TABLE Registrations (
    RegistrationID SERIAL PRIMARY KEY,
    UserID INTEGER REFERENCES Users(UserID) ON DELETE CASCADE,
    EventID INTEGER REFERENCES Events(EventID) ON DELETE CASCADE
);
