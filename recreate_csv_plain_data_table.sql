DROP TABLE IF EXISTS csv_plain_data;
CREATE TABLE csv_plain_data (
    sklep VARCHAR(255),
    data_zakupow DATE,
    suma NUMERIC,
    waluta VARCHAR(10),
    nazwa_produktu VARCHAR(255),
    jednostka VARCHAR(50),
    cena NUMERIC,
    ilosc NUMERIC,
    rabat NUMERIC,
    kategoria VARCHAR(255),
    czy_internetowy BOOLEAN
);

-- \copy csv_plain_data(sklep, data_zakupow, suma, waluta, nazwa_produktu, jednostka, cena, ilosc, rabat, kategoria, czy_internetowy)
-- FROM '/home/krzysiek/projects/receipt-project-sql/data/data.csv'
-- DELIMITER ','
-- CSV HEADER;