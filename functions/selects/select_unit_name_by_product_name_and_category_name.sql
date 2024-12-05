CREATE OR REPLACE FUNCTION select_unit_name_by_product_name_and_category_name(
    p_product_name VARCHAR(200),
    p_category_name VARCHAR(100)
) RETURNS VARCHAR(50) AS $$
DECLARE
    v_unit_name VARCHAR(50);
BEGIN
    SELECT 
        u.name
    INTO 
        v_unit_name
    FROM 
        products p
        INNER JOIN categories c ON p.category_id = c.category_id
        INNER JOIN purchases pu ON pu.product_id = p.product_id
        INNER JOIN units u ON u.unit_id = pu.unit_id
    WHERE 
        p.name = p_product_name 
        AND c.name = p_category_name
    GROUP BY 
        p.product_id, u.name
    ORDER BY 
        COUNT(pu.purchase_id) DESC
    LIMIT 1;

    RETURN v_unit_name;
END;
$$ LANGUAGE plpgsql;