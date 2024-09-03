import json
import csv

with open('data/data.json', 'r') as json_file:
    data = json.load(json_file)

with open('data.csv', 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)

    csv_writer.writerow(['sklep', 'data_zakupow', 'suma', 'adres', 'waluta', 'opis_waluty', 'nazwa_produktu', 'jednostka', 'cena', 'ilość', 'rabat', 'kategoria', 'czy_internetowy', 'strona_internetowa'])

    for record in data:
        sklep = record['sklep']
        data_zakupow = record['data-zakupów']
        suma = record['suma']
        adres = record.get('adres', '')
        waluta = record['waluta']
        opis_waluty = record.get('opis_waluty', '')
        czy_internetowy = record['czy_internetowy']
        strona_internetowa = record.get('strona_internetowa', '')

        for produkt in record['produkty']:
            nazwa_produktu = produkt['nazwa']
            jednostka = produkt['jednostka']
            cena = produkt['cena']
            ilosc = produkt['ilość']
            rabat = produkt.get('rabat', '')
            kategoria = produkt['kategoria']

            csv_writer.writerow([sklep, data_zakupow, suma, adres, waluta, opis_waluty, nazwa_produktu, jednostka, cena, ilosc, rabat, kategoria, czy_internetowy, strona_internetowa])
