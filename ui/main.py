
from database_connect import insert_receipt, get_all_distinct_categories_names, get_distinct_units_names, get_store_names, get_address_by_name, get_currencies_codes, get_currency_description_by_code, get_all_distinct_products_names, get_base_unit_name_and_conversion_multiplier_by_unit_name, get_category_name, get_unit_name_by_product_name_and_category_name, get_quantity_by_product_name_category_name_unit_name, get_website_by_store_name_and_address, get_all_optional_product_property_by_name_and_category
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

    default_website = get_website_by_store_name_and_address(receipt['store_name'], receipt['store_address'])
    session = PromptSession()
    receipt['store_website'] = session.prompt(
        'Website of store (optional): ',
        default=default_website if default_website else ''
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

        session = PromptSession()
        product['price'] = session.prompt(
            'Enter price: ',
            validator=NumericValidator()
        )

        session = PromptSession()
        product['discount'] = session.prompt(
            'Enter discount: ',
            validator=NumericValidator(),
            default='0.00'
        )

        default_quantity = get_quantity_by_product_name_category_name_unit_name(
            product['product_name'],
            product['category_name'],
            product['unit_name']
        )

        session = PromptSession()
        product['quantity'] = session.prompt(
            'Enter quantity: ',
            default=str(default_quantity) if default_quantity else '',
            validator=NumericValidator(),
            validate_while_typing=True
        )

        (product_link, is_virtual, is_fee, description) = get_all_optional_product_property_by_name_and_category(product['product_name'], product['category_name'])

        session = PromptSession()
        product['product_link'] = session.prompt(
            'Enter product link (optional): ',
            default=product_link if product_link else ''
        ).lower()

        session = PromptSession()
        product['product_is_virtual'] = convert_t_n_into_bool(session.prompt(
            'Is product virtual? (t/n): ',
            default='t' if is_virtual else 'n',
            validator=YesNoValidator(),
            validate_while_typing=False
        ))

        session = PromptSession()
        product['product_is_fee'] = convert_t_n_into_bool(session.prompt(
            'Is product a fee? (t/n): ',
            default='t' if is_fee else 'n',
            validator=YesNoValidator(),
            validate_while_typing=False
        ))

        session = PromptSession()
        product['product_description'] = session.prompt(
            'Product description (optional): ',
            default=description if description else ''
        ).lower()

        session = PromptSession()
        product['is_warranty'] = convert_t_n_into_bool(session.prompt(
            'Did You get warranty for this purchase? (t/n): ',
            default='n'
        ))

        session = PromptSession()
        product['warranty_expiration_date'] = session.prompt(
            'Warranty date: ',
            validator=DateValidator() if product['is_warranty'] else None,
            validate_while_typing=False,
            default='',
            accept_default=False if product['is_warranty'] else True
        )

        receipt['produkty'].append(product)

        bindings = KeyBindings()
        @bindings.add('c-i')
        def _(event):
            formatted_json = json.dumps(receipt, indent=4, ensure_ascii=False)
            print(formatted_json)

        session = PromptSession(key_bindings=bindings)
        next_product = convert_t_n_into_bool(session.prompt(
            '(Show object - Ctr i)\nDo You want to add another product? (t/n): ',
            validate_while_typing=False,
            validator=YesNoValidator()
        ))

        if next_product:
            continue
        else:
            break


    formatted_json = json.dumps(receipt, indent=4, ensure_ascii=False)
    print(formatted_json)

if __name__ == '__main__':
    main()
