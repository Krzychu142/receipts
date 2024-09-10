CREATE OR REPLACE FUNCTION select_purchase_by_unique_receipt(
    p_product_id INT,
    p_unit_id INT,
    p_receipt_id INT,
    p_price NUMERIC(10, 2),
    p_discount NUMERIC(10, 2),
    p_quantity NUMERIC(10, 3),
    p_is_warranty BOOLEAN,
    p_warranty_expiration_date DATE
)
RETURNS record AS $$
DECLARE
    v_purchase_row record;
BEGIN
    SELECT * INTO v_purchase_row
    FROM purchases
    WHERE
        product_id = p_product_id AND
        unit_id = p_unit_id AND 
        receipt_id = p_receipt_id AND
        price = p_price AND
        discount = p_discount AND
        is_warranty = p_is_warranty AND
        warranty_expiration_date = p_warranty_expiration_date; 

    RETURN v_purchase_row;
END;
$$ LANGUAGE plpgsql;