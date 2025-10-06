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

## Comando aws cli
```
# 1) VPC ID pela tag Name
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=eksctl-eksdemo1-cluster/VPC" --query "Vpcs[0].VpcId" --output text)

echo $SG_ID
sg-0a0ef897653aec5ca

# 2) Criar SG
SG_ID=$(aws ec2 create-security-group --group-name eks_rds_db_sg --description "Allow RDS 3306" --vpc-id "$VPC_ID" --query "GroupId" --output text)

# 3) (Opcional) Tag Name
aws ec2 create-tags --resources "$SG_ID" --tags Key=Name,Value=eks_rds_db_sg

$ # 4) Autorizar 3306 do seu IP
IP=$(curl -s https://checkip.amazonaws.com)
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --ip-permissions IpProtocol=tcp,FromPort=3306,ToPort=3306,IpRanges="[{CidrIp=${IP}/32,Description=RDS 3306}]"
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-00910778bf29149f4",
            "GroupId": "sg-0a0ef897653aec5ca",
            "GroupOwnerId": "390214104376",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 3306,
            "ToPort": 3306,
            "CidrIpv4": "201.54.231.77/32",
            "Description": "RDS 3306"
        }
    ]
}

# 4b) (Teste) Autorizar 0.0.0.0/0 em 3306 (não recomendado)
aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --ip-permissions IpProtocol=tcp,FromPort=3306,ToPort=3306,IpRanges='[{CidrIp=0.0.0.0/0,Description=RDS 3306}]'

{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0239d1838b8d9925b",
            "GroupId": "sg-0a0ef897653aec5ca",
            "GroupOwnerId": "390214104376",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 3306,
            "ToPort": 3306,
            "CidrIpv4": "0.0.0.0/0",
            "Description": "RDS 3306"
        }
    ]
}

aws ec2 describe-security-groups --group-ids "$SG_ID" --query "SecurityGroups[0].{GroupId:GroupId,VpcId:VpcId,Perms:IpPermissions}"
{
    "GroupId": "sg-0a0ef897653aec5ca",
    "VpcId": "vpc-031cffcd02e4063a6",
    "Perms": [
        {
            "FromPort": 3306,
            "IpProtocol": "tcp",
            "IpRanges": [
                {
                    "CidrIp": "201.54.231.77/32",
                    "Description": "RDS 3306"
                },
                {
                    "CidrIp": "0.0.0.0/0",
                    "Description": "RDS 3306"
                }
            ],
            "Ipv6Ranges": [],
            "PrefixListIds": [],
            "ToPort": 3306,
            "UserIdGroupPairs": []
        }
    ]
}

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

## Comando aws cli
```
# 1) Obter VPC ID pela tag Name
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=eksctl-eksdemo1-cluster/VPC" --query "Vpcs[0].VpcId" --output text)

$ echo $VPC_ID
vpc-031cffcd02e4063a6

# (Opcional) Se quiser garantir AZs diferentes, liste com AZ e escolha manualmente:
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
   --query "Subnets[?MapPublicIpOnLaunch==\`false\`].[SubnetId,AvailabilityZone]" --output table

--------------------------------------------
|              DescribeSubnets             |
+---------------------------+--------------+
|  subnet-0baad3f88b87f4903 |  us-east-1a  |
|  subnet-0d9e0ac67ff825549 |  us-east-1b  |
+---------------------------+--------------+

# 3) Criar DB Subnet Group
aws rds create-db-subnet-group --db-subnet-group-name eks-rds-db-subnetgroup   --db-subnet-group-description "EKS RDS DB Subnet Group"   --subnet-ids "$SUBNET1" "$SUBNET2"
{
    "DBSubnetGroup": {
        "DBSubnetGroupName": "eks-rds-db-subnetgroup",
        "DBSubnetGroupDescription": "EKS RDS DB Subnet Group",
        "VpcId": "vpc-031cffcd02e4063a6",
        "SubnetGroupStatus": "Complete",
        "Subnets": [
            {
                "SubnetIdentifier": "subnet-0baad3f88b87f4903",
                "SubnetAvailabilityZone": {
                    "Name": "us-east-1a"
                },
                "SubnetOutpost": {},
                "SubnetStatus": "Active"
            },
            {
                "SubnetIdentifier": "subnet-0d9e0ac67ff825549",
                "SubnetAvailabilityZone": {
                    "Name": "us-east-1b"
                },
                "SubnetOutpost": {},
                "SubnetStatus": "Active"
            }
        ],
        "DBSubnetGroupArn": "arn:aws:rds:us-east-1:390214104376:subgrp:eks-rds-db-subnetgroup",
        "SupportedNetworkTypes": [
            "IPV4"
        ]
    }
}

