
# Pausar & Retomar Deployments

## Passo-00: Introdução
- Por que precisamos pausar e retomar Deployments?
  - Se quisermos fazer várias alterações em nosso Deployment, podemos pausar o deployment, fazer todas as alterações e depois retomá-lo.
- Vamos atualizar a versão da nossa aplicação de **V3 para V4** como parte do aprendizado de "Pausar e Retomar Deployments".

## Passo-01: Pausando & Retomando Deployments
### Verificar o estado atual do Deployment e da aplicação
```
# Verificar o histórico de rollout de um Deployment
kubectl rollout history deployment/my-first-deployment  
Observação: Anote o número da última versão

# Obter lista de ReplicaSets
kubectl get rs
Observação: Anote o número de ReplicaSets presentes.

# Acessar a aplicação
http://<worker-node-ip>:<Node-Port>
Observação: Anote a versão da aplicação
```

### Pausar o Deployment e fazer duas alterações
```
# Pausar o Deployment
kubectl rollout pause deployment/<nome-do-deployment>
kubectl rollout pause deployment/my-first-deployment

# Atualizar o Deployment - Versão da aplicação de V3 para V4
kubectl set image deployment/my-first-deployment kubenginx=aula/kubenginx:4.0.0 --record=true

# Verificar o histórico de rollout de um Deployment
kubectl rollout history deployment/my-first-deployment  
Observação: Nenhum novo rollout deve iniciar, devemos ver o mesmo número de versões que verificamos anteriormente, com o último número de versão igual ao que anotamos.

# Obter lista de ReplicaSets
kubectl get rs
Observação: Nenhum novo ReplicaSet criado. Devemos ter o mesmo número de ReplicaSets que anotamos anteriormente.

# Fazer mais uma alteração: definir limites para nosso container
kubectl set resources deployment/my-first-deployment -c=kubenginx --limits=cpu=20m,memory=30Mi
```
### Retomar o Deployment
```
# Retomar o Deployment
kubectl rollout resume deployment/my-first-deployment

# Verificar o histórico de rollout de um Deployment
kubectl rollout history deployment/my-first-deployment  
Observação: Você deve ver que uma nova versão foi criada

# Obter lista de ReplicaSets
kubectl get rs
Observação: Você deve ver um novo ReplicaSet.
```
### Acessar a aplicação
```
# Acessar a aplicação
http://<node1-public-ip>:<Node-Port>
Observação: Você deve ver a versão V4 da aplicação
```

## Passo-02: Limpeza
```
# Excluir Deployment
kubectl delete deployment my-first-deployment

# Excluir Service
kubectl delete svc my-first-deployment-service

# Obter todos os objetos do namespace default do Kubernetes
kubectl get all
```