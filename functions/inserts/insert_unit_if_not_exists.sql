CREATE OR REPLACE FUNCTION insert_unit_if_not_exists(
        p_name VARCHAR(50),
        p_base_unit INT,
        p_conversion_multiplier NUMERIC(10, 4)
    )
RETURNS record AS $$
DECLARE
    v_unit_row record;
    v_base_unit_row record;
BEGIN
    v_unit_row := select_unit_by_name(p_name);

    IF v_unit_row IS NULL THEN
        PERFORM validate_base_unit_and_conversion_multiplier(p_base_unit, p_conversion_multiplier);

        IF p_base_unit IS NOT NULL AND p_conversion_multiplier IS NOT NULL THEN
            v_base_unit_row := select_unit_by_unit_id(p_base_unit);
            IF v_base_unit_row IS NULL THEN
                RAISE EXCEPTION 'Provided base unit does not exist. p_base_unit: %', p_base_unit;  
            END IF;
        END IF;

        INSERT INTO units (name, base_unit, conversion_multiplier)
        VALUES (p_name, p_base_unit, p_conversion_multiplier)
        RETURNING * INTO v_unit_row;
    ELSE
        IF v_unit_row.base_unit IS NULL AND p_base_unit IS NOT NULL AND p_conversion_multiplier IS NOT NULL THEN
            v_unit_row := update_base_unit_and_conversion_multiplier(v_unit_row.unit_id, p_base_unit, p_conversion_multiplier);
        END IF;  
    END IF; 

    RETURN v_unit_row;
END;
$$ LANGUAGE plpgsql;