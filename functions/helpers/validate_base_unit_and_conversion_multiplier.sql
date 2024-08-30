CREATE OR REPLACE FUNCTION validate_base_unit_and_conversion_multiplier(
    p_base_unit INT,
    p_conversion_multiplier NUMERIC(10, 4)
)
RETURNS VOID AS $$
BEGIN
    IF (p_base_unit IS NULL AND p_conversion_multiplier IS NOT NULL)
    OR (p_conversion_multiplier IS NULL AND p_base_unit IS NOT NULL) THEN
        RAISE EXCEPTION 'Bad data provided. Both parameters must have values. p_base_unit: %, p_conversion_multiplier: %', p_base_unit, p_conversion_multiplier;
    END IF;
END;
$$ LANGUAGE plpgsql;
