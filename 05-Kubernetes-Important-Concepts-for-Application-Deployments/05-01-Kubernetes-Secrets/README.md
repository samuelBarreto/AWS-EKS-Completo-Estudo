# Kubernetes - Secrets

## Passo-00: Abrir regra Inbound no Security Group (NodePort / All TCP)
- Substitua `SG_ID` pelo ID do Security Group dos nós do seu EKS.

- Obter seu IP público atual:
  - Windows PowerShell:
    ```powershell
    $IP = (Invoke-RestMethod ifconfig.me/ip)
    ```
  - Linux/macOS:
    ```bash
    IP=$(curl -s ifconfig.me)
    # ou
    IP=$(curl -s https://checkip.amazonaws.com)
    ```

- Abrir SOMENTE a porta do NodePort (ex.: 30090) para seu IP:
```bash
aws ec2 authorize-security-group-ingress --group-id SG_ID \
  --ip-permissions IpProtocol=tcp,FromPort=30090,ToPort=30090,IpRanges="[{CidrIp=${IP:-YOUR_IP}/32,Description=NodePort 30090}]"
```

- Abrir SOMENTE a porta do NodePort para todos (apenas teste):
```bash
aws ec2 authorize-security-group-ingress --group-id SG_ID \
  --ip-permissions IpProtocol=tcp,FromPort=30090,ToPort=30090,IpRanges='[{CidrIp=0.0.0.0/0,Description=NodePort 30090}]'
```

- Abrir TODAS as portas TCP para seu IP (temporário):
```bash
aws ec2 authorize-security-group-ingress --group-id SG_ID \
  --ip-permissions IpProtocol=tcp,FromPort=0,ToPort=65535,IpRanges="[{CidrIp=${IP:-YOUR_IP}/32,Description=All TCP (temp)}]"
```

- Abrir TODAS as portas TCP para todos (não recomendado, apenas teste rápido):
```bash
aws ec2 authorize-security-group-ingress --group-id SG_ID \
  --ip-permissions IpProtocol=tcp,FromPort=0,ToPort=65535,IpRanges='[{CidrIp=0.0.0.0/0,Description=All TCP (temp)}]'
```

Verificar regras:
```bash
aws ec2 describe-security-groups --group-ids SG_ID --query 'SecurityGroups[0].IpPermissions'
```

## Passo-01: Introdução
- Os Kubernetes Secrets permitem armazenar e gerenciar informações sensíveis, como senhas, tokens OAuth e chaves SSH.
- Armazenar informações confidenciais em um Secret é mais seguro e flexível do que colocá-las diretamente na definição de um Pod ou na imagem do container.

## Passo-02: Criar Secret para Senha do MySQL DB
### Codificar a senha em Base64
```bash
# Mac/Linux
echo -n 'dbpassword11' | base64

# Windows PowerShell
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('dbpassword11'))

# URL: https://www.base64encode.org
```

### Criar manifest do Kubernetes Secret
```yml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-password
type: Opaque
data:
  db-password: ZGJwYXNzd29yZDEx
```

## Passo-03: Deploy do Secret
```bash
# Aplicar o mysql
kubectl apply -f kube-manifests/mysql

# Verificar Secrets
kubectl get secrets

# Verificar deploy
kubectl get deploy

# Descrever Secret
kubectl describe secret mysql-db-password

# Ver dados do Secret (decodificado)
kubectl get secret mysql-db-password -o yaml

# deploy de4 jobs
kubectl apply -f kube-manifests/jobs

 kubectl logs job/mysql-table-setup-advanced -n default

 kubectl logs job/mysql-sample-data -n default

kubectl get svc mysql

kubectl get endpoints mysql

kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -u root -pdbpassword11

# Dentro do MySQL, executar:
USE usermgmt;
SELECT * FROM users;

# Verificar se o schema usermanagement foi criado
mysql> show schemas;
mysql> use usermanagement;
mysql> show tables;
mysql> describe users;
mysql> select * from users;

```


## Passo-04: Usar Secret no Deployment
### Atualizar Deployment para usar Secret
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
```

## Passo-05: Deploy e Teste
```bash
# Aplicar Deployment atualizado
kubectl apply -f kube-manifests/app

# Verificar Pods
kubectl get pods

# Verificar logs
kubectl logs -l app=usermgmt-restapp


# Testar aplicação
kubectl get svc
<NODE_PORT>

kubectl get nodes -o wide
<NODE_IP>

curl http://<NODE_IP>:<NODE_PORT>/health
```

## Passo-06: Verificar Secret em Uso
```bash
# Ver variáveis de ambiente do Pod
kubectl exec -it <pod-name> -- env | grep DB_PASSWORD

# Verificar se a aplicação está funcionando
kubectl logs <pod-name>
```

## Passo-07: Gerenciamento de Secrets
### Atualizar Secret
```bash
# Editar Secret
kubectl edit secret mysql-db-password

# Ou aplicar novo Secret
kubectl apply -f kube-manifests/08-Kubernetes-Secrets.yml
```

### Deletar Secret
```bash
# Deletar Secret
kubectl delete secret mysql-db-password

# Verificar se foi removido
kubectl get secrets
```

## Passo-08: Boas Práticas
1. **Nunca** commite Secrets no controle de versão
2. Use **RBAC** para controlar acesso aos Secrets
3. **Rotacione** Secrets regularmente
4. Use **External Secret Operators** para integração com vaults
5. **Monitore** acesso aos Secrets

## Passo-09: Limpeza
```bash
# Deletar todos os recursos
kubectl delete -f kube-manifests/

# Verificar limpeza
kubectl get all
kubectl get secrets
```

## 📚 Recursos Adicionais
- [Kubernetes Secrets Documentation](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Secret Management Best Practices](https://kubernetes.io/docs/concepts/security/secrets/)
- [External Secrets Operator](https://external-secrets.io/)