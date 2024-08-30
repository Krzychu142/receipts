CREATE OR REPLACE FUNCTION select_unit_by_unit_id(p_unit_id INT)
RETURNS record AS $$
DECLARE
    v_unit_row record;
BEGIN
    SELECT * INTO v_unit_row
    FROM units
    WHERE unit_id = p_unit_id;

    RETURN v_unit_row;
END;
$$ LANGUAGE plpgsql;