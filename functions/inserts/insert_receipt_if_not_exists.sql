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
      -- not exists
      -- check is p_store_id valid object
      -- if not raise error
      -- check is p_currency_id valid object 
      -- if not raise error
      -- insert new object
    ELSE
        -- exists
        -- is old receipt_date is null and new is not null
            -- update_receipt_scan_by_id()
    END IF;

END;
$$ LANGUAGE plpgsql;