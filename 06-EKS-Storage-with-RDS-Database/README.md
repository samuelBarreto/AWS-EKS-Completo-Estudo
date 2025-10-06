# Usar Banco de Dados RDS para workloads rodando no cluster AWS EKS

## Passo-01: Introdução
- Quais são os problemas com MySQL em Pod & EBS CSI?
- Como vamos resolvê-los usando o banco de dados AWS RDS?

## Passo-02: Criar Banco de Dados RDS

### Revisar a VPC do nosso cluster EKS
- Vá em Services -> VPC
- Nome da VPC:  eksctl-eksdemo1-cluster/VPC

### Pré-requisito-1: Criar Security Group do DB
- Crie um security group para permitir acesso ao banco RDS na porta 3306
- Nome do security group: eks_rds_db_sg
- Descrição: Permitir acesso ao RDS na porta 3306 
- VPC: eksctl-eksdemo1-cluster/VPC
- Regras de Inbound
  - Tipo: MySQL/Aurora
  - Protocolo: TCP
  - Porta: 3306
  - Origem: Anywhere (0.0.0.0/0)
  - Descrição: Permitir acesso ao RDS na porta 3306 
- Regras de Outbound  
  - Deixe como padrão

### Comando AWS CLI para Security Group
```bash
# 1) Obter VPC ID pela tag Name
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=eksctl-eksdemo1-cluster/VPC" --query "Vpcs[0].VpcId" --output text)
echo "VPC ID: $VPC_ID"

# 2) Criar Security Group
SG_ID=$(aws ec2 create-security-group --group-name eks_rds_db_sg --description "Allow RDS 3306" --vpc-id "$VPC_ID" --query "GroupId" --output text)
echo "Security Group ID: $SG_ID"

# 3) Adicionar tag Name
aws ec2 create-tags --resources "$SG_ID" --tags Key=Name,Value=eks_rds_db_sg

# 4) Autorizar porta 3306 do seu IP
IP=$(curl -s https://checkip.amazonaws.com)
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --ip-permissions IpProtocol=tcp,FromPort=3306,ToPort=3306,IpRanges="[{CidrIp=${IP}/32,Description=RDS 3306}]"

# 5) (Teste) Autorizar 0.0.0.0/0 em 3306 (não recomendado para produção)
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --ip-permissions IpProtocol=tcp,FromPort=3306,ToPort=3306,IpRanges='[{CidrIp=0.0.0.0/0,Description=RDS 3306}]'

# 6) Verificar Security Group
aws ec2 describe-security-groups --group-ids "$SG_ID" --query "SecurityGroups[0].{GroupId:GroupId,VpcId:VpcId,Perms:IpPermissions}"
```

### Pré-requisito-2: Criar DB Subnet Group no RDS 
- Vá em RDS -> Subnet Groups
- Clique em Create DB Subnet Group
  - Nome: eks-rds-db-subnetgroup
  - Descrição: EKS RDS DB Subnet Group
  - VPC: eksctl-eksdemo1-cluster/VPC
  - Zonas de disponibilidade: us-east-1a, us-east-1b
  - Subnets: 2 subnets em 2 AZs
  - Clique em Create

### Comando AWS CLI para DB Subnet Group
```bash
# 1) Obter VPC ID pela tag Name
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=eksctl-eksdemo1-cluster/VPC" --query "Vpcs[0].VpcId" --output text)

# 2) Listar subnets privadas da VPC (sem MapPublicIpOnLaunch)
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[?MapPublicIpOnLaunch==\`false\`].[SubnetId,AvailabilityZone]" --output table

# 3) Pegar duas subnets em AZs diferentes
read SUBNET1 SUBNET2 < <(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[?MapPublicIpOnLaunch==\`false\`].SubnetId" --output text | awk '{print $1, $2}')

# 4) Criar DB Subnet Group
aws rds create-db-subnet-group --db-subnet-group-name eks-rds-db-subnetgroup \
  --db-subnet-group-description "EKS RDS DB Subnet Group" \
  --subnet-ids "$SUBNET1" "$SUBNET2"

# 5) Verificar
aws rds describe-db-subnet-groups --db-subnet-group-name eks-rds-db-subnetgroup
```

