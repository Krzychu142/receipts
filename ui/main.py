
from database_connect import insert_receipt, get_all_distinct_categories_names, get_distinct_units_names, get_store_names, get_address_by_name, get_currencies_codes, get_currency_description_by_code, get_all_distinct_products_names, get_base_unit_name_and_conversion_multiplier_by_unit_name, get_category_name, get_unit_name_by_product_name_and_category_name
from prompt_toolkit.shortcuts import button_dialog, message_dialog, input_dialog, yes_no_dialog
from prompt_toolkit import PromptSession
from prompt_toolkit.completion import WordCompleter
from prompt_toolkit.validation import Validator, ValidationError
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.document import Document
import sys
import datetime
import json

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
        valid_currencies = ['pln', 'usd', 'eur', 'gbp', 'chf']
        if document.text.lower() not in valid_currencies:
            raise ValidationError(
                message='Please enter a valid currency (e.g., pln, usd, eur).',
                cursor_position=len(document.text)
            )
        
def convert_t_n_into_bool(t_n):
    if t_n == 't':
        return True
    return False

def main():
    receipt= {}
    session = PromptSession()

    yes_no_completer = WordCompleter(['t', 'n'], ignore_case=True)
    
    store_names= get_store_names()
    store_completer = WordCompleter(store_names, ignore_case=True)

    receipt['store_name'] = session.prompt(
        'Store name: ',
        completer=store_completer,
        validator=NotEmptyValidator(),
        validate_while_typing=True
    ).lower()

    addresses = get_address_by_name(receipt['store_name'])
    addresses_completer = WordCompleter(addresses, ignore_case=True)

    session = PromptSession()
    receipt['store_address'] = session.prompt(
        'Store address (optional): ',
        completer=addresses_completer
    )

    session = PromptSession()
    receipt['receipt_is_online'] = convert_t_n_into_bool(session.prompt(
        'Was the purchase online? (t/n): ',
        completer=yes_no_completer,
        default='n',
        validator=YesNoValidator(),
        validate_while_typing=False
    ))

    # TODO: try to select store_website if exists based on name and address (uniq combination)
    session = PromptSession()
    receipt['store_website'] = session.prompt(
        'Website of store (optional): ',
        default=''
    ).lower()
    
    bindings = KeyBindings()
    @bindings.add(' ')
    def _(event):
        buffer = event.app.current_buffer
        new_value = datetime.date.today().isoformat()
        buffer.document = Document(text=new_value, cursor_position=len(new_value))

    session = PromptSession(key_bindings=bindings)
    receipt['receipt_date_string'] = session.prompt(
        'Enter purchase date (YYYY-MM-DD)\n(Type space for today date): ',
        validator=DateValidator(),
        validate_while_typing=True
    )

    currencies_codes = get_currencies_codes()
    currencies_codes_completer = WordCompleter(currencies_codes, ignore_case=True)

    session = PromptSession()
    receipt['currency_code'] = session.prompt(
        'Enter the currency code of receipt: ',
        validator=CurrencyValidator(),
        validate_while_typing=False,
        completer=currencies_codes_completer,
        default='pln'
    ).lower()

    currency_description = get_currency_description_by_code(receipt['currency_code'])

    session = PromptSession()
    receipt['currency_description'] = session.prompt(
        'Enter the currency description (optional): ',
        default=currency_description if currency_description else ''
    ).lower()

    session = PromptSession()
    receipt['receipt_scan'] = session.prompt(
        'Link to the receipt scan photo (optional): ',
        default=''
    ).lower()

    session = PromptSession()
    receipt['total'] = float(session.prompt(
        'Total value from receipt: ',
        validator=NumericValidator(),
        validate_while_typing=True
    ))

    receipt['produkty'] = []
    all_distinct_products_names = get_all_distinct_products_names()
    product_name_completer = WordCompleter(all_distinct_products_names, ignore_case=True)
    while True:
        product = {}
        print("\n--- Adding a New Purchase/Product ---")
        session = PromptSession()
        product['product_name'] = session.prompt(
            'Enter product name: ',
            validator=NotEmptyValidator(),
            validate_while_typing=True,
            completer=product_name_completer
        ).lower()

        all_distinct_categories_names = get_all_distinct_categories_names()
        categories_name_completer = WordCompleter(all_distinct_categories_names, ignore_case=True)

        category_name = get_category_name(product['product_name'])
        session = PromptSession()
        product['category_name'] = session.prompt(
            'Entry category name: ',
            validator=NotEmptyValidator(),
            validate_while_typing=True,
            completer=categories_name_completer,
            default=category_name if category_name else ''
        ).lower()

        all_distinct_units_names = get_distinct_units_names()
        unit_name_completer = WordCompleter(all_distinct_units_names, ignore_case=True)
        default_unit = get_unit_name_by_product_name_and_category_name(product['product_name'], product['category_name'])
        session = PromptSession()
        product['unit_name'] = session.prompt(
            'Enter unit name: ',
            validator=NotEmptyValidator(),
            validate_while_typing=True,
            completer=unit_name_completer,
            default=default_unit if default_unit else ''
        ).lower()

        (base_unit_name, conversion_multiplier) = get_base_unit_name_and_conversion_multiplier_by_unit_name(product['unit_name'])

        session = PromptSession()
        product['base_unit_name'] = session.prompt(
            'Enter base unit (optional): ',
            default=base_unit_name if base_unit_name else ''
        ).lower()

        session = PromptSession()
        product['conversion_multiplier'] = session.prompt(
            'Enter conversion multiplier: ',
            validator=NumericValidator() if base_unit_name else None,
            default=str(conversion_multiplier) if base_unit_name else '',
            accept_default=False if base_unit_name else True
        )

        if product['base_unit_name'] != '':
            if product['conversion_multiplier'] != '':
                product['conversion_multiplier'] = float(product['conversion_multiplier'])
            else:
                product['conversion_multiplier'] = None
        else:
            product['base_unit_name'] = None
            product['conversion_multiplier'] = None

        #TODO: price, discount, quantity product_link, product_is_virtual, product_is_fee, product_description, is_warranty, warranty_expiration_date
        session = PromptSession()
        product['price'] = session.prompt(
            'Enter price: ',
            validator=NumericValidator()
        )

        product['discount'] = session.prompt(
            'Enter discount: ',
            validator=NumericValidator(),
            default='0.00'
        )

    formatted_json = json.dumps(receipt, indent=4, ensure_ascii=False)
    print(formatted_json)

if __name__ == '__main__':
    main()
