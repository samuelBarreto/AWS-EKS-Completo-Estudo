# Postman Collection - User Management API

Esta collection do Postman contém todos os endpoints da API de Gerenciamento de Usuários.

## 📋 Endpoints Disponíveis

### 1. **Health Check**
- **Método:** GET
- **URL:** `{{url}}/health`
- **Descrição:** Verifica se a API está funcionando

### 2. **Listar Todos os Usuários**
- **Método:** GET
- **URL:** `{{url}}/users`
- **Descrição:** Retorna lista de todos os usuários

### 3. **Criar Usuário**
- **Método:** POST
- **URL:** `{{url}}/users`
- **Body:**
```json
{
    "name": "João Silva",
    "email": "joao.silva@email.com",
    "age": 30
}
```

### 4. **Buscar Usuário por ID**
- **Método:** GET
- **URL:** `{{url}}/users/1`
- **Descrição:** Retorna usuário específico pelo ID

### 5. **Atualizar Usuário**
- **Método:** PUT
- **URL:** `{{url}}/users/1`
- **Body:**
```json
{
    "name": "João Silva Santos",
    "email": "joao.santos@email.com",
    "age": 31
}
```

### 6. **Deletar Usuário**
- **Método:** DELETE
- **URL:** `{{url}}/users/1`
- **Descrição:** Remove usuário pelo ID

## 🔧 Configuração do Ambiente

### Importar Collection e Environment

1. **Importar Collection:**
   - Abra o Postman
   - Clique em "Import"
   - Selecione o arquivo `AWS-EKS-Masterclass-Microservices.postman_collection.json`

2. **Importar Environment:**
   - Clique em "Import"
   - Selecione o arquivo `UserManagement-API.postman_environment.json`

3. **Selecionar Environment:**
   - No canto superior direito, selecione "User Management API Environment"

### Variáveis de Ambiente

| Variável | Valor Padrão | Descrição |
|----------|--------------|-----------|
| `url` | `http://localhost:30090` | URL base da API (NodePort) |
| `nodeport_url` | `http://3.82.114.1:30090` | URL externa via NodePort |
| `clusterip_url` | `http://usermgmt-microservice-service:3000` | URL interna via ClusterIP |

## 🚀 Como Usar

### 1. **Desenvolvimento Local**
```bash
# Se rodando localmente
url = http://localhost:3000
```

### 2. **Kubernetes - NodePort**
```bash
# Obter IP do nó
kubectl get nodes -o wide

# Usar IP do nó
url = http://<NODE_IP>:30090
```

### 3. **Kubernetes - Port Forward**
```bash
# Port forward
kubectl port-forward service/usermgmt-microservice-nodeport 30090:3000

# Usar localhost
url = http://localhost:30090
```

## 📊 Exemplos de Respostas

### Health Check
```json
{
    "status": "OK",
    "message": "User Management API is running",
    "timestamp": "2024-01-01T10:00:00.000Z"
}
```

### Listar Usuários
```json
{
    "success": true,
    "data": [
        {
            "id": 1,
            "name": "João Silva",
            "email": "joao.silva@email.com",
            "age": 30,
            "created_at": "2024-01-01T10:00:00.000Z",
            "updated_at": "2024-01-01T10:00:00.000Z"
        }
    ],
    "count": 1
}
```

### Criar Usuário (Sucesso)
```json
{
    "success": true,
    "message": "User created successfully",
    "data": {
        "id": 1,
        "name": "João Silva",
        "email": "joao.silva@email.com",
        "age": 30
    }
}
```

### Erro (Usuário não encontrado)
```json
{
    "success": false,
    "message": "User not found"
}
```

## 🔍 Troubleshooting

### Problemas Comuns

1. **Connection Refused**
   - Verifique se a API está rodando
   - Confirme a URL e porta corretas

2. **404 Not Found**
   - Verifique se o endpoint está correto
   - Confirme se a API está deployada

3. **500 Internal Server Error**
   - Verifique os logs da API
   - Confirme se o MySQL está conectado

### Verificar Status

```bash
# Verificar pods
kubectl get pods -l app=usermgmt-restapp

# Verificar services
kubectl get svc -l app=usermgmt-restapp

# Verificar logs
kubectl logs -l app=usermgmt-restapp
```

## 📝 Notas

- Todos os endpoints retornam JSON
- IDs são numéricos inteiros
- Email deve ser único
- Nome e email são obrigatórios
- Idade é opcional
