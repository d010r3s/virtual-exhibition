-- Процедуры для добавления данных

CREATE OR REPLACE PROCEDURE add_artist(
    _name VARCHAR,
    _country VARCHAR,
    _years_active VARCHAR,
    _biography TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Artists (Name, Country, YearsActive, Biography)
    VALUES (_name, _country, _years_active, _biography);
END;
$$;

CREATE OR REPLACE PROCEDURE add_exhibit(
    _title VARCHAR,
    _artist_id INTEGER,
    _year_created INTEGER,
    _style VARCHAR,
    _description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Exhibits (Title, ArtistID, YearCreated, Style, Description)
    VALUES (_title, _artist_id, _year_created, _style, _description);
END;
$$;

CREATE OR REPLACE PROCEDURE add_user(
    _name VARCHAR,
    _email VARCHAR,
    _registered_events TEXT,
    _feedback TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Users (Name, Email, RegisteredEvents, Feedback)
    VALUES (_name, _email, _registered_events, _feedback);
END;
$$;

CREATE OR REPLACE PROCEDURE add_event(
    _title VARCHAR,
    _date DATE,
    _time TIME,
    _location VARCHAR,
    _organizer VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Events (Title, Date, Time, Location, Organizer)
    VALUES (_title, _date, _time, _location, _organizer);
END;
$$;

CREATE OR REPLACE PROCEDURE update_events(
    _event_id INTEGER,
    _title VARCHAR,
    _date DATE,
    _time_start TIME,
    _time_end TIME,
    _location VARCHAR,
    _organizer VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Events
    SET Title = _title,
        Date = _date,
        TimeStart = _time_start,
        TimeEnd = _time_end,
        Location = _location,
        Organizer = _organizer
    WHERE EventID = _event_id;
END;
$$;

-- Процедуры для удаления данных

CREATE OR REPLACE PROCEDURE delete_from_artists(_artist_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Artists WHERE ArtistID = _artist_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_exhibits(_exhibit_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Exhibits WHERE ExhibitID = _exhibit_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_events(_event_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Events WHERE EventID = _event_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_users(_user_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Users WHERE UserID = _user_id;
END;
$$;

-- Процедуры для обновления данных

CREATE OR REPLACE PROCEDURE update_artist(
    _artist_id INTEGER,
    _name VARCHAR,
    _country VARCHAR,
    _years_active VARCHAR,
    _biography TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Artists
    SET Name = _name, Country = _country, YearsActive = _years_active, Biography = _biography
    WHERE ArtistID = _artist_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_exhibit(
    _exhibit_id INTEGER,
    _title VARCHAR,
    _artist_id INTEGER,
    _year_created INTEGER,
    _style VARCHAR,
    _description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Exhibits
    SET Title = _title, ArtistID = _artist_id, YearCreated = _year_created, Style = _style, Description = _description
    WHERE ExhibitID = _exhibit_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_event(
    _event_id INTEGER,
    _title VARCHAR,
    _date DATE,
    _time TIME,
    _location VARCHAR,
    _organizer VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Events
    SET Title = _title, Date = _date, Time = _time, Location = _location, Organizer = _organizer
    WHERE EventID = _event_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_user(
    _user_id INTEGER,
    _name VARCHAR,
    _email VARCHAR,
    _registered_events TEXT,
    _feedback TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Users
    SET Name = _name, Email = _email, RegisteredEvents = _registered_events, Feedback = _feedback
    WHERE UserID = _user_id;
END;
$$;
