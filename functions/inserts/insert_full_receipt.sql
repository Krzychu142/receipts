CREATE OR REPLACE FUNCTION insert_single_receipt(
    store_name VARCHAR(180),
    store_address VARCHAR(255),
    store_website VARCHAR(255),
    currency_code VARCHAR(10),
    currency_description VARCHAR(80),
    receipt_total NUMERIC(10, 2),
    receipt_date_string TEXT,
    receipt_is_online BOOLEAN,
    receipt_scan TEXT,
    category_name VARCHAR(100),
    unit_name VARCHAR(50),
    products purchased_product[],
    product_name VARCHAR(200),
    product_link VARCHAR(255),
    product_is_virtual BOOLEAN,
    product_is_fee BOOLEAN,
    product_description TEXT,
    purchase_price NUMERIC(10, 2),
    purchase_discount NUMERIC(10, 2),
    purchase_quantity NUMERIC(10, 3),
    purchase_is_warranty BOOLEAN,
    purchase_warranty_expiration_string TEXT,
    purchase_warranty_expiration_date DATE
)
RETURNS VOID AS $$
DECLARE
    product_purchase_record purchased_product;
    v_store_row record;
    v_currency_row record;
    v_receipt_row record;
    v_receipt_date_date DATE;
    v_unit_name VARCHAR(50);
    v_base_unit_name VARCHAR(50);
    v_conversion_multiplier NUMERIC(10, 4);
    v_unit_row record;
    v_base_unit_row record;
    v_category_name VARCHAR(100);
    v_category_row record;
    v_product_name VARCHAR(200);
    v_product_link VARCHAR(255);
    v_product_is_virtual BOOLEAN;
    v_product_is_fee BOOLEAN;
    v_product_row record;
BEGIN
    PERFORM validate_parameter_is_not_null(store_name, 'Store name');
    v_store_row := insert_store_if_not_exists(
        store_name,
        COALESCE(store_address, ''),
        COALESCE(store_website, '')
    );

    PERFORM validate_parameter_is_not_null(currency_code, 'Currency code');
    v_currency_row := insert_currency_if_not_exists(
        currency_code,
        COALESCE(currency_description, '')
    );

    PERFORM validate_positive_number(receipt_total, 'Receipt total', FALSE);
    PERFORM validate_string_as_date(receipt_date_string);
    v_receipt_date_date := to_date(receipt_date_string, 'YYYY-MM-DD');
    PERFORM validate_parameter_is_boolean_type(receipt_is_online, 'Is receipt online');

    v_receipt_row := insert_receipt_if_not_exists(
        v_store_row.store_id,
        v_currency_row.currency_id,
        receipt_total,
        v_receipt_date_date,
        receipt_is_online,
        COALESCE(receipt_scan, '')
    );

    FOREACH product_purchase_record IN ARRAY products
    LOOP
        v_unit_name := product_purchase_record.unit_name;
        PERFORM validate_parameter_is_not_null(v_unit_name, 'Unit name');
        v_base_unit_name := product_purchase_record.base_unit_name;
        v_conversion_multiplier := product_purchase_record.conversion_multiplier;
        IF 
            (v_base_unit_name IS NULL AND v_conversion_multiplier IS NOT NULL)
        OR
            (v_base_unit_name IS NOT NULL AND v_conversion_multiplier IS NULL)
        THEN
            RAISE EXCEPTION 'Error in unit %. Base unit and conversion_multiplier must be both provided or both null.', unit_name;
        END IF;

        IF v_base_unit_name IS NOT NULL AND  v_conversion_multiplier IS NOT NULL THEN
            v_base_unit_row := select_unit_by_name(v_base_unit_name);
            IF v_base_unit_row IS NULL THEN
                RAISE EXCEPTION 'Error in unit %. Not found provided base unit: %.', unit_name, v_base_unit_name;
            END IF;
        END IF;

        v_unit_row := insert_unit_if_not_exists(
            v_unit_name,
            v_base_unit_row.unit_id,
            v_conversion_multiplier
        );

        v_category_name := product_purchase_record.category_name;
        PERFORM validate_parameter_is_not_null(v_category_name, 'Category name');
        v_category_row := insert_category_if_not_exists(v_category_name);

        v_product_name := product_purchase_record.product_name;
        PERFORM validate_parameter_is_not_null(v_product_name, 'Product name');
        v_product_link := COALESCE(product_purchase_record.product_link, '');
        v_product_is_virtual := COALESCE(product_purchase_record.is_virtual, FALSE);
        v_product_is_fee := COALESCE(product_purchase_record.is_fee, FALSE);
        v_product_description := COALESCE(product_purchase_record.description, '');

        v_product_row := insert_product_if_not_exists(
            v_product_name,
            v_category_row.category_id,
            v_product_link,
            v_product_is_virtual,
            v_product_description
        );


    END LOOP;
END;
$$ LANGUAGE plpgsql;