# EKS - Criar Node Group EKS em Subnets Privadas

## Passo-01: Introdução
- Vamos criar um node group em Subnets Privadas da VPC
- Vamos fazer deploy de workloads no node group privado onde os workloads rodarão em subnets privadas e o load balancer será criado na subnet pública e acessível via internet
- **Vantagens**:
  - Maior segurança (workloads não expostos diretamente à internet)
  - Controle de tráfego via NAT Gateway
  - Conformidade com melhores práticas de segurança
  - Isolamento de recursos sensíveis

## Passo-02: Deletar Node Group Público existente no Cluster EKS
```bash
# Listar NodeGroups em um Cluster EKS
eksctl get nodegroup --cluster=<Nome-do-Cluster>
eksctl get nodegroup --cluster=eksdemo1

# Deletar Node Group - Substitua o nome do nodegroup e cluster
eksctl delete nodegroup <Nome-do-NodeGroup> --cluster <Nome-do-Cluster>
eksctl delete nodegroup eksdemo1-ng-public1 --cluster eksdemo1

# Aguardar deleção completa
eksctl get nodegroup --cluster=eksdemo1
```

## Passo-03: Criar EKS Node Group em Subnets Privadas
- Criar Node Group Privado em um Cluster
- Opção chave do comando é `--node-private-networking`

```bash
eksctl create nodegroup --cluster=eksdemo1 \
                        --region=us-east-1 \
                        --name=eksdemo1-ng-private1 \
                        --node-type=t3.medium \
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
                        --alb-ingress-access \
                        --node-private-networking
```

### Explicação das Opções:
- `--node-private-networking`: Cria nodes em subnets privadas
- `--managed`: Usa EKS Managed Node Groups
- `--asg-access`: Permite acesso ao Auto Scaling Group
- `--external-dns-access`: Permite acesso ao DNS externo
- `--full-ecr-access`: Acesso completo ao ECR
- `--appmesh-access`: Acesso ao AWS App Mesh
- `--alb-ingress-access`: Acesso ao Application Load Balancer

## Passo-04: Verificar se Node Group foi criado em Subnets Privadas

### Verificar Endereço IP Externo dos Worker Nodes
- Endereço IP Externo deve ser "none" se nossos Worker Nodes foram criados em Subnets Privadas
```bash
kubectl get nodes -o wide
```

### Verificação da Tabela de Rotas da Subnet - Tráfego de Saída via NAT Gateway
- Verificar as rotas da subnet do node group para garantir que foi criado em subnets privadas
  - Vá em Services -> EKS -> eksdemo -> eksdemo1-ng1-private
  - Clique em Associated subnet na aba **Details**
  - Clique na aba **Route Table**
  - Devemos ver que a rota da internet vai via NAT Gateway (0.0.0.0/0 -> nat-xxxxxxxx)

### Comandos de Verificação Adicionais
```bash
# Verificar status do node group
eksctl get nodegroup --cluster=eksdemo1

# Verificar detalhes dos nodes
kubectl describe nodes

# Verificar se os nodes estão prontos
kubectl get nodes --show-labels

# Verificar conectividade de rede
kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default
```

## Passo-05: Configurar Load Balancer para Acesso Externo
- Com nodes privados, precisamos de um Load Balancer para expor serviços
- O Load Balancer será criado na subnet pública
- Os pods rodarão nos nodes privados

### Exemplo de Service com LoadBalancer
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: my-app
```

## Passo-06: Testar Conectividade
```bash
# Deploy de aplicação de teste
kubectl run nginx --image=nginx --port=80

# Expor via LoadBalancer
kubectl expose pod nginx --type=LoadBalancer --port=80

# Describe the service to see detailed status
kubectl describe service nginx

# Verificar service
kubectl get svc
kubectl get svc nginx -w

# Testar conectividade (aguardar External IP)
curl http://<EXTERNAL-IP>
```

## Observações Importantes:
- **NAT Gateway**: Necessário para nodes privados acessarem internet
- **Custos**: NAT Gateway tem custo adicional
- **Load Balancer**: Necessário para expor serviços externamente
- **SSH**: Acesso via bastion host ou VPN
- **Logs**: CloudWatch Logs funcionam normalmente