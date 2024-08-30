CREATE OR REPLACE FUNCTION select_currencies_by_code(p_code VARCHAR(10)) RETURNS record AS $$ 
DECLARE
    v_currency_row record;
BEGIN
    SELECT * INTO v_currency_row
    FROM currencies
    WHERE code = p_code;

    RETURN v_currency_row;
END; 
$$ LANGUAGE plpgsql; 