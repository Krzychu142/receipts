DROP TABLE IF EXISTS json_data;
CREATE TABLE json_data (
    id SERIAL PRIMARY KEY,
    data jsonb
);

-- psql -d receipt-project -c "\COPY json_data(data) FROM 'data.json'"