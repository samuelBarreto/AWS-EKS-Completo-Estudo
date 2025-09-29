# Rollback Deployment

## Step-00: Introduction
- We can rollback a deployment in two ways.
  # Rollback de Deployment
  - Specific Version
  ## Passo-00: Introdução
  - Podemos fazer rollback de um deployment de duas formas:
    - Versão anterior
    - Versão específica
```
  ## Passo-01: Fazer rollback de um Deployment para a versão anterior
kubectl rollout history deployment/<Deployment-Name>
  ### Verificar o histórico de rollout de um Deployment
```
  # Listar histórico de rollout do Deployment
  kubectl rollout history deployment/<nome-do-deployment>
  kubectl rollout history deployment/my-first-deployment  
```
# List Deployment History with revision information
  ### Verificar mudanças em cada revisão
  - **Observação:** Revise as tags "Annotations" e "Image" para entender claramente as mudanças.
kubectl rollout history deployment/my-first-deployment --revision=3
  # Listar histórico do Deployment com informações de revisão
  kubectl rollout history deployment/my-first-deployment --revision=1
  kubectl rollout history deployment/my-first-deployment --revision=2
  kubectl rollout history deployment/my-first-deployment --revision=3
  - **Observação:** Se fizermos rollback, ele voltará para a revisão 2 e o número aumentará para revisão 4
```
  ### Rollback para a versão anterior
  - **Observação:** Se fizermos rollback, ele voltará para a revisão 2 e o número aumentará para revisão 4

  # Desfazer Deployment
  kubectl rollout undo deployment/my-first-deployment

  # Listar histórico de rollout do Deployment
  kubectl rollout history deployment/my-first-deployment  
```
kubectl get deploy
  ### Verificar Deployment, Pods, ReplicaSets
kubectl get po
  kubectl get deploy
  kubectl get rs
  kubectl get po
  kubectl describe deploy my-first-deployment
- Devemos ver `Application Version:V2` ao acessar a aplicação no navegador
```
  ### Acessar a aplicação usando o IP público
  - Devemos ver `Application Version:V2` ao acessar a aplicação no navegador
Observação: Anote a porta que começa com 3 (Exemplo: 80:3xxxx/TCP). Capture a porta 3xxxx e use na URL da aplicação abaixo. 
  # Obter NodePort
  kubectl get svc
  Observação: Anote a porta que começa com 3 (Exemplo: 80:3xxxx/TCP). Capture a porta 3xxxx e use na URL da aplicação abaixo. 

  # Obter IP público dos nós de trabalho
  kubectl get nodes -o wide
  Observação: Anote o "EXTERNAL-IP" se seu cluster Kubernetes estiver no AWS EKS.

  # URL da aplicação
  http://<ip-publico-do-worker-node>:<Node-Port>
## Step-02: Rollback to specific revision
### Check the Rollout History of a Deployment
```
  ## Passo-02: Rollback para uma revisão específica
  ### Verificar o histórico de rollout de um Deployment
kubectl rollout history deployment/my-first-deployment 
  # Listar histórico de rollout do Deployment
  kubectl rollout history deployment/<nome-do-deployment>
  kubectl rollout history deployment/my-first-deployment 
# Rollback Deployment to Specific Revision
  ### Rollback para uma revisão específica
```
  # Rollback do Deployment para revisão específica
  kubectl rollout undo deployment/my-first-deployment --to-revision=3
  - **Observação:** Se fizermos rollback para a revisão 3, ele voltará para a revisão 3 e o número aumentará para revisão 5 no histórico de rollout
```
  ### Listar histórico do Deployment
  - **Observação:** Se fizermos rollback para a revisão 3, ele voltará para a revisão 3 e o número aumentará para revisão 5 no histórico de rollout
```
  # Listar histórico de rollout do Deployment
  kubectl rollout history deployment/my-first-deployment  
### Acessar a aplicação usando o IP público
- Devemos ver `Application Version:V3` ao acessar a aplicação no navegador
```
  ### Acessar a aplicação usando o IP público
  - Devemos ver `Application Version:V3` ao acessar a aplicação no navegador
Observation: Make a note of port which starts with 3 (Example: 80:3xxxx/TCP). Capture the port 3xxxx and use it in application URL below. 
  # Obter NodePort
  kubectl get svc
  Observação: Anote a porta que começa com 3 (Exemplo: 80:3xxxx/TCP). Capture a porta 3xxxx e use na URL da aplicação abaixo. 

  # Obter IP público dos nós de trabalho
  kubectl get nodes -o wide
  Observação: Anote o "EXTERNAL-IP" se seu cluster Kubernetes estiver no AWS EKS.

  # URL da aplicação
  http://<ip-publico-do-worker-node>:<Node-Port>
- Rolling restarts will kill the existing pods and recreate new pods in a rolling fashion. 
```
  ## Passo-03: Rolling Restarts da aplicação
   Rolling restarts irá finalizar os pods existentes e criar novos pods de forma gradual.
kubectl rollout restart deployment/my-first-deployment
  # Rolling Restarts
  kubectl rollout restart deployment/<nome-do-deployment>
  kubectl rollout restart deployment/my-first-deployment

  # Obter lista de Pods
  kubectl get po