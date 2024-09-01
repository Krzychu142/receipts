CREATE OR REPLACE FUNCTION insert_receipt_if_not_exists(
    p_store_id INT,
    p_currency_id INT,
    p_total NUMERIC(10, 2),
    p_receipt_date DATE,
    p_is_online BOOLEAN,
    p_receipt_scan TEXT
)
RETURNS record AS $$
DECLARE
    v_receipt_row record;
    v_store_row record;
    v_currency_row record;
CREATE

    v_receipt_row := select_receipt_by_unique_receipt(
        p_store_id, 
        p_currency_id, 
        p_total, 
        p_receipt_date,
        p_is_online,
        p_receipt_scan 
    );

    IF v_receipt_row IS NULL THEN
        v_store_row := select_store_by_id(p_store_id);
        IF v_store_row IS NULL THEN 
            RAISE EXCEPTION 'Store with ID % not found', p_store_id;
        END IF;
        v_currency_row := select_currency_by_id(p_currency_id);
        IF v_currency_row IS NULL THEN
            RAISE EXCEPTION 'Currency with ID % not found', p_currency_id;
        END IF;

        INSERT receipts (
            store_id, 
            currency_id, 
            total,
            receipt_date,
            is_online,
            receipt_scan
        )
        VALUES(
            p_store_id, 
            p_currency_id, 
            p_total,
            p_receipt_date,
            p_is_online,
            p_receipt_scan  
        )
        RETURNING * INTO v_receipt_row;
    ELSE
        -- exists
        -- is old receipt_date is null and new is not null
            -- update_receipt_scan_by_id()
    END IF;

END;
$$ LANGUAGE plpgsql;