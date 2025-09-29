# Kubernetes  - PODs

## Step-01: PODs Introduction
- O que é POD ?
# Kubernetes - PODs

## Passo-01: Introdução aos PODs
- O que é um POD?
- O que é um POD Multi-Container?

```
## Passo-02: Demonstração de PODs
### Verificar Status dos Nós de Trabalho
- Verifique se os nós de trabalho do Kubernetes estão prontos.
# Get Worker Node Status with wide option
kubectl get nodes -o wide
```

### Criar um Pod
- Criar um Pod
- Create a Pod


# Substitua o nome do Pod e a imagem do container

kubectl run my-first-pod --image 1234samue/aula:kubenginx-1.0.0 --generator=run-pod/v1
kubectl run <desired-pod-name> --image <Container-Image> --generator=run-pod/v1

**Nota Importante:** Sem **--generator=run-pod/v1** será criado um pod com um deployment, que é outro conceito central do Kubernetes que veremos em breve.

**Nota Importante:**
  - A partir da versão **Kubernetes 1.18**, houve muitas mudanças no comando **kubectl run**.
  - O comando abaixo já é suficiente para criar um Pod sem criar um deployment. Não é necessário adicionar **--generator=run-pod/v1**.

- **Nota Importante:** Sem **--generator=run-pod/v1** iele criará um pod com uma implantação, que é outro conceito central do k8s que aprederemos no futuro 

### Listar Pods
- Obtenha a lista de pods
  - O seguinte será suficiente para criar um Pod como um pod sem criar uma implantação. Não precisamos adicionar
  **--generator=run-pod/v1**

# O nome alternativo para pods é po
kubectl get po
```  
### Listar Pods com opção wide
- Lista os pods com a opção wide, que também mostra em qual nó o Pod está rodando
- Get the list of pods

### O que acontece em segundo plano quando o comando acima é executado?
  1. O Kubernetes cria um pod
  2. Baixa a imagem docker do Docker Hub
  3. Cria o container dentro do pod
  4. Inicia o container presente no pod

kubectl get po

### Descrever o Pod
- Descreva o POD, principalmente necessário para troubleshooting.
- Os eventos mostrados serão de grande ajuda durante a resolução de problemas.
- List pods with wide option which also provide Node information on which Pod is running

### Acessar a Aplicação
- Atualmente, só podemos acessar esta aplicação dentro dos nós de trabalho.
- Para acessar externamente, precisamos criar um **NodePort Service**.
- **Services** é um conceito muito importante no Kubernetes.


### O que aconteceu em segundo plano quando o comando acima foi executado?

### push Pod
  2. Pulled imagem do docker do docker hub

## Passo-03: Introdução ao NodePort Service
- O que são Services no k8s?
- O que é um NodePort Service?
- Como funciona?

### Describe Pod

## Passo-04: Demonstração - Expor Pod com um Service
- Exponha o pod com um service (NodePort Service) para acessar a aplicação externamente (pela internet)

- **Portas**
  - **port:** Porta na qual o NodePort Service escuta internamente no cluster Kubernetes
  - **targetPort:** Porta do container onde a aplicação está rodando
  - **NodePort:** Porta do nó de trabalho pela qual podemos acessar a aplicação

# Describe the Pod

# Expor Pod como um Service
kubectl describe pod my-first-pod 

# Obter informações do Service

# Obter IP público dos nós de trabalho
- Currently we can access this application only inside worker nodes. 
# Acessar a aplicação usando o IP público
- **Services** is one very very important concept in Kubernetes. 
# Expor Pod como um Service com porta do container (--target-port)

# Obter informações do Service
```
# Obter IP público dos nós de trabalho
kubectl get pods
# Acessar a aplicação usando o IP público

# Delete Pod

## Passo-05: Interagir com um Pod
kubectl delete pod my-first-pod
### Verificar logs do Pod

# Obter nome do Pod
- O que são serviços no k8s?

# Exibir logs do Pod
- Como funciona?

# Exibir logs em tempo real com a opção -f e acessar a aplicação para ver os logs

## Step-04: Demo - Expose Pod with a Service
# Conectar ao container em um POD
- **Ports**
# Execute alguns comandos no container Nginx
  - **targetPort:** We define container port here on which our application is running.
# Executando comandos individuais em um container
```
# Comandos de exemplo
kubectl run <desired-pod-name> --image <Container-Image> --generator=run-pod/v1

## Passo-06: Obter saída YAML do Pod e do Service

### Obter saída YAML

# Expose Pod as a Service
# Obter saída YAML da definição do pod
kubectl expose pod my-first-pod  --type=NodePort --port=80 --name=my-first-service

# Obter saída YAML da definição do service

# Get Service Info

## Passo-07: Limpeza
kubectl get svc
# Obter todos os objetos no namespace padrão
# Get Public IP of Worker Nodes

# Excluir Services
```
# Excluir Pod
```
# Obter todos os objetos no namespace padrão
```

- **Important Note about: target-port**
  - Se a porta de destino não for definida, por padrão e por conveniência, o **targetPort**é definido com o mesmo valor que o **port** field.

```

# O comando abaixo falhará ao acessar o aplicativo, pois a porta de serviço (81) e a porta do contêiner (80) são diferentes
kubectl expose pod my-first-pod  --type=NodePort --port=81 --name=my-first-service2     

# Expose Pod como um serviço com Container Port(--taret-port)
kubectl expose pod my-first-pod  --type=NodePort --port=81 --target-port=80 --name=my-first-service3

# Get Service Info
kubectl get service
kubectl get svc

# Get Public IP of Worker Nodes
kubectl get nodes -o wide
```
- **Acesse o aplicativo usando Public IP**
```
http://<node1-public-ip>:<Node-Port>
```

## Step-05: Interact with a Pod

### Verify Pod Logs
```
# Get Pod Name
kubectl get po

# Dump Pod logs
kubectl logs <pod-name>
kubectl logs my-first-pod

# Stream pod logs com a opção -f e acesso ao aplicativo para ver os logs
kubectl logs <pod-name>
kubectl logs -f my-first-pod
```
- **Notas importantes**
  - Consulte o link abaixo e pesquise por **Interagindo com running Pods** para opções adicionais de registro
- Habilidades de resolução de problemas são muito importantes. Portanto, analise todas as opções de registro disponíveis e domine-as.
  - **Referência:** https://kubernetes.io/docs/reference/kubectl/cheatsheet/

### Connect to Container in a POD
- **Connect to a Container in POD and execute commands**
```
# Connect to Nginx Container in a POD
kubectl exec -it <pod-name> -- /bin/bash
kubectl exec -it my-first-pod -- /bin/bash

# Execute some commands in Nginx container
ls
cd /usr/share/nginx/html
cat index.html
exit
```

- **Running individual commands in a Container**
```
kubectl exec -it <pod-name> env

# Sample Commands
kubectl exec -it my-first-pod env
kubectl exec -it my-first-pod ls
kubectl exec -it my-first-pod cat /usr/share/nginx/html/index.html
```
## Step-06: Get YAML Output of Pod & Service
### Get YAML Output
```
# Get pod definition YAML output
kubectl get pod my-first-pod -o yaml   

# Get service definition YAML output
kubectl get service my-first-service -o yaml   
```

## Step-07: Clean-Up
```
# Get all Objects in default namespace
kubectl get all

# Delete Services
kubectl delete svc my-first-service
kubectl delete svc my-first-service2
kubectl delete svc my-first-service3

# Delete Pod
kubectl delete pod my-first-pod

# Get all Objects in default namespace
kubectl get all
```