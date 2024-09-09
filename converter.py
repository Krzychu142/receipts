import json
import csv

with open('data/data.json', 'r') as json_file:
    data = json.load(json_file)

with open('data.csv', 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)

    csv_writer.writerow(['sklep', 'data_zakupow', 'suma', 'skan_paragonu', 'adres', 'waluta', 'opis_waluty', 'nazwa_produktu', 'czy_wirtualny', 'czy_to_oplata', 'opis_produktu', 'strona_produktu', 'jednostka', 'cena', 'ilość', 'rabat', 'kategoria', 'czy_na_gwarancji', 'data_gwarancji', 'czy_internetowy', 'strona_internetowa'])

    for record in data:
        sklep = record['sklep']
        data_zakupow = record['data-zakupów']
        suma = record['suma']
        skan_paragonu = record.get('skan_paragonu', '')
        adres = record.get('adres', '')
        waluta = record['waluta']
        opis_waluty = record.get('opis_waluty', '')
        czy_internetowy = record['czy_internetowy']
        strona_internetowa = record.get('strona_internetowa', '')

        for produkt in record['produkty']:
            nazwa_produktu = produkt['nazwa']
            czy_wirtualny = produkt.get('czy_wirtualny', False)
            czy_to_oplata = produkt.get('czy_to_oplata', False)
            opis_produktu = produkt.get('opis_produktu', '')
            strona_produktu = produkt.get('strona_produktu', '')
            jednostka = produkt['jednostka']
            cena = produkt['cena']
            ilosc = produkt['ilość']
            rabat = produkt.get('rabat', 0)
            kategoria = produkt['kategoria']
            czy_na_gwarancji = produkt.get('czy_na_gwarancji', False)
            data_gwarancji = produkt.get('data_gwarancji', None)

            csv_writer.writerow([sklep, data_zakupow, suma, skan_paragonu, adres, waluta, opis_waluty, nazwa_produktu, czy_wirtualny, czy_to_oplata,  opis_produktu, strona_produktu, jednostka, cena, ilosc, rabat, kategoria, czy_na_gwarancji, data_gwarancji, czy_internetowy, strona_internetowa])
