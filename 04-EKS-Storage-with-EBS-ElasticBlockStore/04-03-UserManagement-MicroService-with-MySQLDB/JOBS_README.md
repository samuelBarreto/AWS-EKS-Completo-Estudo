# Kubernetes Jobs - User Management API

Este documento descreve os Jobs do Kubernetes criados para automatizar a configuração do banco de dados.

## 📋 Jobs Disponíveis

### **1. Job Básico - Criação de Tabela**
**Arquivo:** `07-mysql-table-setup-job.yml`

**Função:** Cria a tabela `users` no banco `usermgmt`

**Uso:**
```bash
kubectl apply -f kube-manifests/07-mysql-table-setup-job.yml
kubectl wait --for=condition=complete job/mysql-table-setup --timeout=60s
kubectl logs job/mysql-table-setup
```

### **2. Job Avançado - Criação de Tabela com Wait**
**Arquivo:** `08-mysql-table-setup-job-advanced.yml`

**Função:** 
- Aguarda MySQL estar pronto (initContainer)
- Cria a tabela `users`
- Mostra logs detalhados

**Uso:**
```bash
kubectl apply -f kube-manifests/08-mysql-table-setup-job-advanced.yml
kubectl wait --for=condition=complete job/mysql-table-setup-advanced --timeout=60s
kubectl logs job/mysql-table-setup-advanced
```

### **3. Job de Dados de Exemplo**
**Arquivo:** `09-mysql-sample-data-job.yml`

**Função:**
- Aguarda MySQL estar pronto
- Insere dados de exemplo na tabela `users`
- Mostra dados inseridos

**Uso:**
```bash
kubectl apply -f kube-manifests/09-mysql-sample-data-job.yml
kubectl wait --for=condition=complete job/mysql-sample-data --timeout=60s
kubectl logs job/mysql-sample-data
```

## 🚀 Scripts de Automação

### **Setup do Banco de Dados**
**Arquivo:** `setup-database.sh`

**Função:** Executa o Job avançado e monitora o progresso

**Uso:**
```bash
chmod +x setup-database.sh
./setup-database.sh
```

## 📊 Estrutura da Tabela

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

## 🔍 Monitoramento

### **Verificar Status dos Jobs:**
```bash
kubectl get jobs
kubectl describe job mysql-table-setup-advanced
```

### **Ver Logs:**
```bash
kubectl logs job/mysql-table-setup-advanced
kubectl logs job/mysql-sample-data
```

### **Verificar Tabela:**
```bash
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -u root -pdbpassword11 -e "USE usermgmt; SHOW TABLES; DESCRIBE users;"
```

## 🧹 Limpeza

### **Remover Jobs:**
```bash
kubectl delete job mysql-table-setup
kubectl delete job mysql-table-setup-advanced
kubectl delete job mysql-sample-data
```

### **Remover Todos os Jobs:**
```bash
kubectl delete jobs --all
```

## ⚠️ Troubleshooting

### **Job Falhou:**
```bash
# Verificar logs
kubectl logs job/mysql-table-setup-advanced

# Verificar eventos
kubectl describe job mysql-table-setup-advanced

# Verificar pods
kubectl get pods -l app=mysql-setup
```

### **MySQL Não Está Pronto:**
```bash
# Verificar se MySQL está rodando
kubectl get pods -l app=mysql

# Verificar logs do MySQL
kubectl logs -l app=mysql
```

### **Tabela Já Existe:**
Os Jobs usam `CREATE TABLE IF NOT EXISTS`, então são seguros para executar múltiplas vezes.

## 📝 Vantagens dos Jobs

1. **Automatização:** Não precisa executar comandos manuais
2. **Monitoramento:** Logs e status centralizados
3. **Retry:** Jobs têm backoffLimit para tentativas
4. **Wait:** InitContainer aguarda dependências
5. **Limpeza:** Jobs são removidos automaticamente após conclusão
6. **Reprodutibilidade:** Mesmo resultado sempre

## 🎯 Fluxo Recomendado

1. **Deploy MySQL:**
   ```bash
   kubectl apply -f kube-manifests/01-storage-class.yml
   kubectl apply -f kube-manifests/02-persistent-volume-claim.yml
   kubectl apply -f kube-manifests/03-UserManagement-ConfigMap.yml
   kubectl apply -f kube-manifests/deploy/04-mysql-deployment.yml
   kubectl apply -f kube-manifests/deploy/05-mysql-clusterip-service.yml
   ```

2. **Configurar Banco:**
   ```bash
   ./setup-database.sh
   ```

3. **Inserir Dados de Exemplo (opcional):**
   ```bash
   kubectl apply -f kube-manifests/09-mysql-sample-data-job.yml
   ```

4. **Deploy API:**
   ```bash
   kubectl apply -f kube-manifests/06-UserManagementMicroservice-Deployment-Service.yml
   ```

5. **Testar API:**
   ```bash
   ./test-api.sh <NODE_IP>
   ```
