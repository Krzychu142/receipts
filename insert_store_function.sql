CREATE OR REPLACE FUNCTION insert_store (
    name VARCHAR,
    address VARCHAR, 
    website VARCHAR
)
RETURNS INTEGER AS $$
DECLARE
    store_id INTEGER;
BEGIN
    -- CHEK IS STORE DOSE NOT EXIST ALREADY IN DB 

    INSERT INTO stores (name, address, website) 
    VALUES (name, address, website)
    RETURNING store_id INTO store_id;

    RETURN store_id;
END; 
$$ LANGUAGE plpgsql;