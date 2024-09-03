CREATE OR REPLACE FUNCTION validate_positive_number(
    p_number_to_validate NUMERIC,
    p_name_of_validating_parametr TEXT,
    p_is_zero_posibble BOOLEAN DEFAULT TRUE 
)
RETURNS VOID AS $$
BEGIN
    IF p_is_zero_posibble = FALSE AND p_number_to_validate <= 0 THEN
        RAISE EXCEPTION 'Value of % cannot be less than or equal to 0. % = %', 
                        p_name_of_validating_parametr, p_name_of_validating_parametr, p_number_to_validate;
    END IF;

    IF p_number_to_validate < 0 THEN
        RAISE EXCEPTION 'Value of % cannot be less than 0. % = %', 
                        p_name_of_validating_parametr, p_name_of_validating_parametr, p_number_to_validate;
    END IF;
END;
$$ LANGUAGE plpgsql;
