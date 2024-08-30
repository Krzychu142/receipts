CREATE OR REPLACE FUNCTION insert_category_if_not_exists(p_name VARCHAR(100))
RETURNS record AS $$
DECLARE
    v_category_row record;
BEGIN
    -- SELECT CATEGORY BY NAME

    -- CHECK IS CATEGORY EXISTS - IF NOT INSERT NEW ONE

    -- RETURN CATEGORY ROW
END;
$$ LANGUAGE plpqsql; 