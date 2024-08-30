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
    v_product_row = select_product_by_name_and_category_id(p_name, p_category_id);

    IF v_product_row IS NULL THEN
        -- NOT EXISTS
        
    ELSE
    -- LOGIC HERE IS - IF PRODUCT ALREADY HAS A PROPERTY, DO NOT CHANGE IT!
    -- ONLY IF THE PROPERTY IS CURRENTLY NULL AND A NON-NULL VALUE IS PROVIDED AS A PARAMETER
    -- THIS RULE APPLIES ONLY TO OPTIONAL PROPERTIES
        IF v_product_row.product_link IS NULL 
            AND v_product_row.description IS NULL 
            AND p_product_link IS NOT NULL 
            AND p_description IS NOT NULL 
        THEN
            -- UPDATE BOTH
        END IF;
        IF v_product_row.product_link IS NULL AND p_product_link IS NOT NULL THEN
            -- UPDATE ONE
        END IF;
        IF v_product_row.description IS NULL AND p_description IS NOT NULL THEN
            -- UPDATE ONE 
        END IF;
    END IF;
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