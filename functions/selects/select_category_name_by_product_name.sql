CREATE OR REPLACE FUNCTION select_category_name_by_product_name(
    p_product_name TEXT
) RETURNS TEXT AS $$
DECLARE
    v_category_name TEXT;
BEGIN
    SELECT 
        c.name
    INTO 
        v_category_name
    FROM 
        products p
        INNER JOIN categories c ON p.category_id = c.category_id
        INNER JOIN purchases pu ON pu.product_id = p.product_id
    WHERE 
        p.name=p_product_name
    GROUP BY
        c.name, c.category_id
    ORDER BY
        COUNT(pu.purchase_id) DESC
    LIMIT 1;

    RETURN v_category_name;
END;
$$ LANGUAGE plpgsql;