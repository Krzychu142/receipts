CREATE OR REPLACE FUNCTION validate_total_compare_to_sum_of_prices(
    p_purchased_products purchased_product[],
    receipt_total NUMERIC(10, 2)
)
RETURNS VOID AS $$
DECLARE
    v_product_purchase_record purchased_product;
    v_sum_of_prices NUMERIC(10, 2);
    v_sum_of_discounts NUMERIC(10, 2);
BEGIN
    v_sum_of_prices := 0.00;
    v_sum_of_discounts := 0.00;

    FOREACH v_product_purchase_record IN ARRAY p_purchased_products
    LOOP
        v_sum_of_prices := v_sum_of_prices + v_product_purchase_record.price;
        v_sum_of_discounts := v_sum_of_discounts + v_product_purchase_record.discount;
    END LOOP;

    v_sum_of_prices := ROUND(v_sum_of_prices, 2);
    v_sum_of_discounts := ROUND(v_sum_of_discounts, 2);

    IF receipt_total <> (v_sum_of_prices - v_sum_of_discounts) THEN
        RAISE EXCEPTION 'The total amount of the receipt (%.2f) does not equal the sum of product prices minus discounts (%.2f).', receipt_total, (v_sum_of_prices - v_sum_of_discounts);
    END IF;
END;
$$ LANGUAGE plpgsql;
