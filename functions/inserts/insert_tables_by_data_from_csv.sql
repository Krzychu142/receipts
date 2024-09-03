CREATE OR REPLACE FUNCTION insert_tables_by_data_from_csv()
RETURNS void $$
DECLARE
    record_data record;
BEGIN
    FOR record_data IN 
        SELECT * FROM csv_plain_data
    LOOP
    END LOOP;
END;
$$ LANGUAGE plpgsql;