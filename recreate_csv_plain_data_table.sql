DROP TABLE IF EXISTS csv_plain_data;
CREATE TABLE csv_plain_data (
    sklep VARCHAR(255),
    data_zakupow DATE,
    suma NUMERIC,
    skan_paragonu TEXT,
    adres VARCHAR(255),
    waluta VARCHAR(10),
    opis_waluty VARCHAR(80),
    nazwa_produktu VARCHAR(255),
    jednostka VARCHAR(50),
    cena NUMERIC,
    ilosc NUMERIC,
    rabat NUMERIC,
    kategoria VARCHAR(255),
    czy_internetowy BOOLEAN,
    strona_internetowa VARCHAR(255)
);

-- \copy csv_plain_data(sklep, data_zakupow, suma, skan_paragonu, adres, waluta, opis_waluty,  nazwa_produktu, jednostka, cena, ilosc, rabat, kategoria, czy_internetowy, strona_internetowa)
-- FROM '/home/krzysiek/projects/receipt-project-sql/data/data.csv'
-- DELIMITER ','
-- CSV HEADER;