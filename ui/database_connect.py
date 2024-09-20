import psycopg2
import configparser
import logging

def get_db_connection():
    config = configparser.ConfigParser()
    config.read('config.ini')

    try:
        connection = psycopg2.connect(
            dbname=config['postgresql']['dbname'],
            user=config['postgresql']['user'],
            password=config['postgresql']['password'],
            host=config['postgresql']['host'],
            port=config['postgresql']['port']
        )
        return connection
    except psycopg2.Error as e:
        logging.error(f"Failed to connect to the database: {e}")
        return None

def get_store_names_with_addresses():
    connection = get_db_connection()
    store_entries = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT DISTINCT name, address FROM stores;")
            stores = cursor.fetchall()
            store_entries = [f"{store[0]} - {store[1]}" for store in stores]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch store names and addresses: {e}")
        finally:
            cursor.close()
            connection.close()
    return store_entries

def get_categories():
    connection = get_db_connection()
    categories = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT name FROM categories;")
            cats = cursor.fetchall()
            categories = [cat[0] for cat in cats]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch categories: {e}")
        finally:
            cursor.close()
            connection.close()
    return categories

def get_units():
    connection = get_db_connection()
    units = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT name FROM units;")
            us = cursor.fetchall()
            units = [unit[0] for unit in us]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch units: {e}")
        finally:
            cursor.close()
            connection.close()
    return units

def insert_receipt(receipt):
    connection = get_db_connection()
    if not connection:
        logging.error("No connection to the database.")
        return False
    
    try:
        cursor = connection.cursor()
        
        purchased_products = [
            (
                p['nazwa'],
                p['jednostka'],
                p.get('base_unit_name'),          # base_unit_name
                p.get('conversion_multiplier'),    # conversion_multiplier
                p['kategoria'],
                p['cena'],
                p['rabat'],
                p['ilość'],
                p.get('opis_produktu', ''),
                p['czy_na_gwarancji'],
                p.get('data_gwarancji', ''),
                False,                             # Additional fields if required
                None
            )
            for p in receipt['produkty']
        ]
        
        cursor.execute("""
            SELECT insert_full_data_from_single_receipt(
                %s, %s, %s,
                %s, %s,
                %s, %s, %s, %s, %s
            );
        """, (
            receipt['sklep'],
            receipt['adres'],
            receipt.get('strona_internetowa', ''),
            receipt['waluta'],
            receipt.get('currency_description', ''),  # If needed
            receipt['suma'],
            receipt['data-zakupów'],
            receipt['czy_internetowy'],
            receipt.get('skan_paragonu', ''),
            purchased_products
        ))
        
        connection.rollback() # test rollback
        logging.info("Receipt data successfully saved to the database.")
        return True
    except psycopg2.Error as e:
        connection.rollback()
        logging.error(f"Failed to save receipt data: {e}")
        return False
    finally:
        cursor.close()
        connection.close()
