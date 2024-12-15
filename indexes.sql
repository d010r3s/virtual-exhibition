-- Индекс для поиска по столбцу Name в таблице Users
CREATE INDEX idx_users_name_trgm
ON Users USING GIN (Name gin_trgm_ops);

-- Индекс для поиска по столбцу Name в таблице Artists
CREATE INDEX idx_artists_name_trgm
ON Artists USING GIN (Name gin_trgm_ops);

-- Индекс для поиска по столбцу Title в таблице Exhibits
CREATE INDEX idx_exhibits_title_trgm
ON Exhibits USING GIN (Title gin_trgm_ops);

-- Индекс для поиска по столбцу Title в таблице Events
CREATE INDEX idx_events_title_trgm
ON Events USING GIN (Title gin_trgm_ops);
