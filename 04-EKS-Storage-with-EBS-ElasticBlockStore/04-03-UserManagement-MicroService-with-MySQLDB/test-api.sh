#!/bin/bash

# Script de Teste da API de Gerenciamento de Usuários
# Uso: ./test-api.sh <NODE_IP>

if [ -z "$1" ]; then
    echo "❌ Uso: ./test-api.sh <NODE_IP>"
    echo "   Exemplo: ./test-api.sh 3.82.114.1"
    exit 1
fi

NODE_IP=$1
API_URL="http://${NODE_IP}:30090"

echo "🚀 Testando API de Gerenciamento de Usuários"
echo "📍 URL: ${API_URL}"
echo "================================================"

# Função para fazer requisições com tratamento de erro
make_request() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    echo ""
    echo "🔍 ${description}"
    echo "   ${method} ${endpoint}"
    
    if [ -n "$data" ]; then
        response=$(curl -s -X ${method} "${API_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -d "${data}")
    else
        response=$(curl -s -X ${method} "${API_URL}${endpoint}")
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Sucesso:"
        echo "$response" | jq . 2>/dev/null || echo "$response"
    else
        echo "❌ Erro na requisição"
    fi
}

# 1. Health Check
make_request "GET" "/health" "" "1. Health Check da API"

# 2. Listar usuários (deve estar vazio inicialmente)
make_request "GET" "/users" "" "2. Listar usuários (inicial)"

# 3. Criar primeiro usuário
make_request "POST" "/users" '{
    "name": "João Silva",
    "email": "joao.silva@email.com",
    "age": 30
}' "3. Criar primeiro usuário"

# 4. Criar segundo usuário
make_request "POST" "/users" '{
    "name": "Maria Santos",
    "email": "maria.santos@email.com",
    "age": 25
}' "4. Criar segundo usuário"

# 5. Criar terceiro usuário
make_request "POST" "/users" '{
    "name": "Pedro Oliveira",
    "email": "pedro.oliveira@email.com",
    "age": 35
}' "5. Criar terceiro usuário"

# 6. Listar todos os usuários
make_request "GET" "/users" "" "6. Listar todos os usuários"

# 7. Buscar usuário por ID
make_request "GET" "/users/1" "" "7. Buscar usuário por ID (ID: 1)"

# 8. Atualizar usuário
make_request "PUT" "/users/1" '{
    "name": "João Silva Santos",
    "email": "joao.santos@email.com",
    "age": 31
}' "8. Atualizar usuário (ID: 1)"

# 9. Verificar usuário atualizado
make_request "GET" "/users/1" "" "9. Verificar usuário atualizado"

# 10. Tentar criar usuário com email duplicado (deve falhar)
make_request "POST" "/users" '{
    "name": "João Duplicado",
    "email": "joao.santos@email.com",
    "age": 40
}' "10. Tentar criar usuário com email duplicado (deve falhar)"

# 11. Buscar usuário inexistente (deve falhar)
make_request "GET" "/users/999" "" "11. Buscar usuário inexistente (deve falhar)"

# 12. Deletar usuário
make_request "DELETE" "/users/2" "" "12. Deletar usuário (ID: 2)"

# 13. Listar usuários após deleção
make_request "GET" "/users" "" "13. Listar usuários após deleção"

# 14. Deletar usuário inexistente (deve falhar)
make_request "DELETE" "/users/999" "" "14. Deletar usuário inexistente (deve falhar)"

echo ""
echo "================================================"
echo "✅ Teste da API concluído!"
echo "📍 URL testada: ${API_URL}"
echo ""
echo "💡 Para verificar no banco de dados:"
echo "   kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql-service -u root -pdbpassword11"
echo "   USE usermanagement;"
echo "   SELECT * FROM users;"
