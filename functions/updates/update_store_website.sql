CREATE OR REPLACE FUNCTION update_store_website(
    p_store_id INTEGER,
    p_website VARCHAR
)
RETURNS stores%ROWTYPE AS $$
DECLARE
    v_store_row stores%ROWTYPE;
BEGIN
    UPDATE stores
    SET website = p_website
    WHERE store_id = p_store_id
    RETURNING * INTO v_store_row;

    IF v_store_row.store_id IS NULL THEN
        RAISE EXCEPTION 'Store with ID % not found', p_store_id;
    END IF;

    RETURN v_store_row;
END;
$$ LANGUAGE plpgsql;