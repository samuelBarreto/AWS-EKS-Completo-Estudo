
# ReplicaSets com YAML

## Passo-01: Criar definição de ReplicaSet
- **replicaset-definition.yml**
```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp2-rs
spec:
  replicas: 3 # Devem existir sempre 3 Pods.
  selector:  # O label dos Pods deve ser definido no selector do ReplicaSet
    matchLabels:
      app: myapp2
  template:
    metadata:
      name: myapp2-pod
      labels:
        app: myapp2 # Pelo menos 1 label do Pod deve coincidir com o selector do ReplicaSet
    spec:
      containers:
      - name: myapp2
        image: aula/kubenginx:2.0.0
        ports:
          - containerPort: 80
```
## Passo-02: Criar ReplicaSet
- Criar ReplicaSet com 3 réplicas
```
# Criar ReplicaSet
kubectl apply -f 02-replicaset-definition.yml

# Listar ReplicaSets
kubectl get rs
```
- Excluir um pod
- O ReplicaSet imediatamente recria o pod.
```
# Listar Pods
kubectl get pods

# Excluir Pod
kubectl delete pod <Nome-do-Pod>
```

## Passo-03: Criar Service NodePort para ReplicaSet
```yml
apiVersion: v1
kind: Service
metadata:
  name: replicaset-nodeport-service
spec:
  type: NodePort
  selector:
    app: myapp2
  ports:
    - name: http
      port: 80
      targetPort: 80
      nodePort: 31232  
```
- Criar Service NodePort para ReplicaSet e testar
```
# Criar Service NodePort
kubectl apply -f 03-replicaset-nodeport-servie.yml

# Listar Service NodePort
kubectl get svc

# Obter IP público
kubectl get nodes -o wide

# Acessar aplicação
http://<IP-Público-do-Worker-Node>:<NodePort>
http://<IP-Público-do-Worker-Node>:31232

```

## Referências da API
- **ReplicaSet:** https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#replicaset-v1-apps