
# PODs com YAML
## Passo-01: Objetos de topo do YAML do Kubernetes
- Discutir sobre os objetos de topo do YAML do k8s
- **01-kube-base-definition.yml**
```yml
apiVersion:
kind:
metadata:
  
spec:
```
-  **Referência de Objetos da API Pod:**  https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#pod-v1-core

## Passo-02: Criar definição simples de Pod usando YAML 
- Vamos criar uma definição de pod bem básica
- **02-pod-definition.yml**
```yml
apiVersion: v1 # String
kind: Pod  # String
metadata: # Dicionário
  name: myapp-pod
  labels: # Dicionário 
    app: myapp         
spec:
  containers: # Lista
    - name: myapp
      image: aula/kubenginx:1.0.0
      ports:
        - containerPort: 80
```
- **Criar Pod**
```
# Criar Pod
kubectl create -f 02-pod-definition.yml
[ou]
kubectl apply -f 02-pod-definition.yml

# Listar Pods
kubectl get pods
```

## Passo-03: Criar um Service NodePort
- **03-pod-nodeport-service.yml**
```yml
apiVersion: v1
kind: Service
metadata:
  name: myapp-pod-nodeport-service  # Nome do Service
spec:
  type: NodePort
  selector:
  # Balancear tráfego entre Pods que correspondem a este label selector
    app: myapp
  # Aceitar tráfego enviado para a porta 80    
  ports: 
    - name: http
      port: 80    # Porta do Service
      targetPort: 80 # Porta do Container
      nodePort: 31231 # NodePort
```
- **Criar Service NodePort para o Pod**
```
# Criar Service
kubectl apply -f 03-pod-nodeport-service.yml

# Listar Services
kubectl get svc

# Obter IP público
kubectl get nodes -o wide

# Acessar aplicação
http://<WorkerNode-Public-IP>:<NodePort>
http://<WorkerNode-Public-IP>:31231
```

## Referências de Objetos da API
-  **Pod**: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#pod-v1-core
- **Service**: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#service-v1-core

## Referências atualizadas de Objetos da API
-  **Pod**: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/
-  **Service**: https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/
- **Referência da API Kubernetes:** https://kubernetes.io/docs/reference/kubernetes-api/

