
from prompt_user import prompt_receipt_data
from database_connect import insert_receipt
import logging
import json

def main():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    receipt = prompt_receipt_data()
    print("\n--- Entered Receipt Data ---")
    # print(json.dumps(receipt, indent=4, ensure_ascii=False))
    # success = insert_receipt(receipt)
    
    # if success:
        # print("Receipt data has been successfully saved to the database.")
    # else:
        # print("An error occurred while saving receipt data.")

if __name__ == '__main__':
    main()
