# Kubernetes - ReplicaSets

## Passo-01: Introdução aos ReplicaSets
- O que são ReplicaSets?
- Qual a vantagem de usar ReplicaSets?

## Passo-02: Criar ReplicaSet

### Criar ReplicaSet
# Kubernetes - ReplicaSets

```
kubectl create -f replicaset-demo.yml
```

```
## Passo-01: Introdução aos ReplicaSets
- O que são ReplicaSets?
- Qual a vantagem de usar ReplicaSets?
```

## Passo-02: Criar ReplicaSet
kind: ReplicaSet

### Criar ReplicaSet
- Criar ReplicaSet
  labels:

### Listar ReplicaSets
- Obter lista de ReplicaSets
  replicas: 3

### Descrever ReplicaSet
- Descrever o ReplicaSet recém-criado
      app: my-helloworld

### Lista de Pods
- Obter lista de Pods
      labels:

### Verificar o Dono do Pod
- Verifique a referência de dono do pod.
- Veja na tag **"name"** dentro de **"ownerReferences"**. Você encontrará o nome do replicaset ao qual o pod pertence.
      - name: my-helloworld-app

## Passo-03: Expor ReplicaSet como um Service
- Exponha o ReplicaSet com um service (NodePort Service) para acessar a aplicação externamente (pela internet)

## Passo-04: Testar Confiabilidade ou Alta Disponibilidade do ReplicaSet
- Teste como o conceito de alta disponibilidade ou confiabilidade é alcançado automaticamente no Kubernetes
- Sempre que um POD é terminado acidentalmente por algum problema, o ReplicaSet deve recriar esse Pod para manter o número desejado de réplicas e garantir alta disponibilidade.
kubectl get replicaset

## Passo-05: Testar o recurso de escalabilidade do ReplicaSet
- Teste como a escalabilidade é rápida e simples
- Atualize o campo **replicas** em **replicaset-demo.yml** de 3 para 6.

### Describe ReplicaSet
## Passo-06: Excluir ReplicaSet e Service
### Excluir ReplicaSet
kubectl describe rs/<replicaset-name>

### Excluir Service criado para o ReplicaSet
kubectl describe rs/my-helloworld-rs

## Conceito pendente em ReplicaSet
- Não discutimos sobre **Labels & Selectors**
- Esse conceito será detalhado quando aprendermos a escrever manifestos YAML do Kubernetes.
- Vamos entender isso melhor na seção **ReplicaSets-YAML**.

### List of Pods
- Get list of Pods
```
# Obter lista de Pods
kubectl get pods
kubectl describe pod <pod-name>

# Obter lista de Pods com IP do Pod e nó em que está rodando
kubectl get pods -o wide
```

### Verificar o Dono do Pod
- Verifique a referência de dono do pod.
- Veja na tag **"name"** dentro de **"ownerReferences"**. Você encontrará o nome do replicaset ao qual o pod pertence.
```
kubectl get pods <pod-name> -o yaml
kubectl get pods my-helloworld-rs-c8rrj -o yaml 
```

## Step-03: Expose ReplicaSet as a Service
- Expose ReplicaSet with a service (NodePort Service) to access the application externally (from internet)

```
# Expor ReplicaSet como um Service
kubectl expose rs <ReplicaSet-Name>  --type=NodePort --port=80 --target-port=8080 --name=<Service-Name-To-Be-Created>
kubectl expose rs my-helloworld-rs  --type=NodePort --port=80 --target-port=8080 --name=my-helloworld-rs-service

# Obter informações do Service
kubectl get service
kubectl get svc

# Obter IP público dos nós de trabalho
kubectl get nodes -o wide
```- **Access the Application using Public IP**
```
http://<node1-public-ip>:<Node-Port>/hello
```

## Passo-04: Testar Confiabilidade ou Alta Disponibilidade do ReplicaSet
- Teste como o conceito de alta disponibilidade ou confiabilidade é alcançado automaticamente no Kubernetes
- Sempre que um POD é terminado acidentalmente por algum problema, o ReplicaSet deve recriar esse Pod para manter o número desejado de réplicas e garantir alta disponibilidade.
```
# Para obter o nome do Pod
kubectl get pods

# Excluir o Pod
kubectl delete pod <Pod-Name>

# Verifique se o novo pod foi criado automaticamente
kubectl get pods   (Verify Age and name of new pod)
``` 

## Passo-05: Testar o recurso de escalabilidade do ReplicaSet
- Teste como a escalabilidade é rápida e simples
- Atualize o campo **replicas** em **replicaset-demo.yml** de 3 para 6.
```
# Antes da alteração
spec:
  replicas: 3

# Depois da alteração
spec:
  replicas: 6
```
- Update the ReplicaSet
```
# Aplicar as últimas alterações ao ReplicaSet
kubectl replace -f replicaset-demo.yml

# Verifique se novos pods foram criados
kubectl get pods -o wide
```

## Step-06: Delete ReplicaSet & Service
### Delete ReplicaSet
```
# Excluir ReplicaSet
kubectl delete rs <ReplicaSet-Name>

# Comandos de exemplo
kubectl delete rs/my-helloworld-rs
[or]
kubectl delete rs my-helloworld-rs

# Verifique se o ReplicaSet foi excluído
kubectl get rs
```

### Delete Service created for ReplicaSet
```
# Excluir Service
kubectl delete svc <service-name>

# Comandos de exemplo
kubectl delete svc my-helloworld-rs-service
[or]
kubectl delete svc/my-helloworld-rs-service

# Verifique se o Service foi excluído
kubectl get svc
```

## Conceito pendente em ReplicaSet
- Não discutimos sobre **Labels & Selectors**
- Esse conceito será entendido em detalhes quando aprendermos a escrever manifestos YAML do Kubernetes.
- Vamos entender isso melhor na seção **ReplicaSets-YAML**.

