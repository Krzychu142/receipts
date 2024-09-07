CREATE OR REPLACE FUNCTION validate_parameter_is_boolean_type(
    p_parameter_to_validate ANYELEMENT,
    p_parameter_name TEXT
)
RETURNS VOID AS $$
BEGIN
    PERFORM validate_parameter_is_not_null(p_parameter_to_validate, p_parameter_name);
    IF pg_typeof(p_parameter_to_validate) <> 'boolean' THEN
        RAISE EXCEPTION '% must be boolean type. % = %',
        p_parameter_name, p_parameter_name, p_parameter_to_validate;
    END IF;
END;
$$ LANGUAGE plpgsql;