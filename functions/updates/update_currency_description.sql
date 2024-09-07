CREATE OR REPLACE FUNCTION update_currency_description(p_currency_id INT, p_description VARCHAR(80)) 
RETURNS record AS $$
DECLARE
    v_currency_row record;
BEGIN
    UPDATE currencies
    SET description = p_description
    WHERE currency_id = p_currency_id
    RETURNING * INTO v_currency_row;

    IF v_currency_row IS NULL THEN 
        RAISE EXCEPTION 'Currency with ID % not found', p_currency_id;
    END IF;

    RETURN v_currency_row;
END;
$$ LANGUAGE plpgsql;