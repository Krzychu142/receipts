BEGIN;

SELECT CASE 
    WHEN insert_tables_by_data_from_csv() = FALSE THEN
        ROLLBACK;
    ELSE
        COMMIT;
END;
