CREATE OR REPLACE FUNCTION select_unit_by_name(p_name VARCHAR(50))
RETURNS record AS $$
DECLARE
    v_unit_row record; 
BEGIN
    SELECT * INTO v_unit_row
    FROM units
    WHERE name = p_name;

    RETURN v_unit_row;
END;
$$ LANGUAGE plpgsql;