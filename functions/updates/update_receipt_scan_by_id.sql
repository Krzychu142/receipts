CREATE OR REPLACE FUNCTION update_receipt_scan_by_id(p_receipt_id INT, p_receipt_scan TEXT)
RETURNS record AS $$
DECLARE
    v_receipt_row record;
BEGIN
    UPDATE receipts
    SET receipt_scan = p_receipt_scan
    WHERE receipt_id = p_receipt_id;

    IF v_receipt_row IS NULL THEN 
        RAISE EXCEPTION 'Receipt with ID % not found', p_receipt_id;
    END IF;

    RETURN v_receipt_row;
END;
$$ LANGUAGE plpgsql;