### Criar o Banco de Dados RDS 
- Vá em  Services -> RDS
- Clique em Create Database
  - Método de criação: Standard Create
  - Engine: MySQL  
  - Edição: MySQL Community
  - Versão: 8.0.x (versão disponível na região)
  - Template: Free Tier
  - Identificador da instância: usermgmtdb
  - Usuário mestre: admin
  - Senha mestre: dbpassword11
  - Confirmar senha: dbpassword11
  - Tamanho da instância: deixe padrão
  - Armazenamento: deixe padrão
  - Conectividade
    - VPC: eksctl-eksdemo1-cluster/VPC
    - Configuração adicional de conectividade
      - Subnet Group: eks-rds-db-subnetgroup
      - Publicly accessible: YES (para aprendizado e troubleshooting - se necessário)
    - Security Group da VPC: Use existing
      - Nome: eks_rds_db_sg    
    - Zona de disponibilidade: No Preference
    - Porta do banco: 3306 
  - O restante, deixe como padrão                
- Clique em Create Database

### Comando AWS CLI para criar RDS MySQL
```bash
# Ajuste a região se necessário
REGION=us-east-1

# Obter o SG ID pelo nome
SG_ID=$(aws ec2 describe-security-groups --region $REGION \
  --filters "Name=group-name,Values=eks_rds_db_sg" \
  --query "SecurityGroups[0].GroupId" --output text)

# Criar instância RDS
aws rds create-db-instance \
  --region $REGION \
  --db-instance-identifier usermgmtdb \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --allocated-storage 20 \
  --master-username admin \
  --master-user-password dbpassword11 \
  --db-subnet-group-name eks-rds-db-subnetgroup \
  --vpc-security-group-ids "$SG_ID" \
  --publicly-accessible \
  --no-multi-az \
  --storage-type gp2 \
  --backup-retention-period 0

# Aguardar criação (opcional)
aws rds wait db-instance-available --db-instance-identifier usermgmtdb --region $REGION

# Obter endpoint
aws rds describe-db-instances --db-instance-identifier usermgmtdb \
  --query "DBInstances[0].Endpoint.Address" --output text --region $REGION
```

## Passo-03: Criar manifest de Service ExternalName no Kubernetes e fazer deploy
- Criar Service mysql ExternalName
- 01-MySQL-externalName-Service.yml
```yml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: ExternalName
  externalName: usermgmtdb.xxxxxxxxx.us-east-1.rds.amazonaws.com
```
 - Fazer deploy do manifest
```
kubectl apply -f kube-manifests/mysql/01-MySQL-externalName-Service.yml 
```

## Passo-04: Conectar ao RDS via kubectl e criar o schema/db usermgmt
```bash
# Conectar ao RDS
kubectl run -it --rm --image=mysql:latest --restart=Never mysql-client -- \
  mysql -h usermgmtdb.xxxxxxxxx.us-east-1.rds.amazonaws.com -u admin -pdbpassword11

# Dentro do MySQL, executar:
CREATE DATABASE IF NOT EXISTS usermgmt;
CREATE USER 'appuser'@'%' IDENTIFIED BY 'app_password_123';
GRANT ALL PRIVILEGES ON usermgmt.* TO 'appuser'@'%';
FLUSH PRIVILEGES;

# Criar tabela e inserir dados
USE usermgmt;
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT IGNORE INTO users (name, email, age) VALUES
('João Silva', 'joao.silva@email.com', 30),
('Maria Santos', 'maria.santos@email.com', 25),
('Pedro Oliveira', 'pedro.oliveira@email.com', 35),
('Ana Costa', 'ana.costa@email.com', 28),
('Carlos Lima', 'carlos.lima@email.com', 42);

SELECT COUNT(*) as total_users FROM users;
```