# 4) Verificar
aws rds describe-db-subnet-groups --db-subnet-group-name eks-rds-db-subnetgroup

```

### Criar o Banco de Dados RDS 
- Vá em  Services -> RDS
- Clique em Create Database
  - Método de criação: Standard Create
  - Engine: MySQL  
  - Edição: MySQL Community
  - Versão: 5.7.22  (padrão)
  - Template: Free Tier
  - Identificador da instância: usermgmtdb
  - Usuário mestre: dbadmin
  - Senha mestre: dbpassword11
  - Confirmar senha: dbpassword11
  - Tamanho da instância: deixe padrão
  - Armazenamento: deixe padrão
  - Conectividade
    - VPC: eksctl-eksdemo1-cluster/VPC
    - Configuração adicional de conectividade
      - Subnet Group: eks-rds-db-subnetgroup
      - Publicly accessible: YES (para aprendizado e troubleshooting - se necessário)
    - Security Group da VPC: Create New
      - Nome: eks-rds-db-securitygroup    
    - Zona de disponibilidade: No Preference
    - Porta do banco: 3306 
  - O restante, deixe como padrão                
- Clique em Create Database


### Editar Security Group do DB para permitir acesso de 0.0.0.0/0
- Vá em EC2 -> Security Groups -> eks-rds-db-securitygroup 
- Edit Inbound Rules
  - Source: Anywhere (0.0.0.0/0)  (Permitir acesso de qualquer lugar por enquanto)

## comando 
```
  aws rds describe-db-instances --query "DBInstances[].{DB:DBInstanceIdentifier,User:MasterUsername,Endpoint:Endpoint.Address}" --output table --region us-east-1

  kubectl run -it --rm --image=mysql:latest --restart=Never mysql-client --   mysql -h usermgmtdb.c5jqxzxrhrno.us-east-1.rds.amazonaws.com -u admin -pdbpassword11

  CREATE DATABASE IF NOT EXISTS usermgmt;
  CREATE USER 'appuser'@'%' IDENTIFIED BY 'app_password_123';
  GRANT ALL PRIVILEGES ON usermgmt.* TO 'appuser'@'%';
  FLUSH PRIVILEGES;


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
            SELECT 'Dados de exemplo inseridos:' as status;
            SELECT id, name, email, age, created_at FROM users ORDER BY id;
            SELECT COUNT(*) as total_users FROM users;"

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
  externalName: usermgmtdb.c7hldelt9xfp.us-east-1.rds.amazonaws.com
```
 - Fazer deploy do manifest
```
kubectl apply -f kube-manifests/mysql/01-MySQL-externalName-Service.yml 
```
## Passo-04:  Conectar ao RDS via kubectl e criar o schema/db usermgmt
```
kubectl run -it --rm --image=mysql:latest --restart=Never mysql-client -- mysql -h usermgmtdb.c7hldelt9xfp.us-east-1.rds.amazonaws.com -u admin -pdbpassword11

CREATE DATABASE IF NOT EXISTS usermgmt;
CREATE USER 'appuser'@'%' IDENTIFIED BY 'app_password_123';
GRANT ALL PRIVILEGES ON usermgmt.* TO 'appuser'@'%';
FLUSH PRIVILEGES;

```
## Passo-05: No Deployment do User Management Microservice, trocar username de `root` para `admin`
- 02-UserManagementMicroservice-Deployment-Service.yml
```yml
# Alterar de
          - name: DB_USER
            value: "root"

# Para
          - name: DB_USER
            value: "dbadmin"            
```

## Passo-06: Fazer deploy do User Management Microservice e testar
```
# Fazer deploy de todos os manifests
kubectl apply -f kube-manifests/

# Listar Pods
kubectl get pods

# Acompanhar logs do Pod para verificar conexão com o DB pela aplicação
kubectl logs -f <pod-name>

kubectl logs -f -l app=usermgmt-restapp

```
## Passo-07: Acessar a aplicação
```
# Capturar o External IP (ou Public IP) de um Worker Node
kubectl get nodes -o wide

# Acessar a aplicação
http://<Worker-Node-Public-Ip>:31231/usermgmt/health-status
```

## Passo-08: Limpeza
```
# Deletar todos os objetos criados
kubectl delete -f kube-manifests/

# Verificar os objetos atuais no Kubernetes
kubectl get all
```
