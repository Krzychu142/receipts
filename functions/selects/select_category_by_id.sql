CREATE OR REPLACE FUNCTION select_category_by_id(p_category_id INT)
RETURNS record AS $$
DECLARE
    v_category_row record;
BEGIN
    SELECT * 
    INTO v_category_row
    FROM categories
    WHERE category_id = p_category_id;

    RETURN v_category_row;
END;
$$ LANGUAGE plpgsql;