CREATE OR REPLACE FUNCTION update_base_unit_and_conversion_multiplier(
        p_unit_id,
        p_base_unit INT,
        p_conversion_multiplier NUMERIC(10, 4)
)
RETURNS record AS $$
DECLARE
    v_unit_row record;
BEGIN
    PERFORM validate_base_unit_and_conversion_multiplier(p_base_unit, p_conversion_multiplier);

    UPDATE units
    SET base_unit = p_base_unit, conversion_multiplier = p_conversion_multiplier
    WHERE unit_id = p_unit_id
    RETURNING * INTO v_unit_row;

    RETURN v_unit_row;
END;
$$ LANGUAGE plpgsql;