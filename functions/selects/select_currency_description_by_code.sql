CREATE OR REPLACE FUNCTION select_currency_description_by_code(
    p_code TEXT
)
RETURNS text AS $$
DECLARE
    v_description TEXT;
BEGIN
    SELECT description INTO v_description
    FROM currencies
    WHERE code = p_code;
    RETURN v_description;
END;
$$ LANGUAGE plpgsql;