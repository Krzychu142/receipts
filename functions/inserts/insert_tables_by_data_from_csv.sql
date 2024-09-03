CREATE OR REPLACE FUNCTION insert_tables_by_data_from_csv()
RETURNS VOID AS $$
DECLARE
    record_data record;
    store_name VARCHAR(180); -- check is it not null
    store_address VARCHAR(255);
    website VARCHAR(255);
BEGIN
    FOR record_data IN 
        SELECT * FROM csv_plain_data
    LOOP
        -- FROM EVERY RECORD WE NEED TO TRY TO CREATE:
        -- store
        -- currencie
        -- category 
        -- unit
        -- product
        -- receipt
        -- purchase

        -- LET TRY FROM RECEIPT - WE NEED STORE AND CURRENCIE, other data are ready to use from csv

        store_name := record_data.sklep;
        store_address := record_data.adres;
        store_website := record_data.strona_internetowa;

    END LOOP;
END;
$$ LANGUAGE plpgsql;