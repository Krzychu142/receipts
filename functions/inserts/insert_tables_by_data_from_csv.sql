CREATE OR REPLACE FUNCTION insert_tables_by_data_from_csv()
RETURNS VOID AS $$
-- DECLARE
--     record_data record;
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
    END LOOP;
END;
$$ LANGUAGE plpgsql;