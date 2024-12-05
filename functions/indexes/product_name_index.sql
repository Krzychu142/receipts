CREATE EXTENSION IF NOT EXISTS pg_trgm; -- trigram indexing extension
CREATE INDEX idx_products_name_trgm ON products USING GIN (name gin_trgm_ops);
