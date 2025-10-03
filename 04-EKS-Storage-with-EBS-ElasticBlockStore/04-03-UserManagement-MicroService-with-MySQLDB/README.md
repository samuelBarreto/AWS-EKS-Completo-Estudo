# Deploy UserManagement Service com Banco de Dados MySQL

## Passo-01: Introdução
- Vamos implantar um **Microserviço de Gerenciamento de Usuários** que se conectará ao schema do banco de dados MySQL **usermgmt** durante a inicialização.
- Então podemos testar as seguintes APIs:
  - Criar Usuários
  - Listar Usuários
  - Deletar Usuário
  - Status de Saúde

| Objeto Kubernetes  | Arquivo YAML |
| ------------- | ------------- |
| Deployment, Environment Variables  | 06-UserManagementMicroservice-Deployment.yml  |
| NodePort Service  | 07-UserManagement-Service.yml  |

## Passo-02: Criar os seguintes manifestos Kubernetes

### Criar manifesto Deployment do Microserviço de Gerenciamento de Usuários
- **Variáveis de Ambiente**

| Nome da Chave  | Valor |
| ------------- | ------------- |
| DB_HOSTNAME  | mysql |
| DB_PORT  | 3306  |
| DB_NAME  | usermgmt  |
| DB_USERNAME  | root  |
| DB_PASSWORD | dbpassword11  |  

### Criar manifesto NodePort Service do Microserviço de Gerenciamento de Usuários
- Serviço NodePort

## Passo-03: Criar Deployment e Service do UserManagement
```bash
# Criar Deployment & NodePort Service
kubectl apply -f kube-manifests/


# Criação de tabela usando Job do Kubernetes
kubectl apply -f jobs/

# Verificar logs do Job
kubectl logs job <name>

# Listar Pods
kubectl get pods

NAME                                     READY   STATUS    RESTARTS   AGE
mysql-854c6464b5-lb6hh                   1/1     Running   0          19s
usermgmt-microservice-795b557b9f-hzsdd   1/1     Running   0          18s
usermgmt-microservice-795b557b9f-pkst5   1/1     Running   0          18s

# Verificar logs do pod do Microserviço Usermgmt
kubectl logs -f <Pod-Name>

# Verificar sc, pvc, pv
kubectl get sc,pvc,pv
```

- **Observação do Problema:** 
  - Se implantarmos todos os manifestos ao mesmo tempo, quando o MySQL estiver pronto, nosso pod do `Microserviço de Gerenciamento de Usuários` estará reiniciando várias vezes devido à indisponibilidade do banco de dados. 
  - Para evitar essas situações, podemos aplicar o conceito de `initContainers` ao nosso manifesto `Deployment` do Microserviço de Gerenciamento de Usuários.
  - Veremos isso em nossa próxima seção, mas por enquanto vamos continuar testando a aplicação

- **Acessar Aplicação**
```bash
# Listar Services
kubectl get svc

# Obter IP Público
kubectl get nodes -o wide

# Acessar API de Status de Saúde do Serviço de Gerenciamento de Usuários
http://<EKS-WorkerNode-Public-IP>:31231/usermgmt/health-status
```

## Passo-04: Testar Microserviço de Gerenciamento de Usuários usando Postman
### Baixar cliente Postman 
- https://www.postman.com/downloads/ 

### Importar Projeto para Postman
- Importar o projeto postman `AWS-EKS-Estudos -Microservices.postman_collection.json` presente na pasta `04-03-UserManagement-MicroService-with-MySQLDB`

### Criar Ambiente no Postman
- Ir para Settings -> Clicar em Add
- **Nome do Ambiente:** UMS-NodePort
  - **Variável:** url
  - **Valor Inicial:** http://WorkerNode-Public-IP:31231
  - **Valor Atual:** http://WorkerNode-Public-IP:31231
  - Clicar em **Add**

### Testar Serviços de Gerenciamento de Usuários

#### **1. Health Check da API**
```bash
curl -X GET http://<NODE_IP>:30090/health
```

**Resposta esperada:**
```json
{
    "status": "OK",
    "message": "User Management API is running",
    "timestamp": "2024-01-01T10:00:00.000Z"
}
```

#### **2. Criar Usuário**
```bash
curl -X POST http://54.90.145.97:30090/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao.silva@email.com",
    "age": 30
  }'
```

**Resposta esperada:**
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

#### **3. Listar Todos os Usuários**
```bash
curl -X GET http://<NODE_IP>:30090/users
```

**Resposta esperada:**
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

#### **4. Buscar Usuário por ID**
```bash
curl -X GET http://<NODE_IP>:30090/users/1
```

**Resposta esperada:**
```json
{
    "success": true,
    "data": {
        "id": 1,
        "name": "João Silva",
        "email": "joao.silva@email.com",
        "age": 30,
        "created_at": "2024-01-01T10:00:00.000Z",
        "updated_at": "2024-01-01T10:00:00.000Z"
    }
}
```

