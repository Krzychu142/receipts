CREATE TYPE purchased_product AS (
    product_name VARCHAR(200),
    unit_name VARCHAR(50),
    base_unit_name VARCHAR(50),
    conversion_multiplier NUMERIC(10, 4),
    category_name VARCHAR(100),
    price NUMERIC(10, 2),
    discount NUMERIC(10, 2),
    quantity NUMERIC(10, 3),
    product_link VARCHAR(255),
    product_is_virtual BOOLEAN,
    product_is_fee BOOLEAN,
    product_description TEXT,
    is_warranty BOOLEAN,
    warranty_expiration_date DATE
);