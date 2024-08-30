CREATE OR REPLACE FUNCTION select_currencies_by_code(p_code VARCHAR) RETURNS record AS $$ 
DECLARE
    v_currencies_row record;
BEGIN
    SELECT * INTO v_currencies_row
    FROM currencies
    WHERE code = p_code;

    RETURN v_currencies_row;
END; 
$$ LANGUAGE plpgsql; 