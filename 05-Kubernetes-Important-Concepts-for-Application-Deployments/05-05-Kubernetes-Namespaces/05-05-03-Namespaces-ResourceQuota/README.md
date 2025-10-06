# Namespaces do Kubernetes - ResourceQuota - Declarativo usando YAML

## Passo-01: Criar o manifest do Namespace
- Observação importante: o nome do arquivo deve começar com `00-` para que, ao criar os objetos do Kubernetes, o namespace seja criado primeiro e não ocorra erro.
```yml
apiVersion: v1
kind: Namespace
metadata:
  name: dev3
```

## Passo-02: Criar o manifest de ResourceQuota
```yml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ns-resource-quota
  namespace: dev3
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi  
    pods: "5"    
    configmaps: "5" 
    persistentvolumeclaims: "5" 
    replicationcontrollers: "5" 
    secrets: "5" 
    services: "5"                      
```

## Passo-03: Criar objetos no Kubernetes e testar
```
# Criar todos os objetos
kubectl apply -f kube-manifests/

# Listar Pods
kubectl get pods -n dev3 -w

# Ver especificação do Pod (CPU & Memória)
kubectl get pod <pod-name> -o yaml -n dev3

# Obter e descrever Limits
kubectl get limits -n dev3
kubectl describe limits default-cpu-mem-limit-range -n dev3

# Obter ResourceQuota 
kubectl get quota -n dev3
kubectl describe quota ns-resource-quota -n dev3

# Obter NodePort
kubectl get svc -n dev3

# Obter IP público de um Worker Node
kubectl get nodes -o wide

# Acessar a página de status (health) da aplicação
http://<WorkerNode-Public-IP>:<NodePort>/usermgmt/health-status

```
## Passo-04: Limpeza
- Excluir todos os objetos criados nesta seção
```
# Deletar tudo
kubectl delete -f kube-manifests/
```

## Referências:
- https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/quota-memory-cpu-namespace/

## Referências adicionais:
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-constraint-namespace/ 
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-constraint-namespace/