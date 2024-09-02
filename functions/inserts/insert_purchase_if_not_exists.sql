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
        v_product_row := select_product_by_id(p_product_id);
        IF v_product_row IS NULL THEN
            RAISE EXCEPTION 'Product with ID % not found', p_product_id; 
        END IF;

        v_unit_row := select_unit_by_id(p_unit_id);
        IF v_unit_row IS NULL THEN
            RAISE EXCEPTION 'Unit with ID % not found', p_unit_id;
        END IF;

        v_receipt_row := select_receipt_by_id(p_receipt_id);
        IF v_receipt_row IS NULL THEN
            RAISE EXCEPTION 'Receipt with ID % not found', p_receipt_id;
        END IF;

        IF (p_is_warranty = TRUE AND p_warranty_expiration_date IS NULL) 
            OR (p_is_warranty = FALSE AND p_warranty_expiration_date IS NOT NULL)
        THEN
            RAISE EXCEPTION 'Invalid warranty data provided for receipt ID %: is_warranty = %, but warranty_expiration_date = %', 
                            p_receipt_id, p_is_warranty, p_warranty_expiration_date;
        END IF;

        INSERT INTO purchases (
            product_id, 
            unit_id, 
            receipt_id, 
            price, discount, 
            quantity, 
            is_warranty, 
            warranty_expiration_date
        )
        VALUES (
            p_product_id, 
            p_unit_id, 
            p_receipt_id, 
            p_price, 
            p_discount, 
            p_quantity, 
            p_is_warranty, 
            p_warranty_expiration_date 
        )
        RETURNING * INTO v_purchase_row;
    ELSE
        IF v_purchase_row.is_warranty = FALSE 
            AND p_is_warranty = TRUE 
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