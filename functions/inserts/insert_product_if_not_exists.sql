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
BEGIN
    -- SELECT product by name and category_id 
    
    -- IF EXISTS 
        -- CHECK IS P_DESCRIPTION IS NOT NULL AND row.DESCRIPTION IS NULL
        -- UPDATE DESC
        -- CHECK IS P_PRODUCT_LINK IS NOT NULL AND row.P_PRODUCT_LINK IS NULL
        -- UPDATE PRODUCT_LINK
    -- IF NOT EXISTS
        -- CHECK IS CATEGORY WITH THIS CATEGORY_ID EXISTS
            -- IF NOT - RAISE EXCEPTION
        -- INSERT NEW PRODUCT

    RETURN v_product_row;
END;
$$ LANGUAGE plpqsql;