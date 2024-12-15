CREATE OR REPLACE FUNCTION update_participant_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Обновляем счетчик для старых EventID при удалении или обновлении
    IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF OLD.RegisteredEvents IS NOT NULL THEN
            UPDATE Events
            SET ParticipantCount = (
                SELECT COUNT(*)
                FROM Users
                WHERE RegisteredEvents IS NOT NULL
                AND RegisteredEvents ILIKE '%' || Events.EventID || '%'
            )
            WHERE EventID IN (
                SELECT CAST(event_id AS INTEGER)
                FROM unnest(string_to_array(OLD.RegisteredEvents, ',')) AS event_id
            );
        END IF;
    END IF;

    -- Обновляем счетчик для новых EventID при вставке или обновлении
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.RegisteredEvents IS NOT NULL THEN
            UPDATE Events
            SET ParticipantCount = (
                SELECT COUNT(*)
                FROM Users
                WHERE RegisteredEvents IS NOT NULL
                AND RegisteredEvents ILIKE '%' || Events.EventID || '%'
            )
            WHERE EventID IN (
                SELECT CAST(event_id AS INTEGER)
                FROM unnest(string_to_array(NEW.RegisteredEvents, ',')) AS event_id
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_participant_count
AFTER INSERT OR UPDATE OR DELETE ON Users
FOR EACH ROW
EXECUTE FUNCTION update_participant_count();

CREATE OR REPLACE FUNCTION clean_registered_events()
RETURNS TRIGGER AS $$
BEGIN
    NEW.RegisteredEvents := array_to_string(
        ARRAY(
            SELECT event_id::TEXT
            FROM unnest(string_to_array(NEW.RegisteredEvents, ',')) AS event_id
            WHERE EXISTS (
                SELECT 1
                FROM Events
                WHERE Events.EventID = event_id::INTEGER
            )
        ), ','
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_clean_registered_events
BEFORE INSERT OR UPDATE ON Users
FOR EACH ROW
EXECUTE FUNCTION clean_registered_events();
