# Criar Cluster EKS e Node Groups

## Passo-00: Introdução
- Entender sobre os Objetos Principais do EKS
  - Control Plane (Plano de Controle)
  - Worker Nodes e Node Groups
  - Fargate Profiles
  - VPC
- Criar Cluster EKS
- Associar Cluster EKS ao Provedor IAM OIDC
- Criar Node Groups do EKS
- Verificar Cluster, Node Groups, Instâncias EC2, Políticas IAM e Node Groups


## Passo-01: Criar Cluster EKS usando eksctl
- Levará de 15 a 20 minutos para criar o Control Plane do Cluster
```
# Criar Cluster
eksctl create cluster --name=eksdemo1 \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --without-nodegroup 

# Obter Lista de clusters
eksctl get cluster                  
```


## Passo-02: Criar e Associar Provedor IAM OIDC para nosso Cluster EKS
- Para habilitar e usar roles IAM da AWS para service accounts do Kubernetes em nosso cluster EKS, devemos criar e associar o provedor de identidade OIDC.
- Para fazer isso usando `eksctl` podemos usar o comando abaixo.
- Use a versão mais recente do eksctl (hoje a versão mais recente é `0.21.0`)
```                   
# Template
eksctl utils associate-iam-oidc-provider \
    --region region-code \
    --cluster <nome-do-cluster> \
    --approve

# Substituir com região e nome do cluster
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster eksdemo1 \
    --approve
```



## Passo-03: Criar EC2 Keypair
- Criar um novo EC2 Keypair com o nome `kube-demo`
- Este keypair será usado ao criar o NodeGroup do EKS.
- Isso nos ajudará a fazer login nos Worker Nodes do EKS usando Terminal.

## Passo-04: Criar Node Group com Add-Ons Adicionais em Subnets Públicas
- Estes add-ons criarão as respectivas políticas IAM automaticamente dentro da role do Node Group.
 ```
# Criar Node Group Público   
eksctl create nodegroup --cluster=eksdemo1 \
                        --region=us-east-1 \
                        --name=eksdemo1-ng-public1 \
                        --node-type=t3.medium \
                        --nodes=2 \
                        --nodes-min=2 \
                        --nodes-max=4 \
                        --node-volume-size=20 \
                        --ssh-access \
                        --ssh-public-key=kube-demo \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access 

kubectl get nodes

kubectl get nodes -o wide
```

## Passo-05: Verificar Cluster e Nodes

### Verificar Subnets do NodeGroup para confirmar que Instâncias EC2 estão em Subnet Pública
- Verificar a subnet do node group para garantir que foi criada em subnets públicas
  - Ir para Services -> EKS -> eksdemo -> eksdemo1-ng1-public
  - Clicar em Associated subnet na aba **Details**
  - Clicar na aba **Route Table**.
  - Devemos ver a rota de internet via Internet Gateway (0.0.0.0/0 -> igw-xxxxxxxx)

### Verificar Cluster, NodeGroup no Console de Gerenciamento EKS
- Ir para Services -> Elastic Kubernetes Service -> eksdemo1

### Listar Worker Nodes
```
# Listar clusters EKS
eksctl get cluster

# Listar NodeGroups em um cluster
eksctl get nodegroup --cluster=<nomeDoCluster>

# Listar Nodes no cluster kubernetes atual
kubectl get nodes -o wide

# Nosso contexto kubectl deve ser automaticamente alterado para o novo cluster
kubectl config view --minify
```

### Verificar Role IAM do Worker Node e lista de Políticas
- Ir para Services -> EC2 -> Worker Nodes
- Clicar em **IAM Role associated to EC2 Worker Nodes**

### Verificar Security Group Associado aos Worker Nodes
- Ir para Services -> EC2 -> Worker Nodes
- Clicar em **Security Group** associado à Instância EC2 que contém `remote` no nome.

### Verificar Stacks do CloudFormation
- Verificar Stack do Control Plane e Eventos
- Verificar Stack do NodeGroup e Eventos

### Fazer Login no Worker Node usando Keypair kube-demo
- Fazer login no worker node
```
# Para MAC ou Linux ou Windows10
ssh -i kube-demo.pem ec2-user@<IP-Público-do-Worker-Node>

# Para Windows 7
Use putty
```

## Passo-06: Atualizar Security Group dos Worker Nodes para permitir todo tráfego
- Precisamos permitir `All Traffic` no security group do worker node

## Referências Adicionais
- https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
- https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html
