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

# Listar Pods
kubectl get pods

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
- Selecionar o ambiente antes de chamar qualquer API
- **API de Status de Saúde**
  - URL: `{{url}}/usermgmt/health-status`

- **Serviço Criar Usuário**
  - URL: `{{url}}/usermgmt/user`
  - A variável `url` será substituída do ambiente que selecionamos
```json
    {
        "username": "admin1",
        "email": "dkalyanreddy@gmail.com",
        "role": "ROLE_ADMIN",
        "enabled": true,
        "firstname": "fname1",
        "lastname": "lname1",
        "password": "Pass@123"
    }
```

- **Serviço Listar Usuários**
  - URL: `{{url}}/usermgmt/users`

- **Serviço Atualizar Usuário**
  - URL: `{{url}}/usermgmt/user`
```json
    {
        "username": "admin1",
        "email": "dkalyanreddy@gmail.com",
        "role": "ROLE_ADMIN",
        "enabled": true,
        "firstname": "fname2",
        "lastname": "lname2",
        "password": "Pass@123"
    }
```  

- **Serviço Deletar Usuário**
  - URL: `{{url}}/usermgmt/user/admin1`

## Passo-05: Verificar Usuários no Banco de Dados MySQL
```bash
# Conectar ao Banco de Dados MYSQL
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -u root -pdbpassword11

# Verificar se o schema usermgmt foi criado que fornecemos no ConfigMap
mysql> show schemas;
mysql> use usermgmt;
mysql> show tables;
mysql> select * from users;
```

## Passo-06: Limpeza
- Deletar todos os objetos k8s criados como parte desta seção
```bash
# Deletar Tudo
kubectl delete -f kube-manifests/

# Listar Pods
kubectl get pods

# Verificar sc, pvc, pv
kubectl get sc,pvc,pv
```


