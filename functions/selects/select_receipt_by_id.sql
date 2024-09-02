CREATE OR REPLACE FUNCTION select_receipt_by_id(p_receipt_id INT)
RETURNS record AS $$
DECLARE
    v_receipt_row record;
BEGIN
    SELECT * INTO v_receipt_row
    FROM receipts
    WHERE receipt_id = p_receipt_id;

    RETURN v_receipt_row;
END;
$$ LANGUAGE plpgsql;