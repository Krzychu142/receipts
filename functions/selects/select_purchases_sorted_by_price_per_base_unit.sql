CREATE OR REPLACE FUNCTION select_purchases_sorted_by_price_per_base_unit(product_name_fragment TEXT)
RETURNS TABLE (
    name VARCHAR(200),
    price NUMERIC(10,2),
    discount NUMERIC(10,2),
    store_name VARCHAR(180),
    base_unit_name VARCHAR(50),
    quantity_in_base_unit NUMERIC(10,3),
    store_address VARCHAR(255),
    receipt_date DATE,
    price_after_discount_by_quantity_in_base_unit NUMERIC(10,5)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        sub.name, 
        sub.price, 
        sub.discount, 
        sub.store_name,
        COALESCE(sub.base_unit_name, sub.unit_name) AS base_unit_name,
        sub.quantity_in_base_unit,
        sub.store_address,
        sub.receipt_date,
        ROUND((sub.price - sub.discount) / sub.quantity_in_base_unit, 5) AS price_after_discount_by_quantity_in_base_unit
    FROM (
        SELECT 
            pr.name, 
            pu.price, 
            pu.discount, 
            s.name AS store_name,
            u.name AS unit_name,
            u1.name AS base_unit_name, 
            pu.quantity,
            r.receipt_date,
            ROUND(pu.quantity * COALESCE(u.conversion_multiplier, 1), 3) AS quantity_in_base_unit,
            CASE
                WHEN s.address IS NOT NULL AND s.address <> '' 
                    THEN s.address
                ELSE 'UNKNOWN STORE ADDRESS'
            END AS store_address
        FROM
            products pr 
            JOIN purchases pu ON pu.product_id = pr.product_id
            JOIN receipts r ON r.receipt_id = pu.receipt_id
            JOIN stores s ON s.store_id = r.store_id
            JOIN units u ON u.unit_id = pu.unit_id
            LEFT OUTER JOIN units u1 ON u.base_unit = u1.unit_id
        WHERE 
            pr.name ILIKE '%' || product_name_fragment || '%'
    ) AS sub
    ORDER BY
        price_after_discount_by_quantity_in_base_unit;
END;
$$ LANGUAGE plpgsql;
