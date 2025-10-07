# AWS - Classic Load Balancer - CLB

## Passo-01: Criar Manifesto Kubernetes do AWS Classic Load Balancer & Deploy
- **04-ClassicLoadBalancer.yml**
```yml
apiVersion: v1
kind: Service
metadata:
  name: clb-usermgmt-restapp
  labels:
    app: usermgmt-restapp
spec:
  type: LoadBalancer  # Manifesto de Service k8s regular com type como LoadBalancer
  selector:
    app: usermgmt-restapp     
  ports:
  - port: 80
    targetPort: 3000
```
- **Deploy de todos os Manifestos**
```bash
# Deploy de todos os manifestos
kubectl apply -f kube-manifests/

# Listar Services (Verificar o novo CLB Service criado)
kubectl get svc

# Verificar Pods
kubectl get pods
```

## Passo-02: Verificar o deployment
- Verificar se o novo CLB foi criado 
  - Vá em Services -> EC2 -> Load Balancing -> Load Balancers 
    - CLB deve estar criado
    - Copiar o DNS Name (Exemplo: a85ae6e4030aa4513bd200f08f1eb9cc-7f13b3acc1bcaaa2.elb.us-east-1.amazonaws.com)
  - Vá em Services -> EC2 -> Load Balancing -> Target Groups
    - Verificar o health status, deve aparecer como active
- **Acessar a Aplicação** 
```bash
# Acessar a Aplicação
http://<CLB-DNS-NAME>/health
http://<CLB-DNS-NAME>/users
```    

## Passo-03: Limpeza
```bash
# Deletar todos os Objetos criados
kubectl delete -f kube-manifests/

# Verificar os Objetos Kubernetes atuais
kubectl get all
```

## Troubleshooting - Solução de Problemas

### Problema: "Could not resolve host" ao acessar o LoadBalancer
**Solução:** O LoadBalancer leva de 2-5 minutos para ser totalmente provisionado e o DNS propagar.
```bash
# Aguardar alguns minutos e verificar novamente
kubectl get svc -w

# Verificar se o LoadBalancer está ativo no console AWS
# EC2 -> Load Balancers -> verificar status
```

### Problema: Pods não estão iniciando
```bash
# Verificar logs dos pods
kubectl get pods
kubectl logs <nome-do-pod>
kubectl describe pod <nome-do-pod>

# Verificar se o Secret do MySQL foi criado
kubectl get secrets

# Verificar se o ConfigMap foi criado
kubectl get configmap
```

### Problema: Health check falhando
```bash
# Verificar se a aplicação está respondendo dentro do pod
kubectl exec -it <nome-do-pod> -- curl localhost:3000/health

# Verificar os Target Groups no AWS Console
# EC2 -> Target Groups -> verificar health status
```

### Ordem de Deploy Recomendada
Para evitar problemas, faça o deploy nesta ordem:
```bash
# 1. MySQL (Storage, ConfigMap, Secret, Deployment, Service)
kubectl apply -f kube-manifests/mysql/

# 2. Aguardar MySQL estar pronto
kubectl get pods -w

# 3. Jobs (opcional - criação de tabelas e dados)
kubectl apply -f kube-manifests/jobs/

# 4. Aplicação (Deployment e Services)
kubectl apply -f kube-manifests/app/
```