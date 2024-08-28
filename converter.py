import json
import csv

with open('data.json', 'r') as json_file:
    data = json.load(json_file)

with open('data.csv', 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)

    csv_writer.writerow(['sklep', 'data_zakupow', 'suma', 'waluta', 'nazwa_produktu', 'jednostka', 'cena', 'ilość', 'rabat', 'kategoria', 'czy_internetowy'])

    for record in data:
        sklep = record['sklep']
        data_zakupow = record['data-zakupów']
        suma = record['suma']
        waluta = record['waluta']
        czy_internetowy = record['czy_internetowy']

        for produkt in record['produkty']:
            nazwa_produktu = produkt['nazwa']
            jednostka = produkt['jednostka']
            cena = produkt['cena']
            ilosc = produkt['ilość']
            rabat = produkt.get('rabat', '')
            kategoria = produkt['kategoria']

            csv_writer.writerow([sklep, data_zakupow, suma, waluta, nazwa_produktu, jednostka, cena, ilosc, rabat, kategoria, czy_internetowy])
