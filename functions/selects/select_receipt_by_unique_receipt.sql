CREATE OR REPLACE FUNCTION select_receipt_by_unique_receipt(        
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
BEGIN
    SELECT * INTO v_receipt_row
    FROM receipts
    WHERE 
        store_id = p_store_id AND 
        currency_id = p_currency_id AND
        total = p_total AND
        receipt_date = p_receipt_date AND
        is_online = p_is_online AND
        receipt_scan = p_receipt_scan;

    RETURN v_receipt_row;
END;
$$ LANGUAGE plpgsql;