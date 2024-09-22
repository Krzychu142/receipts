CREATE OR REPLACE FUNCTION select_base_unit_name_by_unit_name(
    p_unit_name VARCHAR(50)
) RETURNS TEXT AS $$
DECLARE
    v_base_unit_name TEXT;
BEGIN
    SELECT
        u2.name INTO v_base_unit_name
    FROM
        units u
    INNER JOIN
        units u2 ON u2.unit_id = u.base_unit
    WHERE 
        u.name = p_unit_name;
    
    RETURN v_base_unit_name;
END;
$$ LANGUAGE plpgsql;