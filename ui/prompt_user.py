# from prompt_toolkit import PromptSession
# from prompt_toolkit.completion import WordCompleter
# from prompt_toolkit.validation import Validator, ValidationError
# from database_connect import get_store_names_with_addresses, get_categories, get_units
# import logging
# import datetime

# class NumericValidator(Validator):
#     def validate(self, document):
#         try:
#             float(document.text)
#         except ValueError:
#             raise ValidationError(
#                 message='Please enter a valid number.',
#                 cursor_position=len(document.text)
#             )

# class DateValidator(Validator):
#     def validate(self, document):
#         try:
#             datetime.datetime.strptime(document.text, '%Y-%m-%d')
#         except ValueError:
#             raise ValidationError(
#                 message='Please enter the date in YYYY-MM-DD format.',
#                 cursor_position=len(document.text)
#             )

# class YesNoValidator(Validator):
#     def validate(self, document):
#         if document.text.lower() not in ['t', 'n']:
#             raise ValidationError(
#                 message='Please enter "t" or "n".',
#                 cursor_position=len(document.text)
#             )

# class CurrencyValidator(Validator):
#     def validate(self, document):
#         valid_currencies = ['PLN', 'USD', 'EUR', 'GBP', 'CHF']
#         if document.text.upper() not in valid_currencies:
#             raise ValidationError(
#                 message='Please enter a valid currency (e.g., PLN, USD, EUR).',
#                 cursor_position=len(document.text)
#             )

# def prompt_receipt_data():
#     session = PromptSession()

#     store_entries = get_store_names_with_addresses()
#     store_completer = WordCompleter(store_entries, ignore_case=True)

#     currencies = ['PLN', 'USD', 'EUR', 'GBP', 'CHF']
#     currency_completer = WordCompleter(currencies, ignore_case=True)

#     categories = get_categories()
#     category_completer = WordCompleter(categories, ignore_case=True)

#     units = get_units()
#     unit_completer = WordCompleter(units, ignore_case=True)

#     receipt = {}

#     receipt_entry = session.prompt(
#         'Enter store name and address (e.g., "Lidl - Witosa 4, Kraków"): ',
#         completer=store_completer
#     )
#     if ' - ' in receipt_entry:
#         receipt['sklep'], receipt['adres'] = receipt_entry.split(' - ', 1)
#     else:
#         receipt['sklep'] = receipt_entry
#         receipt['adres'] = session.prompt('Enter store address: ')

#     receipt['strona_internetowa'] = session.prompt(
#         'Enter store website (optional): ',
#         default='',
#         completer=None,
#         validate_while_typing=True
#     )
#     receipt['data-zakupów'] = session.prompt(
#         'Enter purchase date (YYYY-MM-DD): ',
#         validator=DateValidator(),
#         validate_while_typing=True
#     )
#     receipt['suma'] = float(session.prompt(
#         'Enter total amount: ',
#         validator=NumericValidator(),
#         validate_while_typing=True
#     ))
#     receipt['waluta'] = session.prompt(
#         'Enter currency: ',
#         completer=currency_completer,
#         validator=CurrencyValidator(),
#         validate_while_typing=True
#     ).upper()
#     receipt['czy_internetowy'] = session.prompt(
#         'Was the purchase online? (t/n): ',
#         validator=YesNoValidator(),
#         validate_while_typing=True
#     ).lower() == 't'
#     receipt['skan_paragonu'] = session.prompt(
#         'Enter receipt scan (optional): ',
#         default='',
#         validate_while_typing=True
#     )

#     receipt['produkty'] = []

#     while True:
#         product = {}
#         print("\n--- Adding a New Product ---")
#         product['nazwa'] = session.prompt('Enter product name: ')
#         product['jednostka'] = session.prompt(
#             'Enter unit of measure: ',
#             completer=unit_completer
#         )
#         product['cena'] = float(session.prompt(
#             'Enter product price: ',
#             validator=NumericValidator(),
#             validate_while_typing=True
#         ))
#         product['rabat'] = float(session.prompt(
#             'Enter discount (e.g., 0.5 for 50%): ',
#             validator=NumericValidator(),
#             validate_while_typing=True
#         ))
#         product['ilość'] = float(session.prompt(
#             'Enter quantity: ',
#             validator=NumericValidator(),
#             validate_while_typing=True
#         ))
#         product['kategoria'] = session.prompt(
#             'Enter product category: ',
#             completer=category_completer
#         )
#         product['czy_na_gwarancji'] = session.prompt(
#             'Is the product under warranty? (t/n): ',
#             validator=YesNoValidator(),
#             validate_while_typing=True
#         ).lower() == 't'

#         if product['czy_na_gwarancji']:
#             product['data_gwarancji'] = session.prompt(
#                 'Enter warranty expiration date (YYYY-MM-DD): ',
#                 validator=DateValidator(),
#                 validate_while_typing=True
#             )
#         else:
#             product['data_gwarancji'] = ""

#         product['opis_produktu'] = session.prompt(
#             'Enter product description (optional): ',
#             default='',
#             validate_while_typing=True
#         )

#         add_base_unit = session.prompt(
#             'Does this unit have a base unit? (t/n): ',
#             validator=YesNoValidator(),
#             validate_while_typing=True
#         ).lower() == 't'

#         if add_base_unit:
#             product['base_unit_name'] = session.prompt(
#                 'Enter base unit name: ',
#                 completer=unit_completer
#             )
#             product['conversion_multiplier'] = float(session.prompt(
#                 'Enter conversion multiplier: ',
#                 validator=NumericValidator(),
#                 validate_while_typing=True
#             ))
#         else:
#             product['base_unit_name'] = None
#             product['conversion_multiplier'] = None

#         receipt['produkty'].append(product)

#         add_another = session.prompt(
#             'Add another product? (t/n): ',
#             validator=YesNoValidator(),
#             validate_while_typing=True
#         ).lower()

#         if add_another == 'n':
#             break

#     return receipt
