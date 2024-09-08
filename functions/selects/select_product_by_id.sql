CREATE OR REPLACE FUNCTION select_product_by_id(p_product_id INT)
RETURNS record AS $$
DECLARE
    v_product_row record;
BEGIN
    SELECT * INTO v_product_row
    FROM products
    WHERE product_id = p_product_id;

    RETURN v_product_row;
END;
$$ LANGUAGE plpgsql;