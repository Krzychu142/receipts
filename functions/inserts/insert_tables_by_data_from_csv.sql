CREATE OR REPLACE FUNCTION insert_tables_by_data_from_csv()
RETURNS BOOLEAN AS $$
DECLARE
    record_data record;
    store_name VARCHAR(180);
    store_address VARCHAR(255);
    store_website VARCHAR(255);
    v_store_row record;
    v_previous_iteration_store_row record;
    currency_code VARCHAR(10);
    currency_description VARCHAR(80);
    v_currency_row record;
    v_previous_iteration_currency_row record;
    receipt_total NUMERIC(10, 2);
    receipt_date_string TEXT;
    receipt_date_date DATE;
    receipt_is_online BOOLEAN;
    receipt_scan TEXT;
    v_receipt_row record;
    v_previous_iteration_receipt_row record;
    category_name VARCHAR(100);
    v_category_row record;
    v_previous_iteration_category_row record;
    product_name VARCHAR(200);
    product_link VARCHAR(255);
    product_is_virtual BOOLEAN;
    product_is_fee BOOLEAN;
    product_description TEXT;
    v_product_row record;
    v_previous_iteration_product_row record;
    unit_name VARCHAR(50);
    v_unit_row record;
    v_previous_iteration_unit_row record;
    purchase_price NUMERIC(10, 2);
    purchase_discount NUMERIC(10, 2);
    purchase_quantity NUMERIC(10, 3);
    purchase_is_warranty BOOLEAN;
    purchase_warranty_expiration_string TEXT;
    purchase_warranty_expiration_date DATE;
    v_purchase_row record;
