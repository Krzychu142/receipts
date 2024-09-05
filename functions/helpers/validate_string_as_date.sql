CREATE OR REPLACE FUNCTION validate_string_as_date(
    p_date_string TEXT,
    p_date_format TEXT DEFAULT 'YYYY-MM-DD'
)
RETURNS VOID AS $$
DECLARE
    v_valid_date DATE;
BEGIN
    IF p_date_string IS NULL THEN
        RAISE EXCEPTION 'Date string cannot be NULL';
    END IF;

    BEGIN
        v_valid_date := to_date(p_date_string, p_date_format);
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Invalid date format: % for date string: %', p_date_format, p_date_string;
    END;
END;
$$ LANGUAGE plpgsql;
