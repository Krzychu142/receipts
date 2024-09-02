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
    v_purchase_row := select_purchase_by_unique_receipt(
        p_product_id, 
        p_unit_id, 
        p_receipt_id, 
        p_price, 
        p_discount, 
        p_quantity, 
        p_is_warranty, 
        p_warranty_expiration_date
    );

    IF v_purchase_row IS NULL THEN
        -- not exists
    ELSE
        IF v_purchase_row.is_warranty == FALSE 
            AND p_is_warranty == TRUE 
            AND p_warranty_expiration_date IS NOT NULL 
        THEN
            v_purchase_row := update_warranty(
                v_purchase_row.purchase_id, 
                p_is_warranty, 
                p_warranty_expiration_date
            );
        END IF;
    END IF;

    RETURN v_purchase_row;
END;
$$ LANGUAGE plpgsql;