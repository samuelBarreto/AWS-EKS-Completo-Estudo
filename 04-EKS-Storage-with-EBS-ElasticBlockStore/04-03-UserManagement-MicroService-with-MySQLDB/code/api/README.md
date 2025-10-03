# User Management API

Uma API simples de gerenciamento de usuários construída com Node.js, Express e MySQL.

## 🚀 Funcionalidades

- **CRUD completo** para usuários
- **Validação** de dados
- **Conexão com MySQL** via pool de conexões
- **Health checks** para Kubernetes
- **Dockerizado** e pronto para produção

## 📋 Endpoints

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check da API |
| GET | `/users` | Lista todos os usuários |
| GET | `/users/:id` | Busca usuário por ID |
| POST | `/users` | Cria novo usuário |
| PUT | `/users/:id` | Atualiza usuário |
| DELETE | `/users/:id` | Remove usuário |

## 🛠️ Desenvolvimento Local

### Pré-requisitos
- Node.js 18+
- MySQL 5.7+

### Instalação
```bash
# Instalar dependências
npm install

# Configurar variáveis de ambiente
export DB_HOST=localhost
export DB_USER=root
export DB_PASSWORD=your_password
export DB_NAME=usermanagement
export DB_PORT=3306

# Executar em modo desenvolvimento
npm run dev
```

### Testando a API
```bash
# Health check
curl http://localhost:3000/health

# Listar usuários
curl http://localhost:3000/users

# Criar usuário
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name":"João Silva","email":"joao@email.com","age":30}'

# Buscar usuário
curl http://localhost:3000/users/1

# Atualizar usuário
curl -X PUT http://localhost:3000/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"João Silva Santos","email":"joao.santos@email.com","age":31}'

# Deletar usuário
curl -X DELETE http://localhost:3000/users/1
```

## 🐳 Docker

### Build da imagem
```bash
docker build -t user-management-api:1.0.0 .
```

### Executar container
```bash
docker run -p 3000:3000 \
  -e DB_HOST=host.docker.internal \
  -e DB_USER=root \
  -e DB_PASSWORD=your_password \
  -e DB_NAME=usermanagement \
  user-management-api:1.0.0
```

## ☸️ Kubernetes

### Deploy completo
```bash
# Build e deploy
chmod +x build-and-deploy.sh
./build-and-deploy.sh
```

### Deploy manual
```bash
# Aplicar manifests
kubectl apply -f user-api-deployment.yml
kubectl apply -f user-api-service.yml
kubectl apply -f user-api-nodeport-service.yml

# Verificar status
kubectl get pods -l app=user-management-api
kubectl get svc -l app=user-management-api
```

### Acesso externo
```bash
# Obter IP do nó
kubectl get nodes -o wide

# Acessar API
curl http://<NODE_IP>:30080/health
curl http://<NODE_IP>:30080/users
```

## 📊 Estrutura do Banco de Dados

```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  age INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 🔧 Variáveis de Ambiente

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `PORT` | 3000 | Porta da API |
| `DB_HOST` | mysql-service | Host do MySQL |
| `DB_USER` | root | Usuário do MySQL |
| `DB_PASSWORD` | dbpassword11 | Senha do MySQL |
| `DB_NAME` | usermanagement | Nome do banco |
| `DB_PORT` | 3306 | Porta do MySQL |

## 📝 Exemplos de Uso

### Criar usuário
```json
POST /users
{
  "name": "Maria Silva",
  "email": "maria@email.com",
  "age": 25
}
```

### Resposta de sucesso
```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "id": 1,
    "name": "Maria Silva",
    "email": "maria@email.com",
    "age": 25
  }
}
```

### Listar usuários
```json
GET /users

{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Maria Silva",
      "email": "maria@email.com",
      "age": 25,
      "created_at": "2024-01-01T10:00:00.000Z",
      "updated_at": "2024-01-01T10:00:00.000Z"
    }
  ],
  "count": 1
}
```

## 🚨 Tratamento de Erros

A API retorna respostas padronizadas:

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message"
}
```

### Códigos de Status
- `200` - Sucesso
- `201` - Criado com sucesso
- `400` - Dados inválidos
- `404` - Usuário não encontrado
- `409` - Email já existe
- `500` - Erro interno do servidor
