BEGIN;

SELECT insert_tables_by_data_from_csv();

COMMIT;

ROLLBACK;
