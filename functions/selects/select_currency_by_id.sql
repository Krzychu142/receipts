CREATE OR REPLACE FUNCTION select_currency_by_id(p_currency_id INT)
RETURNS record AS $$
DECLARE
    v_currency_row record;
BEGIN
    SELECT * INTO v_currency_row
    FROM currencies 
    WHERE currency_id = p_currency_id;

    RETURN v_currency_row;
END;
$$ LANGUAGE plpgsql;