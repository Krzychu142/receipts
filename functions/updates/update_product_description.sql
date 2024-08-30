CREATE OR REPLACE FUNCTION update_product_description(
    p_product_id INT,
    p_description TEXT
)
RETURNS record AS $$
DECLARE
    v_product_row record;
BEGIN
    UPDATE products
    SET description = p_description
    WHERE product_id = p_product_id
    RETURNING * INTO v_product_row;

    IF v_product_row IS NULL THEN 
        RAISE EXCEPTION 'Product with ID % not found', p_product_id;
    END IF;

    RETURN v_product_row;
END;
$$ LANGUAGE plpgsql;