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
    _email VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Users (Name, Email)
    VALUES (_name, _email);
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

CREATE OR REPLACE PROCEDURE add_registration(
    _user_id INTEGER,
    _event_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Registrations (UserID, EventID)
    VALUES (_user_id, _event_id);
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

CREATE OR REPLACE PROCEDURE delete_from_registrations(_registration_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Registrations WHERE RegistrationID = _registration_id;
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
    _email VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Users
    SET Name = _name, Email = _email
    WHERE UserID = _user_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_registration(
    _registration_id INTEGER,
    _user_id INTEGER,
    _event_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Registrations
    SET UserID = _user_id,
        EventID = _event_id
    WHERE RegistrationID = _registration_id;
END;
$$;

-- Очистка таблицы

CREATE OR REPLACE PROCEDURE clear_all_tables()
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE
        Registrations,
        Users,
        Events,
        Exhibits,
        Artists
    RESTART IDENTITY CASCADE;
END;
$$;

-- Очистка вкладки

CREATE OR REPLACE PROCEDURE clear_table(_table_name TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    EXECUTE format('TRUNCATE TABLE %I RESTART IDENTITY CASCADE;', lower(_table_name));
END;
$$;

-- Просмотр таблиц

CREATE OR REPLACE FUNCTION view_artists()
RETURNS TABLE (
    ArtistID INTEGER,
    "Name" VARCHAR,
    Country VARCHAR,
    YearsActive VARCHAR,
    Biography TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Artists;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_exhibits()
RETURNS TABLE (
    ExhibitID INTEGER,
    Title VARCHAR,
    ArtistID INTEGER,
    YearCreated INTEGER,
    "Style" VARCHAR,
    Description TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Exhibits;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_users()
RETURNS TABLE (
    UserID INTEGER,
    "Name" VARCHAR,
    Email VARCHAR,
    RegistrationCount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Users;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_events()
RETURNS TABLE (
    EventID INTEGER,
    Title VARCHAR,
    "Date" DATE,
    "Time" TIME,
    Location VARCHAR,
    Organizer VARCHAR,
    ParticipantCount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Events;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION view_registrations()
RETURNS TABLE (
    RegistrationID INTEGER,
    UserID INTEGER,
    EventID INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM Registrations;
END;
$$ LANGUAGE plpgsql;

-- Поиск по таблицам

CREATE OR REPLACE FUNCTION search_artists(_name TEXT)
RETURNS TABLE (
    ArtistID INTEGER,
    "Name" VARCHAR,
    Country VARCHAR,
    YearsActive VARCHAR,
    Biography TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.ArtistID, t.Name, t.Country, t.YearsActive, t.Biography
    FROM Artists AS t
    WHERE t.Name ILIKE '%' || _name || '%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_exhibits(_title TEXT)
RETURNS TABLE (
    ExhibitID INTEGER,
    Title VARCHAR,
    ArtistID INTEGER,
    YearCreated INTEGER,
    "Style" VARCHAR,
    Description TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.ExhibitID, t.Title, t.ArtistID, t.YearCreated, t.Style, t.Description
    FROM Exhibits AS t
    WHERE t.Title ILIKE '%' || _title || '%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_users(_name TEXT)
RETURNS TABLE (
    UserID INTEGER,
    "Name" VARCHAR,
    Email VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.UserID, t.Name, t.Email
    FROM Users AS t
    WHERE t.Name ILIKE '%' || _name || '%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_events(_title TEXT)
RETURNS TABLE (
    EventID INTEGER,
    Title VARCHAR,
    "Date" DATE,
    "Time" TIME,
    Location VARCHAR,
    Organizer VARCHAR,
    ParticipantCount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.EventID, t.Title, t.Date, t.Time, t.Location, t.Organizer, t.ParticipantCount
    FROM Events AS t
    WHERE t.Title ILIKE '%' || _title || '%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_registrations(_user_id INTEGER)
RETURNS TABLE (
    RegistrationID INTEGER,
    UserID INTEGER,
    EventID INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.RegistrationID, t.UserID, t.EventID
    FROM Registrations AS t
    WHERE t.UserID = _user_id;
END;
$$ LANGUAGE plpgsql;

-- Удаление записей

CREATE OR REPLACE PROCEDURE delete_from_artists_by_id(_artist_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Artists WHERE ArtistID = _artist_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_exhibits_by_id(_exhibit_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Exhibits WHERE ExhibitID = _exhibit_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_events_by_id(_event_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Events WHERE EventID = _event_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_users_by_id(_user_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Users WHERE UserID = _user_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_registrations_by_id(_registration_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Registrations WHERE RegistrationID = _registration_id;
END;
$$;

-- Удаление по неключевому полю

CREATE OR REPLACE PROCEDURE delete_from_artists_by_name(_name TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Artists WHERE Name ILIKE _name;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_exhibits_by_name(_title TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Exhibits WHERE Title ILIKE _title;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_events_by_name(_title TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Events WHERE Title ILIKE _title;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_users_by_name(_name TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Users WHERE Name ILIKE _name;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_from_registrations_by_userid(_user_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Registrations WHERE UserID = _user_id;
END;
$$;
