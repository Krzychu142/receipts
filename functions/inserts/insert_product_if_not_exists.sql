CREATE OR REPLACE FUNCTION insert_product_if_not_exists(
        p_name VARCHAR(200),
        p_category_id INT,
        p_product_link VARCHAR(255),
        p_is_virtual BOOLEAN,
        p_is_fee BOOLEAN,
        p_description TEXT
    ) 
RETURNS record AS $$
DECLARE
    v_product_row record;
    v_category_row record;
BEGIN
    v_product_row := select_product_by_name_and_category_id(p_name, p_category_id);

    IF v_product_row IS NULL THEN
        v_category_row := select_category_by_id(p_category_id);
        IF v_category_row IS NULL THEN
            RAISE EXCEPTION 'Category with ID % not found. Product name: %', p_category_id, p_name;
        END IF;

        INSERT INTO products (name, category_id, product_link, is_virtual, is_fee, description)
        VALUES (p_name, p_category_id, p_product_link, p_is_virtual, p_is_fee, p_description)
        RETURNING * INTO v_product_row;
    ELSE
    -- LOGIC HERE IS - IF PRODUCT ALREADY HAS A PROPERTY, DO NOT CHANGE IT!
    -- ONLY IF THE PROPERTY IS CURRENTLY NULL AND A NON-NULL VALUE IS PROVIDED AS A PARAMETER
    -- THIS RULE APPLIES ONLY TO OPTIONAL PROPERTIES
        IF (v_product_row.product_link IS NULL 
            OR rtrim(v_product_row.product_link) = '')
            AND (v_product_row.description IS NULL 
            OR rtrim(v_product_row.description) = '')
            AND p_product_link IS NOT NULL 
            AND p_description IS NOT NULL 
        THEN
            v_product_row := update_product_description_and_product_link(v_product_row.product_id, p_description, p_product_link);
        END IF;
        IF (v_product_row.product_link IS NULL 
            OR rtrim(v_product_row.product_link) = '') 
            AND p_product_link IS NOT NULL 
        THEN
            v_product_row := update_product_product_link(v_product_row.product_id, p_product_link);
        END IF;
        IF (v_product_row.description IS NULL 
            OR rtrim(v_product_row.description) = '') 
            AND p_description IS NOT NULL 
        THEN
            v_product_row := update_product_description(v_product_row.product_id, p_description);
        END IF;
    END IF;

    RETURN v_product_row;
END;
$$ LANGUAGE plpgsql;