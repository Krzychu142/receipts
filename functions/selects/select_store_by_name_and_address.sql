CREATE OR REPLACE FUNCTION select_store_by_name_and_address(p_name VARCHAR(180), p_address VARCHAR(255)) 
RETURNS record AS $$
DECLARE 
    v_store_row record;
BEGIN
    SELECT * INTO v_store_row
    FROM stores
    WHERE name = p_name AND address = p_address;

    RETURN v_store_row;
END;
$$ LANGUAGE plpgsql;