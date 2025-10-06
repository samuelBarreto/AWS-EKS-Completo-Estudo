# Kubernetes - Init Containers

## Passo-01: Introdução
- Init Containers executam **antes** dos containers da aplicação
- Init containers podem conter **utilitários ou scripts de configuração** não presentes na imagem da aplicação
- Podemos ter e executar **múltiplos Init Containers** antes do Container da aplicação
- Init containers são exatamente como containers regulares, **exceto:**
  - Init containers sempre **executam até a conclusão**
  - Cada init container deve **completar com sucesso** antes do próximo iniciar
- Se um init container de um Pod falhar, o Kubernetes reinicia repetidamente o Pod até o init container ter sucesso
- No entanto, se o Pod tiver `restartPolicy of Never`, o Kubernetes não reinicia o Pod

## Passo-02: Implementar Init Containers
- Atualizar a seção `initContainers` sob o Pod Template Spec que é `spec.template.spec` em um Deployment
```yml
  template:
    metadata:
      labels:
        app: usermgmt-restapp
    spec:
      initContainers:
      - name: init-myservice
        image: busybox:1.35
        command: ['sh', '-c']
        args:
          - |
            echo "Aguardando MySQL estar pronto..."
            until nc -z mysql 3306; do
              echo "MySQL não está pronto ainda, aguardando..."
              sleep 2
            done
            echo "MySQL está pronto!"
      containers:
      - name: usermgmt-restapp
        image: stacksimplify/kube-usermanagement-microservice:1.0.0
        ports:
        - containerPort: 8095
        env:
        - name: DB_HOSTNAME
          value: "mysql"
        - name: DB_PORT
          value: "3306"
        - name: DB_NAME
          value: "usermgmt"
        - name: DB_USERNAME
          value: "root"
        - name: DB_PASSWORD
          value: "dbpassword11"
```

## Passo-03: Deploy com Init Container
```bash
# Aplicar Deployment com Init Container
kubectl apply -f kube-manifests/app

# Verificar Pods
kubectl get pods

# Ver logs do Init Container
kubectl logs <pod-name> -c init-myservice

kubectl logs  usermgmt-microservice-84d6966c44-jfx6d -c init-myservice
Aguardando MySQL estar pronto...
MySQL está pronto!

# Ver logs da aplicação
kubectl logs <pod-name> -c usermgmt-restapp

kubectl logs  usermgmt-microservice-84d6966c44-jfx6d -c usermgmt-restapp
✅ Database connected successfully
❌ Database initialization failed: This command is not supported in the prepared statement protocol yet
🚀 User Management API running on port 3000
📊 Health check: http://localhost:3000/health
👥 Users endpoint: http://localhost:3000/users
```

## Passo-04: Verificar Ordem de Execução
```bash
# Descrever Pod para ver status dos containers
kubectl describe pod <pod-name>

# Ver eventos do Pod
kubectl get events --sort-by=.metadata.creationTimestamp

# Ver logs de todos os containers
kubectl logs <pod-name> --all-containers=true
```

## Passo-05: Múltiplos Init Containers (teste)
### Exemplo com múltiplos Init Containers
```yml
spec:
  template:
    spec:
      initContainers:
      - name: init-database
        image: mysql:5.6
        command: ['sh', '-c']
        args:
          - |
            echo "Configurando banco de dados..."
            mysql -h mysql -u root -pdbpassword11 -e "CREATE DATABASE IF NOT EXISTS usermgmt;"
      - name: init-wait-mysql
        image: busybox:1.35
        command: ['sh', '-c']
        args:
          - |
            echo "Aguardando MySQL estar pronto..."
            until nc -z mysql 3306; do
              echo "MySQL não está pronto ainda, aguardando..."
              sleep 2
            done
            echo "MySQL está pronto!"
      containers:
      - name: usermgmt-restapp
        image: stacksimplify/kube-usermanagement-microservice:1.0.0
        # ... resto da configuração
```

## Passo-06: Casos de Uso Comuns
1. **Aguardar Dependências:** Esperar que serviços externos estejam prontos
2. **Configuração de Banco:** Criar tabelas ou executar migrações
3. **Download de Dados:** Baixar arquivos de configuração ou dados
4. **Configuração de Rede:** Configurar regras de firewall ou proxy
5. **Validação de Ambiente:** Verificar se o ambiente está correto

## Passo-07: Troubleshooting
```bash
# Ver status detalhado do Pod
kubectl describe pod <pod-name>

# Ver logs de um Init Container específico
kubectl logs <pod-name> -c init-myservice

# Ver logs de todos os Init Containers
kubectl logs <pod-name> --all-containers=true

# Ver eventos do cluster
kubectl get events --field-selector involvedObject.name=<pod-name>
```

## Passo-08: Boas Práticas
1. **Use imagens leves** para Init Containers (busybox, alpine)
2. **Defina timeouts** apropriados para evitar loops infinitos
3. **Monitore logs** dos Init Containers
4. **Teste isoladamente** cada Init Container
5. **Use volumes compartilhados** quando necessário

## Passo-09: Limpeza
```bash
# Deletar todos os recursos
kubectl delete -f kube-manifests/

# Verificar limpeza
kubectl get all
```

## 📚 Recursos Adicionais
- [Kubernetes Init Containers Documentation](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- [Init Containers Best Practices](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#init-containers-in-use)