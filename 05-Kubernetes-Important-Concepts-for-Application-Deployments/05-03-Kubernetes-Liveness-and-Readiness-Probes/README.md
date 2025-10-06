# Kubernetes - Liveness & Readiness Probes

## Passo-01: Introdução
- **Liveness Probe:** Verifica se o container está **vivo** e funcionando
- **Readiness Probe:** Verifica se o container está **pronto** para receber tráfego
- **Startup Probe:** Verifica se o container **iniciou** com sucesso (Kubernetes 1.16+)

### Diferenças Importantes:
- **Liveness Probe:** Se falhar, o container é **reiniciado**
- **Readiness Probe:** Se falhar, o container é **removido** do Service
- **Startup Probe:** Se falhar, o container é **reiniciado** (como Liveness)

## Passo-02: Criar Liveness Probe com Comando
```yml
containers:
- name: usermgmt-restapp
  image: 
  ports:
  - containerPort: <PORT>
  livenessProbe:
    exec:
      command:
        - /bin/sh
        - -c
        - nc -z localhost <PORT>
    initialDelaySeconds: 60
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 3
```

## Passo-03: Criar Readiness Probe com HTTP GET
```yml
containers:
- name: usermgmt-restapp
  image: 
  ports:
  - containerPort: <PORT>
  readinessProbe:
    httpGet:
      path: health
      port: <PORT>
    initialDelaySeconds: 30
    periodSeconds: 5
    timeoutSeconds: 3
    failureThreshold: 3
```

## Passo-04: Configuração Completa com Ambos os Probes
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
      initContainers:
       - name: init-db
         image: busybox:1.31
         command: ['sh', '-c', 'echo -e "Checking for the availability of MySQL Server deployment"; while ! nc -z mysql 3306; do sleep 1; printf "-"; done; echo -e "  >> MySQL DB Server has started";']      
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
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
```

## Passo-05: Deploy e Teste
```bash
# Aplicar Deployment com Probes
kubectl apply -f kube-manifests/06-UserManagementMicroservice-Deployment-Service.yml

# Verificar Pods
kubectl get pods

# Verificar status dos Probes
kubectl describe pod <pod-name>

# Ver logs da aplicação
kubectl logs <pod-name>
```

## Passo-06: Verificar Funcionamento dos Probes
```bash
# Ver status detalhado do Pod
kubectl describe pod <pod-name>

# Verificar se o Pod está pronto
kubectl get pods -o wide

# Verificar endpoints do Service
kubectl get endpoints

# Testar aplicação
curl http://<NODE_IP>:<NODE_PORT>/usermgmt/health-status
```

## Passo-07: Simular Falha e Recuperação
### Simular falha do Liveness Probe
```bash
# Executar comando dentro do container para simular falha
kubectl exec -it <pod-name> -- /bin/sh

# Dentro do container, parar a aplicação
pkill -f java

# Sair do container e verificar se foi reiniciado
exit
kubectl get pods
```

### Simular falha do Readiness Probe
```bash
# Verificar se o Pod foi removido do Service
kubectl get endpoints

# Ver logs para entender o que aconteceu
kubectl logs <pod-name>
```

## Passo-08: Tipos de Probes
### 1. HTTP GET Probe
```yml
livenessProbe:
  httpGet:
    path: /health
    port: <PORT>
  initialDelaySeconds: 30
  periodSeconds: 10
    httpHeaders:
    - name: Custom-Header
      value: "value"
```

### 2. TCP Socket Probe
```yml
livenessProbe:
  tcpSocket:
    port: <PORT>
```

### 3. Exec Command Probe
```yml
livenessProbe:
  exec:
    command:
    - /bin/sh
    - -c
    - "ps aux | grep java"
```

## Passo-09: Parâmetros de Configuração
- **initialDelaySeconds:** Tempo antes do primeiro probe (padrão: 0)
- **periodSeconds:** Intervalo entre probes (padrão: 10)
- **timeoutSeconds:** Timeout para cada probe (padrão: 1)
- **successThreshold:** Tentativas de sucesso necessárias (padrão: 1)
- **failureThreshold:** Tentativas de falha antes de considerar não saudável (padrão: 3)

## Passo-10: Boas Práticas
1. **Configure endpoints específicos** para health checks
2. **Use timeouts apropriados** para evitar falsos positivos
3. **Configure initialDelaySeconds** para dar tempo da aplicação inicializar
4. **Monitore logs** para entender falhas
5. **Teste probes** em ambiente de desenvolvimento

## Passo-11: Troubleshooting
```bash
# Ver eventos do cluster
kubectl get events --sort-by=.metadata.creationTimestamp

# Ver logs detalhados
kubectl logs <pod-name> --previous

# Verificar configuração do Pod
kubectl get pod <pod-name> -o yaml

# Verificar status dos containers
kubectl describe pod <pod-name>
```

## Passo-12: Limpeza
```bash
# Deletar todos os recursos
kubectl delete -f kube-manifests/

# Verificar limpeza
kubectl get all
```

## 📚 Recursos Adicionais
- [Kubernetes Probes Documentation](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
- [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)