# Kubernetes - Update Deployments

## Step-00: Introduction
# Kubernetes - Atualizar Deployments
  - Set Image
## Passo-00: Introdução
- Podemos atualizar deployments usando duas opções:
  - Setar Imagem
  - Editar Deployment
- **Observation:** Please Check the container name in `spec.container.name` yaml output and make a note of it and 
## Passo-01: Atualizando a versão da aplicação de V1 para V2 usando a opção "Set Image"
### Atualizar Deployment
- **Observação:** Verifique o nome do container em `spec.container.name` na saída YAML e utilize no comando `kubectl set image` <Nome-do-Container>

# Obter nome do container do deployment atual
kubectl get deployment my-first-deployment -o yaml

# Atualizar Deployment - DEVE FUNCIONAR AGORA
kubectl set image deployment/<nome-do-deployment> <nome-do-container>=<imagem-do-container> --record=true
kubectl set image deployment/my-first-deployment kubenginx=aula/kubenginx:2.0.0 --record=true
```
### Verificar Status do Rollout (Status do Deployment)
- **Observação:** Por padrão, o rollout acontece no modelo rolling update, então não há downtime.

# Verificar Status do Rollout
kubectl rollout status deployment/my-first-deployment

# Verificar Deployment
kubectl get deploy
  - Verify the Events and understand that Kubernetes by default do  "Rolling Update"  for new application releases. 
### Descrever Deployment
- **Observação:**
  - Verifique os eventos e entenda que o Kubernetes faz "Rolling Update" por padrão para novas versões da aplicação.
  - Com isso, não teremos downtime na aplicação.
```
# Descrever Deployment
kubectl describe deployment my-first-deployment
```
### Verificar ReplicaSet
- **Observação:** Um novo ReplicaSet será criado para a nova versão
```
# Verificar ReplicaSet
kubectl get rs
- **Observation:** Pod template hash label of new replicaset should be present for PODs letting us 
### Verificar Pods
- **Observação:** O label de hash do template do novo replicaset deve estar presente nos PODs, indicando que pertencem ao novo ReplicaSet.
kubectl get po
# Listar Pods
kubectl get po
### Verify Rollout History of a Deployment
### Verificar Histórico de Rollout de um Deployment
- **Observação:** Temos o histórico de rollout, então podemos voltar para revisões anteriores usando o histórico disponível.
```
# Check the Rollout History of a Deployment
# Verificar o Histórico de Rollout de um Deployment
kubectl rollout history deployment/<nome-do-deployment>
kubectl rollout history deployment/my-first-deployment  

### Acessar a aplicação usando o IP público
- Devemos ver `Application Version:V2` ao acessar a aplicação no navegador
```
# Obter NodePort
kubectl get svc
Observação: Anote a porta que começa com 3 (Exemplo: 80:3xxxx/TCP). Capture a porta 3xxxx e use na URL da aplicação abaixo. 

# Obter IP público dos nós de trabalho
kubectl get nodes -o wide
Observação: Anote o "EXTERNAL-IP" se seu cluster Kubernetes estiver no AWS EKS.

# URL da aplicação
http://<ip-publico-do-worker-node>:<Node-Port>
```


## Passo-02: Atualizar a aplicação de V2 para V3 usando a opção "Edit Deployment"
### Editar Deployment
```
# Editar Deployment
kubectl edit deployment/<nome-do-deployment> --record=true
kubectl edit deployment/my-first-deployment --record=true
```

```yml
# Alterar de 2.0.0
    spec:
      containers:
      - image: aula/kubenginx:2.0.0

# Alterar para 3.0.0
    spec:
      containers:
      - image: aula/kubenginx:3.0.0
```

### Verificar Status do Rollout
- **Observação:** O rollout acontece no modelo rolling update, então não há downtime.
```
# Verificar Status do Rollout
kubectl rollout status deployment/my-first-deployment
```
### Verificar Replicasets
- **Observação:** Devemos ver 3 ReplicaSets agora, pois atualizamos a aplicação para a terceira versão 3.0.0
```
# Verificar ReplicaSet e Pods
kubectl get rs
kubectl get po
```
### Verificar Histórico de Rollout
```
# Verificar o Histórico de Rollout de um Deployment
kubectl rollout history deployment/<nome-do-deployment>
kubectl rollout history deployment/my-first-deployment   
```

### Acessar a aplicação usando o IP público
- Devemos ver `Application Version:V3` ao acessar a aplicação no navegador
```
# Obter NodePort
kubectl get svc
Observação: Anote a porta que começa com 3 (Exemplo: 80:3xxxx/TCP). Capture a porta 3xxxx e use na URL da aplicação abaixo. 

# Obter IP público dos nós de trabalho
kubectl get nodes -o wide
Observação: Anote o "EXTERNAL-IP" se seu cluster Kubernetes estiver no AWS EKS.

# URL da aplicação
http://<ip-publico-do-worker-node>:<Node-Port>
```
