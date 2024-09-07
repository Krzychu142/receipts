CREATE OR REPLACE FUNCTION insert_tables_by_data_from_csv()
RETURNS BOOLEAN AS $$
DECLARE
    record_data record;
    store_name VARCHAR(180);
    store_address VARCHAR(255);
    store_website VARCHAR(255);
    v_store_row record;
    currency_code VARCHAR(10);
    currency_description VARCHAR(80);
    v_currency_row record;
    receipt_total NUMERIC(10, 2);
    receipt_date_string TEXT;
    receipt_date_date DATE;
    receipt_is_online BOOLEAN;
    receipt_scan TEXT;
    v_receipt_row record;
BEGIN
    BEGIN
        FOR record_data IN 
            SELECT * FROM csv_plain_data
        LOOP
            store_name := record_data.sklep;
            PERFORM validate_parameter_is_not_null(store_name, 'Store name');
            store_address := COALESCE(record_data.adres, '');
            store_website := record_data.strona_internetowa;
            v_store_row := insert_store_if_not_exists(store_name, store_address, store_website);

            currency_code := record_data.waluta;
            PERFORM validate_parameter_is_not_null(currency_code, 'Currency code');
            currency_description := record_data.opis_waluty;
            v_currency_row := insert_currency_if_not_exists(currency_code, currency_description);

            receipt_total := record_data.suma;
            PERFORM validate_positive_number(receipt_total, 'Receipt total', FALSE);
            receipt_date_string := record_data.data_zakupow;
            PERFORM validate_string_as_date(receipt_date_string);
            receipt_date_date := to_date(receipt_date_string, 'YYYY-MM-DD');
            receipt_is_online := record_data.czy_internetowy;
            PERFORM validate_parameter_is_boolean_type(receipt_is_online, 'Is receipt online');
            receipt_scan := record_data.skan_paragonu;
            v_receipt_row := insert_receipt_if_not_exists(v_store_row.store_id, v_currency_row.currency_id, receipt_total, receipt_date_date, receipt_is_online, receipt_scan);
            
        END LOOP;
        
        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error: %', SQLERRM;
            RETURN FALSE;
    END;
END;
$$ LANGUAGE plpgsql;