# AWS - Network Load Balancer - NLB

## Passo-01: Criar Manifesto Kubernetes do AWS Network Load Balancer & Deploy
- **04-NetworkLoadBalancer.yml**
```yml
apiVersion: v1
kind: Service
metadata:
  name: nlb-usermgmt-restapp
  labels:
    app: usermgmt-restapp
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb    # Para criar Network Load Balancer
spec:
  type: LoadBalancer # Manifesto de Service k8s regular com type como LoadBalancer
  selector:
    app: usermgmt-restapp     
  ports:
  - port: 80
    targetPort: 3000
```
- **Deploy de todos os Manifestos**
```bash
# Deploy de todos os manifestos
kubectl apply -f kube-manifests/app

# Listar Services (Verificar o novo NLB Service criado)
kubectl get svc

# Verificar Pods
kubectl get pods
```

## Passo-02: Verificar o deployment
- Verificar se o novo NLB foi criado 
  - Vá em Services -> EC2 -> Load Balancing -> Load Balancers 
    - NLB deve estar criado
    - Copiar o DNS Name (Exemplo: a85ae6e4030aa4513bd200f08f1eb9cc-7f13b3acc1bcaaa2.elb.us-east-1.amazonaws.com)
  - Vá em Services -> EC2 -> Load Balancing -> Target Groups
    - Verificar o health status, deve aparecer como active
- **Acessar a Aplicação** 
```bash
# Acessar a Aplicação
http://<NLB-DNS-NAME>/health
http://<NLB-DNS-NAME>/users
```    

## Passo-03: Limpeza
```bash
# Deletar todos os Objetos criados
kubectl delete -f kube-manifests/

# Verificar os Objetos Kubernetes atuais
kubectl get all
```

## Diferenças entre NLB e CLB

### Network Load Balancer (NLB)
- **Camada 4** (TCP/UDP)
- Melhor performance (milhões de requisições por segundo)
- Menor latência
- Preserva IP do cliente
- Suporta IP estático e Elastic IP
- Ideal para tráfego TCP/UDP de alta performance

### Classic Load Balancer (CLB)
- **Camada 4 e 7** (TCP e HTTP/HTTPS)
- Performance moderada
- Mais simples de configurar
- Não preserva IP do cliente por padrão
- Legado (AWS recomenda NLB ou ALB)

## Troubleshooting - Solução de Problemas

### Problema: "Could not resolve host" ao acessar o LoadBalancer
**Solução:** O LoadBalancer leva de 2-5 minutos para ser totalmente provisionado e o DNS propagar.
```bash
# Aguardar alguns minutos e verificar novamente
kubectl get svc -w

# Verificar se o LoadBalancer está ativo no console AWS
# EC2 -> Load Balancers -> verificar status
```

### Problema: NLB não foi criado (CLB foi criado ao invés)
**Solução:** Verificar se a annotation está correta no manifesto
```bash
# A annotation deve estar presente:
service.beta.kubernetes.io/aws-load-balancer-type: nlb

# Verificar o service
kubectl describe svc nlb-usermgmt-restapp
```

### Problema: Pods não estão iniciando
```bash
# Verificar logs dos pods
kubectl get pods
kubectl logs <nome-do-pod>
kubectl describe pod <nome-do-pod>

# Verificar se o Secret do MySQL foi criado
kubectl get secrets

# Verificar se o ExternalName service está correto
kubectl get svc mysql
```

### Problema: Health check falhando
```bash
# Verificar se a aplicação está respondendo dentro do pod
kubectl exec -it <nome-do-pod> -- curl localhost:3000/health

# Verificar os Target Groups no AWS Console
# EC2 -> Target Groups -> verificar health status
```

### Ordem de Deploy Recomendada
```bash
# 1. Verificar se o MySQL do CLB ainda está rodando
kubectl get svc mysql

# 2. Deploy da aplicação com NLB
kubectl apply -f kube-manifests/

# 3. Verificar status
kubectl get pods
kubectl get svc
```


