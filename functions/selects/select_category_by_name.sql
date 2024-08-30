CREATE OR REPLACE FUNCTION select_category_by_name(p_name VARCHAR(100))
RETURNS record AS $$
DECLARE
    v_category_row record;
BEGIN
    SELECT * INTO v_category_row 
    FROM categories
    WHERE name = p_name;

    RETURN v_category_row;
END;
$$ LANGUAGE plpgsql;