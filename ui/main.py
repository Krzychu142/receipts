# source venv/bin/activate
# deactivate
from database_connect import database_connect

from prompt_toolkit import prompt

def main():
    database_connect()
    user_input = prompt('Prompt test: ')
    print(f'user_input=, {user_input}!')

if __name__ == '__main__':
    main()
