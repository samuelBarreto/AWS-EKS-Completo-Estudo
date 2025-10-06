# Kubernetes - Requests e Limits

## Passo-01: Introdução
- Podemos especificar quantos recursos cada container de um pod precisa, como CPU e Memória
- Quando fornecemos essas informações em nosso pod, o scheduler usa essas informações para decidir em qual nó colocar o Pod
- Quando você especifica um limite de recurso para um Container, o kubelet aplica esses `limits` para que o container em execução não possa usar mais desse recurso do que o limite que você definiu
- O kubelet também reserva pelo menos a quantidade `request` desse recurso do sistema especificamente para esse container usar

## Passo-02: Adicionar Requests & Limits
```yml
containers:
- name: usermgmt-restapp
  image: 
  ports:
  - containerPort: 8095
  resources:
    requests:
      memory: "128Mi" # 128 MebiByte é igual a 135 Megabyte (MB)
      cpu: "500m"     # `m` significa milliCPU
    limits:
      memory: "500Mi"
      cpu: "1000m"    # 1000m é igual a 1 núcleo VCPU
```

## Passo-03: Configuração Completa com Resources
```yml
apiVersion: apps/v1
kind: Deployment 
metadata:
  name: usermgmt-microservice
  labels:
    app: usermgmt-restapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: usermgmt-restapp
  template:  
    metadata:
      labels: 
        app: usermgmt-restapp
    spec:   
      containers:
        - name: usermgmt-restapp
          image: 1234samue/aula:user-management-api-1.0.0
          ports: 
            - containerPort: 3000
              name: http
          env:
            - name: DB_HOST
              value: "mysql"            
            - name: DB_PORT
              value: "3306"            
            - name: DB_NAME
              value: "usermgmt"            
            - name: DB_USER
              value: "root"            
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-db-password
                  key: db-password
            - name: PORT
              value: "3000"
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "256Mi"
              cpu: "200m"
```

## Passo-04: Deploy e Teste
```bash
# Aplicar Deployment com Resources
kubectl apply -f kube-manifests/app

# Verificar Pods
kubectl get pods

# Verificar recursos dos Pods
kubectl top pods

# Ver detalhes dos recursos
kubectl describe pod <pod-name>
```

## Passo-05: Verificar Uso de Recursos
```bash
# Ver uso de CPU e Memória dos Pods
kubectl top pods

# Ver uso de recursos por container
kubectl top pods --containers

# Ver uso de recursos dos nós
kubectl top nodes

# Ver detalhes de recursos de um Pod específico
kubectl describe pod <pod-name>
```

## Passo-06: Entender QoS Classes
### Guaranteed (Garantida)
```yml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "128Mi"  # Mesmo valor que requests
    cpu: "100m"      # Mesmo valor que requests
```

### Burstable (Explosiva)
```yml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"  # Maior que requests
    cpu: "200m"      # Maior que requests
```

### BestEffort (Melhor Esforço)
```yml
# Sem especificação de resources
containers:
- name: app
  image: nginx
  # Sem seção resources
```

## Passo-07: Monitoramento de Recursos
```bash
# Verificar QoS Class dos Pods
kubectl get pods -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass

# Ver eventos relacionados a recursos
kubectl get events --field-selector reason=FailedScheduling

# Ver métricas detalhadas (se metrics-server estiver instalado)
kubectl top pods --sort-by=cpu
kubectl top pods --sort-by=memory
```

## Passo-08: Troubleshooting de Recursos
### Pod não consegue ser agendado
```bash
# Verificar eventos
kubectl get events --sort-by=.metadata.creationTimestamp

# Verificar recursos disponíveis no nó
kubectl describe node <node-name>

# Verificar se há recursos suficientes
kubectl top nodes
```

### Container sendo morto por OOMKilled
```bash
# Verificar logs do container
kubectl logs <pod-name> --previous

# Verificar se o limite de memória está muito baixo
kubectl describe pod <pod-name>
```

## Passo-09: Exemplos de Configuração
### Aplicação Leve (Nginx)
```yml
resources:
  requests:
    memory: "64Mi"
    cpu: "50m"
  limits:
    memory: "128Mi"
    cpu: "100m"
```

### Aplicação Média (API Node.js)
```yml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

### Aplicação Pesada (Java Spring Boot)
```yml
resources:
  requests:
    memory: "512Mi"
    cpu: "500m"
  limits:
    memory: "1Gi"
    cpu: "1000m"
```

## Passo-10: Boas Práticas
1. **Sempre defina requests** para permitir agendamento adequado
2. **Configure limits** para evitar que um container consuma todos os recursos
3. **Monitore uso real** e ajuste conforme necessário
4. **Use ferramentas de profiling** para entender o uso de recursos
5. **Teste com carga** para validar configurações

## Passo-11: Comandos Úteis
```bash
# Ver recursos de todos os Pods
kubectl get pods -o custom-columns=NAME:.metadata.name,CPU-REQ:.spec.containers[*].resources.requests.cpu,MEM-REQ:.spec.containers[*].resources.requests.memory

# Ver recursos de um Deployment
kubectl get deployment <deployment-name> -o yaml | grep -A 10 resources

# Ver uso de recursos em tempo real
watch kubectl top pods
```

## Passo-12: Limpeza
```bash
# Deletar todos os recursos
kubectl delete -f kube-manifests/

# Verificar limpeza
kubectl get all
```

## 📚 Recursos Adicionais
- [Kubernetes Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [Limit Ranges](https://kubernetes.io/docs/concepts/policy/limit-range/)