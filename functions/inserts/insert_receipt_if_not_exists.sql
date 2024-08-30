CREATE OR REPLACE FUNCTION insert_receipt_if_not_exists(
    p_store_id INT, 
    P_currency_id INT, 
    P_total NUMERIC(10,2),
    p_receipt_date DATE, 
    p_is_online BOOLEAN, 
    receipt_scan TEXT
)
RETURNS record AS $$
DECLARE
    v_receipt_row record;
BEGIN
    -- SELECT receipt 
    -- IF NOT EXISTS
        -- CHECK IS store_id IS VALID STORE
        -- CHECK IS currency_id IS VALID CURRENCY
        -- INSERT

    RETURN v_receipt_row;
END;
$$ LANGUAGE plpgsql;