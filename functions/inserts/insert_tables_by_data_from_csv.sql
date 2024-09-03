CREATE OR REPLACE FUNCTION insert_tables_by_data_from_csv()
RETURNS VOID AS $$
DECLARE
    record_data record;
    store_name VARCHAR(180);
    store_address VARCHAR(255);
    store_website VARCHAR(255);
    v_store_row record;
BEGIN
    FOR record_data IN 
        SELECT * FROM csv_plain_data
    LOOP
        BEGIN

            store_name := record_data.sklep;
            PERFORM validate_parameter_is_not_null(store_name, 'Store name');
            store_address := COALESCE(record_data.adres, '');
            store_website := record_data.strona_internetowa;

            v_store_row := insert_store_if_not_exists(store_name, store_address, store_website);

        EXCEPTION
            WHEN OTHERS THEN
                RAISE;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;