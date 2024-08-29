CREATE OR REPLACE FUNCTION insert_store_if_not_exists (
    p_name VARCHAR,
    p_address VARCHAR, 
    p_website VARCHAR
)
RETURNS stores%ROWTYPE AS $$
DECLARE
    v_store_row stores%ROWTYPE;
BEGIN
    v_store_row := select_store_by_name_and_address(p_name, p_address);

    IF v_store_row IS NULL THEN
        INSERT INTO stores (name, address, website) 
        VALUES (p_name, p_address, p_website)
        RETURNING * INTO v_store_row;
    END IF;

    IF p_website IS NOT NULL AND v_store_row.website IS NULL THEN
        v_store_row := update_store_website(v_store_row.store_id, p_website); 
    END IF;

    RETURN v_store_row;
END; 
$$ LANGUAGE plpgsql;