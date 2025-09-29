# Kubernetes - Deployment
## Passo-01: Introdução a Deployments
- O que é um Deployment?
- O que podemos fazer usando Deployment?
- Criar um Deployment
- Escalar o Deployment
- Expor o Deployment como um Service
- Scale the Deployment
- Expose the Deployment as a Service
## Passo-02: Criar Deployment
- Criar Deployment para criar um ReplicaSet
- Verificar Deployment, ReplicaSet e Pods
- **Local da Imagem Docker:** https://hub.docker.com/repository/docker/aula/kubenginx
- Verify Deployment, ReplicaSet & Pods
- **Docker Image Location:** https://hub.docker.com/repository/docker/aula/kubenginx
```
# Create Deployment
kubectl create deployment <Deplyment-Name> --image=<Container-Image>
kubectl create deployment my-first-deployment --image=aula/kubenginx:1.0.0 

# Verify Deployment
kubectl get deployments
kubectl get deploy 

# Describe Deployment
kubectl describe deployment <deployment-name>
kubectl describe deployment my-first-deployment

# Verify ReplicaSet
kubectl get rs

# Criar Deployment
kubectl create deployment <nome-do-deployment> --image=<imagem-do-container>
kubectl create deployment my-first-deployment --image=aula/kubenginx:1.0.0 

# Verificar Deployment
kubectl get deployments
kubectl get deploy 

# Descrever Deployment
kubectl describe deployment <nome-do-deployment>
kubectl describe deployment my-first-deployment

# Verificar ReplicaSet
kubectl get rs

# Verificar Pod
kubectl get po
# Verify Pod
kubectl get po
## Passo-03: Escalando um Deployment
- Escale o deployment para aumentar o número de réplicas (pods)
## Step-03: Scaling a Deployment
- Scale the deployment to increase the number of replicas (pods)
```
# Scale Up the Deployment
kubectl scale --replicas=20 deployment/<Deployment-Name>
kubectl scale --replicas=20 deployment/my-first-deployment 

# Verify Deployment
kubectl get deploy

# Verify ReplicaSet
kubectl get rs

# Verify Pods
kubectl get po

# Scale Down the Deployment
# Escalar para cima o Deployment
kubectl scale --replicas=20 deployment/<nome-do-deployment>
kubectl scale --replicas=20 deployment/my-first-deployment 

# Verificar Deployment
kubectl get deploy

# Verificar ReplicaSet
kubectl get rs

# Verificar Pods
kubectl get po

# Escalar para baixo o Deployment
kubectl scale --replicas=10 deployment/my-first-deployment 
kubectl get deploy
kubectl scale --replicas=10 deployment/my-first-deployment 
kubectl get deploy
## Passo-04: Expor Deployment como um Service
- Exponha o **Deployment** com um service (NodePort Service) para acessar a aplicação externamente (pela internet)

## Step-04: Expose Deployment as a Service
- Expose **Deployment** with a service (NodePort Service) to access the application externally (from internet)
```
# Expose Deployment as a Service
kubectl expose deployment <Deployment-Name>  --type=NodePort --port=80 --target-port=80 --name=<Service-Name-To-Be-Created>
kubectl expose deployment my-first-deployment --type=NodePort --port=80 --target-port=80 --name=my-first-deployment-service

# Get Service Info
kubectl get svc
Observation: Make a note of port which starts with 3 (Example: 80:3xxxx/TCP). Capture the port 3xxxx and use it in application URL below. 

# Expor Deployment como um Service
kubectl expose deployment <nome-do-deployment>  --type=NodePort --port=80 --target-port=80 --name=<nome-do-service>
kubectl expose deployment my-first-deployment --type=NodePort --port=80 --target-port=80 --name=my-first-deployment-service

# Obter informações do Service
kubectl get svc
Observação: Anote a porta que começa com 3 (Exemplo: 80:3xxxx/TCP). Capture a porta 3xxxx e use na URL da aplicação abaixo. 

# Obter IP público dos nós de trabalho
kubectl get nodes -o wide
Observação: Anote o "EXTERNAL-IP" se seu cluster Kubernetes estiver no AWS EKS.
# Get Public IP of Worker Nodes
**Acessar a aplicação usando o IP público**
Observation: Make a note of "EXTERNAL-IP" if your Kubernetes cluster is setup on AWS EKS.
```
http://<ip-publico-do-worker-node>:<Node-Port>
- **Access the Application using Public IP**
```
http://<worker-node-public-ip>:<Node-Port>
```