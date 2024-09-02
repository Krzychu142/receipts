CREATE OR REPLACE FUNCTION select_store_by_id(p_store_id INT)
RETURNS record AS $$
DECLARE
    v_store_row record;
BEGIN
    SELECT * INTO v_store_row
    FROM stores
    WHERE store_id = p_store_id;

    RETURN v_store_row;
END;
$$ LANGUAGE plpgsql;