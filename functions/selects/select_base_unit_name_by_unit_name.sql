CREATE OR REPLACE FUNCTION select_base_unit_name_and_conversion_multiplier_by_unit_name(
    p_unit_name VARCHAR(50),
    OUT base_unit_name VARCHAR(50),
    OUT conversion_multiplier NUMERIC(10,4)
) AS $$
BEGIN
    SELECT
        u2.name, u.conversion_multiplier 
    INTO 
        base_unit_name, conversion_multiplier
    FROM
        units u
    INNER JOIN
        units u2 ON u2.unit_id = u.base_unit
    WHERE 
        u.name = p_unit_name;
END;
$$ LANGUAGE plpgsql;