CREATE OR REPLACE FUNCTION insert_purchase_if_not_exists(
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
    v_purchase_row record,
    v_product_row record,
    v_unit_row record,
    v_receipt_row record
BEGIN

END;
$$ LANGUAGE plpgsql;