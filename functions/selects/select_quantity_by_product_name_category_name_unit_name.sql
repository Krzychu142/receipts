CREATE OR REPLACE FUNCTION select_quantity_by_product_name_category_name_unit_name(
    p_product_name VARCHAR(200),
    p_category_name VARCHAR(100),
    p_unit_name VARCHAR(50)
) RETURNS NUMERIC(10, 3) AS $$ 
DECLARE
    v_quantity NUMERIC(10, 3);
BEGIN
    SELECT 
        pu.quantity
    INTO
        v_quantity
    FROM 
        products p
        INNER JOIN categories c ON p.category_id = c.category_id
        INNER JOIN purchases pu ON pu.product_id = p.product_id
        INNER JOIN units u ON u.unit_id = pu.unit_id
    WHERE 
        p.name = p_product_name 
        AND c.name = p_category_name
        AND u.name = p_unit_name
    GROUP BY 
        pu.unit_id, pu.product_id, pu.quantity
    ORDER BY 
        COUNT(pu.purchase_id) DESC
    LIMIT 1;

    RETURN v_quantity;
END;
$$ LANGUAGE plpgsql;