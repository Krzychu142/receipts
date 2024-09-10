CREATE OR REPLACE FUNCTION update_product_description_and_product_link(
    p_product_id INT,
    p_description TEXT,
    p_product_link VARCHAR(255)
)
RETURNS record AS $$
DECLARE
    v_product_row record;
BEGIN
    UPDATE products
    SET 
        product_link = p_product_link, 
        description = p_description
    WHERE product_id = p_product_id
    RETURNING * INTO v_product_row;

    IF v_product_row IS NULL THEN 
        RAISE EXCEPTION 'Product with ID % not found', p_product_id;
    END IF;

    RETURN v_product_row;
END;
$$ LANGUAGE plpgsql;