BEGIN
    BEGIN
        v_previous_iteration_store_row := NULL;
        v_previous_iteration_currency_row := NULL;
        v_previous_iteration_receipt_row := NULL;
        v_previous_iteration_product_row := NULL;
        v_previous_iteration_category_row := NULL;
        v_previous_iteration_unit_row := NULL;
        FOR record_data IN 
            SELECT * FROM csv_plain_data
        LOOP

            store_name := record_data.sklep;
            PERFORM validate_parameter_is_not_null(store_name, 'Store name');
            store_address := COALESCE(record_data.adres, '');
            store_website := COALESCE(record_data.strona_internetowa, '');
            -- IF v_previous_iteration_store_row IS NULL THEN
                v_store_row := insert_store_if_not_exists(store_name, store_address, store_website);
                v_previous_iteration_store_row := v_store_row;
            -- END IF;
            -- IF  v_previous_iteration_store_row.name <> store_name
            --     OR v_previous_iteration_store_row.address  <> store_address
            --     OR v_previous_iteration_store_row.website <> store_website
            -- THEN
                v_store_row := insert_store_if_not_exists(store_name, store_address, store_website);
                v_previous_iteration_store_row := v_store_row;
            -- END IF;
    
            currency_code := record_data.waluta;
            PERFORM validate_parameter_is_not_null(currency_code, 'Currency code');
            currency_description := COALESCE(record_data.opis_waluty, '');
            -- IF v_previous_iteration_currency_row IS NULL THEN
                v_currency_row := insert_currency_if_not_exists(currency_code, currency_description);
                v_previous_iteration_currency_row := v_currency_row;
            -- END IF;
            -- IF  v_previous_iteration_currency_row.code <> currency_code
            --     OR v_previous_iteration_currency_row.description  <> currency_description
            -- THEN
                v_currency_row := insert_currency_if_not_exists(currency_code, currency_description);
                v_previous_iteration_currency_row := v_currency_row;
            -- END IF;

            receipt_total := record_data.suma;
            PERFORM validate_positive_number(receipt_total, 'Receipt total', FALSE);
            receipt_date_string := record_data.data_zakupow;
            PERFORM validate_string_as_date(receipt_date_string);
            receipt_date_date := to_date(receipt_date_string, 'YYYY-MM-DD');
            receipt_is_online := COALESCE(record_data.czy_internetowy, False);
            PERFORM validate_parameter_is_boolean_type(receipt_is_online, 'Is receipt online');
            receipt_scan := COALESCE(record_data.skan_paragonu, '');

            -- IF v_previous_iteration_receipt_row IS NULL THEN
                v_receipt_row := insert_receipt_if_not_exists(v_store_row.store_id, v_currency_row.currency_id, receipt_total, receipt_date_date, receipt_is_online, receipt_scan);
                v_previous_iteration_receipt_row := v_receipt_row;
            -- END IF;
            -- IF  v_previous_iteration_receipt_row.store_id <> v_store_row.store_id
            --     OR v_previous_iteration_receipt_row.currency_id  <> v_currency_row.currency_id
            --     OR v_previous_iteration_receipt_row.total  <> receipt_total
            --     OR v_previous_iteration_receipt_row.receipt_date  <> receipt_date_date
            --     OR v_previous_iteration_receipt_row.is_online  <> receipt_is_online
            --     OR v_previous_iteration_receipt_row.receipt_scan  <> receipt_scan
            -- THEN
                v_receipt_row := insert_receipt_if_not_exists(v_store_row.store_id, v_currency_row.currency_id, receipt_total, receipt_date_date, receipt_is_online, receipt_scan);
                v_previous_iteration_receipt_row := v_receipt_row;
            -- END IF;
    
            category_name := record_data.kategoria;
            PERFORM validate_parameter_is_not_null(category_name, 'Category name');
            -- IF v_previous_iteration_category_row IS NULL THEN
                v_category_row := insert_category_if_not_exists(category_name);
                v_previous_iteration_category_row := v_category_row;
            -- END IF;
            -- IF v_previous_iteration_category_row.name <> category_name THEN
                v_category_row := insert_category_if_not_exists(category_name);
                v_previous_iteration_category_row := v_category_row;
            -- END IF;

            product_name := record_data.nazwa_produktu;
            PERFORM validate_parameter_is_not_null(product_name, 'Product name');
            product_link := COALESCE(record_data.strona_produktu, '');
            product_is_virtual := record_data.czy_wirtualny;
            PERFORM validate_parameter_is_boolean_type(product_is_virtual, 'Is product virtual');
            product_is_fee := record_data.czy_to_oplata;
            PERFORM validate_parameter_is_boolean_type(product_is_fee, 'Is product a fee');
            product_description := COALESCE(record_data.strona_produktu, '');
            -- IF v_previous_iteration_product_row IS NULL THEN
                v_product_row := insert_product_if_not_exists(product_name, v_previous_iteration_category_row.category_id, product_link, product_is_virtual, product_is_fee, product_description);
                v_previous_iteration_product_row := v_product_row;
            -- END IF;
            -- IF v_previous_iteration_product_row.name <> product_name 
            --     OR v_previous_iteration_product_row.category_id <> v_previous_iteration_category_row.category_id 
            --     OR v_previous_iteration_product_row.product_link <> product_link 
            --     OR v_previous_iteration_product_row.description <> product_description 
            -- THEN
                v_product_row := insert_product_if_not_exists(product_name, v_previous_iteration_category_row.category_id, product_link, product_is_virtual, product_is_fee, product_description);
                v_previous_iteration_product_row := v_product_row;
            -- END IF;

            unit_name := record_data.jednostka;
            PERFORM validate_parameter_is_not_null(unit_name, 'Unit name');
            -- IF v_previous_iteration_unit_row IS NULL THEN
                v_unit_row := insert_unit_if_not_exists(unit_name, NULL::INT, NULL::NUMERIC(10, 4));
                v_previous_iteration_unit_row := v_unit_row;
            -- END IF; 
            -- IF v_previous_iteration_unit_row.name <> unit_name THEN
                v_unit_row := insert_unit_if_not_exists(unit_name, NULL::INT, NULL::NUMERIC(10, 4));
                v_previous_iteration_unit_row := v_unit_row;
            -- END IF;

            purchase_price := record_data.cena;
            PERFORM validate_positive_number(purchase_price, 'Purchase price', FALSE);
            purchase_discount := record_data.rabat;
            PERFORM validate_positive_number(purchase_discount, 'Purchase price');
            purchase_quantity := record_data.ilosc;
            PERFORM validate_positive_number(purchase_quantity, 'Purchase quantity', FALSE);
            purchase_is_warranty := record_data.czy_na_gwarancji;
            PERFORM validate_parameter_is_boolean_type(purchase_is_warranty, 'Purchase is on warranty');
            purchase_warranty_expiration_string := record_data.data_gwarancji;
            purchase_warranty_expiration_date := purchase_warranty_expiration_string;
            IF purchase_is_warranty IS TRUE THEN
                PERFORM validate_string_as_date(purchase_warranty_expiration_string);
                purchase_warranty_expiration_date := to_date(purchase_warranty_expiration_string, 'YYYY-MM-DD');
            ELSE
                IF purchase_warranty_expiration_string IS NOT NULL
                    OR purchase_warranty_expiration_string <> ''
                THEN
                    RAISE EXCEPTION 'The warranty date cannot be given if the purchase is marked as without warranty. Purchase price: %, Purchase produkt name: %', purchase_price, v_previous_iteration_product_row.name;
                END IF;
            END IF;

            v_receipt_row := insert_purchase_if_not_exists(
                v_previous_iteration_product_row.product_id,
                v_previous_iteration_unit_row.unit_id,
                v_previous_iteration_receipt_row.receipt_id,
                purchase_price,
                purchase_discount,
                purchase_quantity,
                purchase_is_warranty,
                purchase_warranty_expiration_date
            );

        END LOOP;
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error: %', SQLERRM;
            RETURN FALSE;
    END;
END;
$$ LANGUAGE plpgsql;