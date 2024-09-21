
from database_connect import insert_receipt, get_store_names_with_addresses, get_categories, get_units, get_store_names, get_address_by_name
from prompt_toolkit.shortcuts import button_dialog, message_dialog, input_dialog, yes_no_dialog
from prompt_toolkit import PromptSession
from prompt_toolkit.completion import WordCompleter
from prompt_toolkit.validation import Validator, ValidationError
from prompt_toolkit.key_binding import KeyBindings
import sys
import datetime

class NotEmptyValidator(Validator):
    def validate(self, document):
        if not document.text.strip():
            raise ValidationError(
                message='Field can not be empty.',
                cursor_position=len(document.text)
            )


class NumericValidator(Validator):
    def validate(self, document):
        try:
            float(document.text)
        except ValueError:
            raise ValidationError(
                message='Please enter a valid number.',
                cursor_position=len(document.text)
            )

class DateValidator(Validator):
    def validate(self, document):
        try:
            datetime.datetime.strptime(document.text, '%Y-%m-%d')
        except ValueError:
            raise ValidationError(
                message='Please enter the date in YYYY-MM-DD format.',
                cursor_position=len(document.text)
            )

class YesNoValidator(Validator):
    def validate(self, document):
        if document.text.lower() not in ['t', 'n']:
            raise ValidationError(
                message='Please enter "t" or "n".',
                cursor_position=len(document.text)
            )

class CurrencyValidator(Validator):
    def validate(self, document):
        valid_currencies = ['PLN', 'USD', 'EUR', 'GBP', 'CHF']
        if document.text.upper() not in valid_currencies:
            raise ValidationError(
                message='Please enter a valid currency (e.g., PLN, USD, EUR).',
                cursor_position=len(document.text)
            )

def main():
    receipt= {}
    session = PromptSession()

    yes_no_completer = WordCompleter(['t', 'n'], ignore_case=True)
    
    store_names= get_store_names()
    store_completer = WordCompleter(store_names, ignore_case=True)

    receipt['sklep'] = session.prompt(
        'Store name: ',
        completer=store_completer,
        validator=NotEmptyValidator(),
        validate_while_typing=True
    ).lower()

    print(receipt['sklep'])
    addresses = get_address_by_name(receipt['sklep'])
    addresses_completer = WordCompleter(addresses, ignore_case=True)

    session = PromptSession()
    receipt['adres'] = session.prompt(
        'Store address: ',
        completer=addresses_completer
    )

    print(receipt['adres'])
    session = PromptSession()
    receipt['czy_internetowy'] = session.prompt(
        'Was the purchase online? (t/n): ',
        completer=yes_no_completer,
        validator=YesNoValidator(),
        validate_while_typing=False
    )

    print(receipt['czy_internetowy'])

if __name__ == '__main__':
    main()
