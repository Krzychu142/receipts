CREATE OR REPLACE FUNCTION insert_category_if_not_exists(p_name VARCHAR(100))
RETURNS record AS $$
DECLARE
    v_category_row record;
BEGIN
    v_category_row := select_category_by_name(p_name);

    IF v_category_row IS NULL THEN
        INSERT INTO categories (name)
        VALUES (p_name)
        RETURNING * INTO v_category_row;
    END IF;

    RETURN v_category_row;
END;
$$ LANGUAGE plpgsql; 