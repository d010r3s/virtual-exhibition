CREATE OR REPLACE FUNCTION update_user_registration_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Users
    SET RegistrationCount = (
        SELECT COUNT(*)
        FROM Registrations
        WHERE Registrations.UserID = NEW.UserID
    )
    WHERE UserID = NEW.UserID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_event_participant_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Events
    SET ParticipantCount = (
        SELECT COUNT(*)
        FROM Registrations
        WHERE Registrations.EventID = NEW.EventID
    )
    WHERE EventID = NEW.EventID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_user_registration_count
AFTER INSERT OR UPDATE ON Registrations
FOR EACH ROW
EXECUTE FUNCTION update_user_registration_count();

CREATE TRIGGER trg_update_event_participant_count
AFTER INSERT OR UPDATE ON Registrations
FOR EACH ROW
EXECUTE FUNCTION update_event_participant_count();

CREATE OR REPLACE FUNCTION update_user_and_event_on_delete()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Users
    SET RegistrationCount = (
        SELECT COUNT(*)
        FROM Registrations
        WHERE Registrations.UserID = OLD.UserID
    )
    WHERE UserID = OLD.UserID;

    UPDATE Events
    SET ParticipantCount = (
        SELECT COUNT(*)
        FROM Registrations
        WHERE Registrations.EventID = OLD.EventID
    )
    WHERE EventID = OLD.EventID;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_user_and_event_on_delete
AFTER DELETE ON Registrations
FOR EACH ROW
EXECUTE FUNCTION update_user_and_event_on_delete();
