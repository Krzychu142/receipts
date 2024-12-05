CREATE OR REPLACE FUNCTION select_all_optional_product_property_by_product_name_and_category_name(
    p_product_name VARCHAR(200),
    p_category_name  VARCHAR(100),
    OUT v_product_link VARCHAR(255),
    OUT v_is_virtual BOOLEAN,
    OUT v_is_fee BOOLEAN,
    OUT v_description TEXT
) AS $$
BEGIN
    SELECT 
        p.product_link, p.is_virtual, p.is_fee, p.description
    INTO
        v_product_link, v_is_virtual, v_is_fee, v_description
    FROM
        products p
        INNER JOIN categories c ON c.category_id = p.category_id
    WHERE
        p.name = p_product_name
        AND c.name = p_category_name;
END;
$$ LANGUAGE plpgsql;