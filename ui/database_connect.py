import psycopg2
from psycopg2 import sql
import configparser

def database_connect():
    config = configparser.ConfigParser()
    config.read('config.ini')
    
    connection = None
    
    try:
        connection = psycopg2.connect(
            dbname=config['postgresql']['dbname'],
            user=config['postgresql']['user'],
            password=config['postgresql']['password'],
            host=config['postgresql']['host'],
            port=config['postgresql']['port']
        )
        cursor = connection.cursor()
        
        cursor.execute("SELECT version();")
        db_version = cursor.fetchone()
        print(f"Connected to PostgreSQL database, version: {db_version}")
        
    except Exception as error:
        print(f"Failed to connect to the database: {error}")
    
