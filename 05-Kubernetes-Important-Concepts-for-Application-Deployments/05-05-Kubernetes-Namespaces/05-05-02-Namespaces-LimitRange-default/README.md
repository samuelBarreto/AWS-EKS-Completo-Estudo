# Namespaces do Kubernetes - LimitRange - Declarativo usando YAML
## Passo-01: Criar o manifest do Namespace
- Observação importante: o nome do arquivo deve começar com `00-` para que, ao criar os objetos do Kubernetes, o namespace seja criado primeiro e não ocorra erro.
```yml
apiVersion: v1
kind: Namespace
metadata:
  name: dev3
```

## Passo-02: Criar o manifest de LimitRange
- Em vez de especificar `recursos como CPU e memória` em cada container de um Pod, podemos definir CPU e Memória padrão para todos os containers de um namespace usando `LimitRange`.
```yml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ns-resource-quota
  namespace: dev3
spec:
  limits:
    - default:
        memory: "512Mi" # If not specified the Container's memory limit is set to 512Mi, which is the default memory limit for the namespace.
        cpu: "500m"  # If not specified default limit is 1 vCPU per container 
      defaultRequest:
        memory: "256Mi" # If not specified default it will take from whatever specified in limits.default.memory
        cpu: "300m" # If not specified default it will take from whatever specified in limits.default.cpu
      type: Container                        
```

## Passo-03: Atualizar todos os manifests com o namespace
- Atualize todos os arquivos do diretório indicado, adicionando `namespace: dev3` no topo da seção `metadata`.
- Exemplo
```yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-mysql-pv-claim
  namespace: dev3
```

## Passo-04: Criar os objetos no Kubernetes e testar
```
# Criar todos os objetos
kubectl apply -f kube-manifests/k8s
kubectl apply -f kube-manifests/mysql
kubectl apply -f kube-manifests/jobs
kubectl apply -f kube-manifests/app


# Listar Pods
kubectl get pods -n dev3 -w

# Ver especificação do Pod (CPU & Memória)
kubectl get pod <pod-name> -o yaml -n dev3

# Obter e descrever Limits
kubectl get limits -n dev3
kubectl describe limits default-cpu-mem-limit-range -n dev3

# Obter NodePort
kubectl get svc -n dev3

# Obter IP público de um Worker Node
kubectl get nodes -o wide

# Acessar a página de status (health) da aplicação
http://<WorkerNode-Public-IP>:<NodePort>/usermgmt/health-status

```
## Passo-05: Limpeza
- Excluir todos os objetos criados nesta seção
```
# Deletar tudo
kubectl delete -f kube-manifests/
```

## Referências:
- https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
