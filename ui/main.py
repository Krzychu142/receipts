
from database_connect import insert_receipt, get_store_names_with_addresses, get_categories, get_units
from prompt_toolkit.shortcuts import button_dialog, message_dialog, input_dialog, yes_no_dialog
from prompt_toolkit import PromptSession
from prompt_toolkit.completion import WordCompleter
from prompt_toolkit.validation import Validator, ValidationError
from prompt_toolkit.key_binding import KeyBindings
import sys

def main():
    while True:
        result = yes_no_dialog(
            title='Welcome in receipt project.',
            text='Do you want to add a new RECEIPT?'
        ).run()
        
        if not result:
            break

if __name__ == '__main__':
    main()
