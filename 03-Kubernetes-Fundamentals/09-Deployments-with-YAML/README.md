
# Deployments com YAML

## Passo-01: Copiar templates do ReplicaSet
- Copie os templates do ReplicaSet e altere o `kind: Deployment`
- Atualize a versão da imagem do container para `3.0.0`
- Atualize o NodePort do service para `nodePort: 31233`
- Altere todos os nomes para Deployment
- Altere todos os labels e selectors para `myapp3`

```
# Criar Deployment
kubectl apply -f 02-deployment-definition.yml
kubectl get deploy
kubectl get rs
kubectl get po

# Criar Service NodePort
kubectl apply -f 03-deployment-nodeport-service.yml

# Listar Services
kubectl get svc

# Obter IP público
kubectl get nodes -o wide

# Acessar aplicação
http://<IP-Público-do-Worker-Node>:31233
```
## Referências da API
- **Deployment:** https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#deployment-v1-apps