## Passo-05: Configurar Deployment do User Management Microservice
- Ajustar variáveis de ambiente para usar o usuário correto
- 06-UserAppMicroservice-Deployment-Service.yml
```yml
# Usar as variáveis corretas
- name: DB_USER
  value: "appuser"            
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysql-db-password
      key: db-password
```

## Passo-06: Fazer deploy do User Management Microservice e testar
```bash
# Fazer deploy de todos os manifests
kubectl apply -f kube-manifests/

# Listar Pods
kubectl get pods

# Acompanhar logs do Pod para verificar conexão com o DB pela aplicação
kubectl logs -f -l app=usermgmt-restapp
```

## Passo-07: Acessar a aplicação
```bash
# Capturar o External IP (ou Public IP) de um Worker Node
kubectl get nodes -o wide

# Obter NodePort do Service
kubectl get svc usermgmt-microservice-nodeport

# Acessar a aplicação
http://<Worker-Node-Public-Ip>:<NodePort>/health
```

## Passo-08: Limpeza - Sequência correta de deleção

### 1) Deletar recursos Kubernetes
```bash
# Deletar todos os objetos criados
kubectl delete -f kube-manifests/

# Verificar limpeza
kubectl get all
```

### 2) Deletar RDS Instance (primeiro)
```bash
# Deletar instância RDS (sem snapshot)
aws rds delete-db-instance --db-instance-identifier usermgmtdb --skip-final-snapshot --region us-east-1

# Aguardar até "deleted"
aws rds wait db-instance-deleted --db-instance-identifier usermgmtdb --region us-east-1

# Verificar status
aws rds describe-db-instances --db-instance-identifier usermgmtdb --region us-east-1
```

### 3) Deletar DB Subnet Group (segundo)
```bash
# Deletar o DB Subnet Group
aws rds delete-db-subnet-group --db-subnet-group-name eks-rds-db-subnetgroup --region us-east-1

# Verificar
aws rds describe-db-subnet-groups --db-subnet-group-name eks-rds-db-subnetgroup --region us-east-1
```

### 4) Deletar Security Group (terceiro)
```bash
# Obter SG ID pelo nome
SG_ID=$(aws ec2 describe-security-groups --region us-east-1 \
  --filters "Name=group-name,Values=eks_rds_db_sg" \
  --query "SecurityGroups[0].GroupId" --output text)

# Verificar se está em uso
aws ec2 describe-security-groups --group-ids "$SG_ID" --region us-east-1

# Deletar Security Group
aws ec2 delete-security-group --group-id "$SG_ID" --region us-east-1
```

### Comando único para limpeza completa
```bash
#!/bin/bash
REGION=us-east-1

echo "1) Deletando recursos Kubernetes..."
kubectl delete -f kube-manifests/ 2>/dev/null || true

echo "2) Deletando RDS Instance..."
aws rds delete-db-instance --db-instance-identifier usermgmtdb --skip-final-snapshot --region $REGION 2>/dev/null || true
aws rds wait db-instance-deleted --db-instance-identifier usermgmtdb --region $REGION 2>/dev/null || true

echo "3) Deletando DB Subnet Group..."
aws rds delete-db-subnet-group --db-subnet-group-name eks-rds-db-subnetgroup --region $REGION 2>/dev/null || true

echo "4) Deletando Security Group..."
SG_ID=$(aws ec2 describe-security-groups --region $REGION \
  --filters "Name=group-name,Values=eks_rds_db_sg" \
  --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)
if [ "$SG_ID" != "None" ] && [ -n "$SG_ID" ]; then
  aws ec2 delete-security-group --group-id "$SG_ID" --region $REGION 2>/dev/null || true
fi

echo "Limpeza concluída!"
```

## Observações importantes:
- **Ordem importa**: RDS → Subnet Group → Security Group
- **RDS primeiro**: Pode demorar para ser deletado
- **Subnet Group**: Só pode ser deletado após RDS
- **Security Group**: Verificar se não está em uso por outros recursos
- **Snapshot**: Use `--final-db-snapshot-identifier` se quiser backup antes de deletar