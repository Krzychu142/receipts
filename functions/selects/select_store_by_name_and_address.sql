CREATE OR REPLACE FUNCTION select_store_by_name_and_address(p_name VARCHAR, p_address VARCHAR) RETURNS record AS $$
DECLARE v_store_row record;
BEGIN
SELECT * INTO v_store_row
FROM stores
WHERE name = p_name
    AND address = p_address;
RETURN v_store_row;
END;
$$ LANGUAGE plpgsql;