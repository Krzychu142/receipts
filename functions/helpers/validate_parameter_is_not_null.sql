CREATE OR REPLACE FUNCTION validate_parameter_is_not_null(
    p_parameter_to_validate ANYELEMENT,
    p_parameter_name TEXT
)
RETURNS VOID AS $$
BEGIN
    IF p_parameter_to_validate IS NULL THEN
        RAISE EXCEPTION '% can not be null. % = %',
            p_parameter_name, p_parameter_name, p_parameter_to_validate;
    END IF;
END;
$$ LANGUAGE plpgsql;