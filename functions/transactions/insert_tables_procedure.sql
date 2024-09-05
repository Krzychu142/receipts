DO $$
BEGIN
    BEGIN
        PERFORM insert_tables_by_data_from_csv();
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE NOTICE 'Transaction rolled back due to an error: %', SQLERRM;
    END;
END $$;
