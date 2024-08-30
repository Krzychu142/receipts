CREATE OR REPLACE FUNCTION select_product_by_name_and_category_id(p_name VARCHAR(200), p_category_id INT)
RETURNS record AS $$
DECLARE
    v_product_row record;
BEGIN
    SELECT * INTO v_product_row
    FROM products
    WHERE name = p_name AND category_id = p_category_id;

    RETURN v_category_row; 
END;
$$ LANGUAGE plpgsql;