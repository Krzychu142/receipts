CREATE OR REPLACE FUNCTION insert_unit_if_not_exists(
        p_name VARCHAR(50),
        p_base_unit INT,
        p_conversion_multiplier NUMERIC(10, 4)
    )
RETURNS record AS $$
DECLARE
    v_unit_row record;
BEGIN
    -- CHECK IS UNIT EXIST BY NAME 

    -- IF NOT EXIST CHECK IS BASE UNIT EXIST
        -- IF NOT - RAISE EXCEPTION 
        -- INSERT NEW ONE

    -- IF V_UNIT_ROW.base_unit IS NULL AND p_base_unit IS NOT NULL AND p_conversion_multiplier IS NOT NULL
        --  IF BASE UNIT EXIST
        -- UPDATE base_unit

    RETURN v_unit_row;
END;
$$ LANGUAGE plpgsql;