#### **5. Atualizar Usuário**
```bash
curl -X PUT http://<NODE_IP>:30090/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva Santos",
    "email": "joao.santos@email.com",
    "age": 31
  }'
```

**Resposta esperada:**
```json
{
    "success": true,
    "message": "User updated successfully",
    "data": {
        "id": 1,
        "name": "João Silva Santos",
        "email": "joao.santos@email.com",
        "age": 31
    }
}
```

#### **6. Deletar Usuário**
```bash
curl -X DELETE http://<NODE_IP>:30090/users/1
```

**Resposta esperada:**
```json
{
    "success": true,
    "message": "User deleted successfully"
}
```

### **🔧 Configuração de URLs**

#### **Obter IP do Nó:**
```bash
kubectl get nodes -o wide
```

#### **Alternativas de Acesso:**

**1. Via NodePort (Acesso Externo):**
```bash
# Substitua <NODE_IP> pelo IP real do nó
curl http://<NODE_IP>:30090/health
```

**2. Via Port Forward (Acesso Local):**
```bash
# Em um terminal, execute:
kubectl port-forward service/usermgmt-microservice-nodeport 30090:3000

# Em outro terminal, teste:
curl http://localhost:30090/health
```

**3. Via ClusterIP (Interno):**
```bash
# Dentro do cluster
curl http://usermgmt-microservice-service:3000/health
```

### **📊 Exemplos de Teste Completo**

```bash
# 1. Verificar se API está funcionando
curl -X GET http://<NODE_IP>:30090/health

# 2. Criar primeiro usuário
curl -X POST http://<NODE_IP>:30090/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Maria Silva","email":"maria@email.com","age":25}'

# 3. Criar segundo usuário
curl -X POST http://<NODE_IP>:30090/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Pedro Santos","email":"pedro@email.com","age":35}'

# 4. Listar todos os usuários
curl -X GET http://<NODE_IP>:30090/users

# 5. Buscar usuário específico
curl -X GET http://<NODE_IP>:30090/users/1

# 6. Atualizar usuário
curl -X PUT http://<NODE_IP>:30090/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Maria Silva Santos","email":"maria.santos@email.com","age":26}'

# 7. Deletar usuário
curl -X DELETE http://<NODE_IP>:30090/users/2

# 8. Verificar usuários restantes
curl -X GET http://<NODE_IP>:30090/users
```

## Passo-05: Verificar Usuários no Banco de Dados MySQL
```bash
# Conectar ao Banco de Dados MySQL
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql-service -u root -pdbpassword11

# Dentro do MySQL, executar:
USE usermanagement;
SELECT * FROM users;

# Verificar se o schema usermanagement foi criado
mysql> show schemas;
mysql> use usermanagement;
mysql> show tables;
mysql> describe users;
mysql> select * from users;
```

## Passo-06: Status Atual do Projeto

### **✅ Projeto Atualizado e Funcionando**

**API de Gerenciamento de Usuários:**
- **URL:** http://54.90.145.97:30090
- **Status:** ✅ Funcionando
- **Banco de Dados:** MySQL (usermgmt.users)
- **Endpoints:** CRUD completo implementado

**Recursos Kubernetes:**
- **Deployment:** usermgmt-microservice (2 réplicas)
- **Services:** ClusterIP + NodePort
- **Storage:** EBS via PVC

### **🚀 Scripts e Jobs Disponíveis**

**Setup do Banco de Dados:**
```bash
# Script automatizado
chmod +x setup-database.sh
./setup-database.sh

# Ou Job manual
kubectl apply -f kube-manifests/08-mysql-table-setup-job-advanced.yml
kubectl wait --for=condition=complete job/mysql-table-setup-advanced --timeout=60s
kubectl logs job/mysql-table-setup-advanced
```

**Dados de Exemplo:**
```bash
# Inserir dados de exemplo
kubectl apply -f kube-manifests/09-mysql-sample-data-job.yml
kubectl wait --for=condition=complete job/mysql-sample-data --timeout=60s
kubectl logs job/mysql-sample-data
```

**Teste da API:**
```bash
chmod +x test-api.sh
./test-api.sh 54.90.145.97
```

**Limpeza:**
```bash
chmod +x cleanup.sh
./cleanup.sh
```

### **📊 Endpoints Testados**

| Método | Endpoint | Status |
|--------|----------|--------|
| GET | `/health` | ✅ OK |
| GET | `/users` | ✅ OK |
| POST | `/users` | ✅ OK |
| GET | `/users/:id` | ✅ OK |
| PUT | `/users/:id` | ✅ OK |
| DELETE | `/users/:id` | ✅ OK |

## Passo-07: Limpeza
- Deletar todos os objetos k8s criados como parte desta seção
```bash
# Deletar Tudo
kubectl delete -f kube-manifests/

# Listar Pods
kubectl get pods

# Verificar sc, pvc, pv
kubectl get sc,pvc,pv
```


