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

    v_receipt_row := select_receipt_by_unique_receipt();

END;
$$ LANGUAGE plpgsql;