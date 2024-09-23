import psycopg2
from psycopg2.extras import register_composite
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
    category_name = None
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

def get_unit_name_by_product_name_and_category_name(product_name, category_name):
    connection = get_db_connection()
    unit_name = None
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT select_unit_name_by_product_name_and_category_name(%s, %s);", (product_name, category_name))
                result = cursor.fetchone()
                unit_name = result[0]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return unit_name

def get_quantity_by_product_name_category_name_unit_name(product_name, category_name, unit_name):
    connection = get_db_connection()
    quantity = None
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT select_quantity_by_product_name_category_name_unit_name(%s, %s, %s);", (product_name, category_name, unit_name))
                result = cursor.fetchone()
                quantity = result[0]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return quantity

def get_website_by_store_name_and_address(store_name, store_address):
    connection = get_db_connection()
    website = ''
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT website FROM stores WHERE name=%s AND address=%s", (store_name, store_address))
                result = cursor.fetchone()
                website = result[0]
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return website


def get_all_optional_product_property_by_name_and_category(product_name, category_name):
    connection = get_db_connection()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT v_product_link, v_is_virtual, v_is_fee, v_description FROM select_all_optional_product_property_by_product_name_and_category_name(%s, %s);", (product_name, category_name))
                result = cursor.fetchone()
                if result:
                    product_link, is_virtual, is_fee, description = result
                    return product_link, is_virtual, is_fee, description
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return None, None, None, None

def get_unit_id_by_name(unit_name):
    connection = get_db_connection()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT unit_id FROM units WHERE name=%s;", (unit_name, ))
                result = cursor.fetchone()
                if result:
                    unit_id = result[0]
                    return unit_id
        except psycopg2.Error as e:
            logging.error(f"Failed to fetch currency description: {e}")
        finally:
            connection.close()
    
    return None

def insert_new_unit_and_return_id(unit_name):
    connection = get_db_connection()
    if connection:
        try:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT insert_unit_if_not_exists(%s, %s, %s);
                """, (unit_name, None, None))

                result = cursor.fetchone()
                if result:
                    unit_row = result[0]
                    unit_id = unit_row['unit_id'] 
                    return unit_id
        except psycopg2.Error as e:
            logging.error(f"Failed to insert or fetch unit: {e}")
        finally:
            connection.close()

    return None


def insert_receipt(receipt):
    connection = get_db_connection()
    if not connection:
        logging.error("No connection to the database.")
        return False

    try:
        cursor = connection.cursor()

        register_composite('purchased_product', cursor)

        calculated_total = 0
        purchased_products = []
        for p in receipt['products']:
            price = float(p['price'])
            discount = float(p['discount'])
            quantity = float(p['quantity'])
            product_total = (price - discount)
            calculated_total += product_total

            purchased_product = (
                p['product_name'],
                p['unit_name'],
                p.get('base_unit_name', None),
                p.get('conversion_multiplier', None),
                p['category_name'],
                price,
                discount,
                quantity,
                p.get('product_link', ''),
                p.get('product_is_virtual', False),
                p.get('product_is_fee', False),
                p.get('product_description', ''),
                p.get('is_warranty', False),
                p.get('warranty_expiration_date', None)
            )
            purchased_products.append(purchased_product)

        calculated_total = round(calculated_total, 2)

        receipt_total = float(receipt['total'])

        if calculated_total != receipt_total:
            raise ValueError(f"Total value of products ({calculated_total}) does not match receipt total ({receipt_total}).")

        cursor.execute("""
            SELECT insert_full_data_from_single_receipt(
                %s, %s, %s,
                %s, %s,
                %s, %s, %s, %s, %s::purchased_product[]
            );
        """, (
            receipt['store_name'],
            receipt.get('store_address', ''),
            receipt.get('store_website', ''),
            receipt['currency_code'],
            receipt.get('currency_description', ''),
            receipt['total'],
            receipt['receipt_date_string'],
            receipt['receipt_is_online'],
            receipt.get('receipt_scan', ''),
            purchased_products
        ))

        connection.commit()
        logging.info("Receipt data successfully saved to the database.")
        return True
    except ValueError as ve:
        logging.error(f"Validation error: {ve}")
        return False
    except psycopg2.Error as e:
        connection.rollback()
        logging.error(f"Failed to save receipt data: {e}")
        return False
    finally:
        cursor.close()
        connection.close()
