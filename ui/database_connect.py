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

def get_store_names():
    connection = get_db_connection()
    store_names = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT DISTINCT name FROM stores ORDER BY name ASC;")
            stores = cursor.fetchall()
            store_names = [store[0] for store in stores]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch store names: {e}")
        finally:
            cursor.close()
            connection.close()
    return store_names

def get_address_by_name(store_name):
    connection = get_db_connection()
    addresses = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT address FROM stores WHERE name=%s;", (store_name,))
            addresses_result = cursor.fetchall()
            addresses = [address[0] for address in addresses_result]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch store addresses: {e}")
        finally:
            cursor.close()
            connection.close()
    return addresses

def get_all_distinct_categories_names():
    connection = get_db_connection()
    categories = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT DISTINCT name FROM categories;")
            cats = cursor.fetchall()
            categories = [cat[0] for cat in cats]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch categories: {e}")
        finally:
            cursor.close()
            connection.close()
    return categories

def get_distinct_units_names():
    connection = get_db_connection()
    units = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT DISTINCT name FROM units;")
            us = cursor.fetchall()
            units = [unit[0] for unit in us]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch units: {e}")
        finally:
            cursor.close()
            connection.close()
    return units

def get_currencies_codes():
    connection = get_db_connection()
    currencies_codes = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT code FROM currencies;")
            currencies_codes_result = cursor.fetchall()
            currencies_codes = [code[0] for code in currencies_codes_result]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currencies codes: {e}")
        finally:
            cursor.close()
            connection.close()
    return currencies_codes

def get_currency_description_by_code(code):
    connection = get_db_connection()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT select_currency_description_by_code(%s);", (code,))
                result = cursor.fetchone()
                currency_description = result[0]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return currency_description

def get_all_distinct_products_names():
    connection = get_db_connection()
    products_names = []
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT DISTINCT name FROM products ORDER BY name ASC;")
            products_names_result = cursor.fetchall()
            products_names = [product[0] for product in products_names_result]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch products codes: {e}")
        finally:
            cursor.close()
            connection.close()
    return products_names

def get_base_unit_name_and_conversion_multiplier_by_unit_name(unit_name):
    connection = get_db_connection()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT base_unit_name, conversion_multiplier FROM select_base_unit_name_and_conversion_multiplier_by_unit_name(%s);", (unit_name,))
                result = cursor.fetchone()
                if result:
                    base_unit_name, conversion_multiplier = result
                    return base_unit_name, conversion_multiplier
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return None, None

def get_category_name(product_name):
    connection = get_db_connection()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT select_category_name_by_product_name(%s);", (product_name,))
                result = cursor.fetchone()
                category_name = result[0]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return category_name

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
