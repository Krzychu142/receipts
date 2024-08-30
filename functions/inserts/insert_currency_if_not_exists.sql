CREATE OR REPLACE FUNCTION insert_currencie_if_not_exists(p_code VARCHAR(10), p_description VARCHAR(80)) 
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

    IF p_description IS NOT NULL AND v_currency_row.description IS NULL THEN
        -- if description for old one row was null and for the same code we have desc in data - change desc for this notnull one
               
    END IF;  

END;
$$ LANGUAGE plpgsql;