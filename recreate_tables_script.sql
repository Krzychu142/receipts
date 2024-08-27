DROP TABLE IF EXISTS stores CASCADE;
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(180) NOT NULL,
    address VARCHAR(255),
    website VARCHAR(255),
    CONSTRAINT unique_name_address UNIQUE (name, address)
);

DROP TABLE IF EXISTS currencies CASCADE;
CREATE TABLE currencies (
    currency_id SERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(80)
);

DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS units CASCADE;
CREATE TABLE units (
    unit_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    base_unit INT NULL,
    conversion_multiplier NUMERIC(10, 4) NULL,
    FOREIGN KEY (base_unit) REFERENCES units(unit_id),
    CHECK (
        (base_unit IS NOT NULL AND conversion_multiplier IS NOT NULL) OR
        (base_unit IS NULL AND conversion_multiplier IS NULL)
    )
);

DROP TABLE IF EXISTS products CASCADE;
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    product_link VARCHAR(255),
    is_virtual BOOLEAN NOT NULL DEFAULT FALSE,
    is_fee BOOLEAN NOT NULL DEFAULT FALSE,
    description TEXT,
    UNIQUE (name, category_id)
);

DROP TABLE IF EXISTS receipts CASCADE;
CREATE TABLE receipts (
    receipt_id SERIAL PRIMARY KEY,
    store_id INT REFERENCES stores(store_id),
    currency_id INT REFERENCES currencies(currency_id),
    total NUMERIC(10, 2) NOT NULL,
    receipt_date DATE NOT NULL,
    is_online BOOLEAN NOT NULL DEFAULT FALSE,
    receipt_scan TEXT,
    CONSTRAINT unique_receipt UNIQUE (store_id, currency_id, total, receipt_date, is_online, receipt_scan)
);

DROP TABLE IF EXISTS purchases CASCADE;
CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    unit_id INT REFERENCES units(unit_id),
    receipt_id INT REFERENCES receipts(receipt_id) ON DELETE CASCADE,
    price NUMERIC(10, 2) NOT NULL,
    discount NUMERIC(10, 2),
    quantity NUMERIC(10, 3) NOT NULL,
    is_warranty BOOLEAN NOT NULL DEFAULT FALSE,
    warranty_expiration_date DATE,
    CHECK (is_warranty = TRUE OR warranty_expiration_date IS NULL),
    CONSTRAINT unique_purchase UNIQUE (product_id, unit_id, receipt_id, price, discount, quantity, is_warranty, warranty_expiration_date)
);