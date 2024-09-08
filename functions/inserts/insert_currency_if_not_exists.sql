CREATE OR REPLACE FUNCTION insert_currency_if_not_exists(p_code VARCHAR(10), p_description VARCHAR(80)) 
RETURNS record AS $$
DECLARE
    v_currency_row record;
BEGIN
    v_currency_row := select_currencies_by_code(p_code);
    
    IF v_currency_row IS NULL THEN
        INSERT INTO currencies (code, description)
        VALUES (p_code, p_description)
        RETURNING * INTO v_currency_row;
    END IF;

    IF p_description IS NOT NULL AND (v_currency_row.description IS NULL OR rtrim(v_currency_row.description) = '') THEN
        v_currency_row := update_currency_description(v_currency_row.currency_id, p_description);             
    END IF;

    RETURN v_currency_row;
END;
$$ LANGUAGE plpgsql;