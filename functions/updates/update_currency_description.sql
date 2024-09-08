CREATE OR REPLACE FUNCTION update_currency_description(p_currency_id INT, p_description VARCHAR(80)) 
RETURNS record AS $$
DECLARE
<<<<<<< HEAD
    v_currency_row record;
=======
    v_currency_row record
>>>>>>> 4d66eb33437928034459043f895b1d8b22f42017
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