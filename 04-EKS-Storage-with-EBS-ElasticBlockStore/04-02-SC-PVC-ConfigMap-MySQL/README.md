# EKS Storage - Storage Classes, Persistent Volume Claims

## Passo-01: Introdução
- Vamos criar um banco de dados MySQL com armazenamento persistente usando volumes AWS EBS

O Amazon EKS Pod Identity Agent é necessário para o EBS CSI Driver funcionar corretamente no EKS!

| Objeto Kubernetes                                         | Arquivo YAML |
| --------------------------------------------------------- | -------------------------------- |
| Storage Class                                             | 01-storage-class.yml             |
| Persistent Volume Claim                                   | 02-persistent-volume-claim.yml   |
| Config Map                                                | 03-UserManagement-ConfigMap.yml  |
| Deployment, Environment Variables, Volumes, VolumeMounts  | 04-mysql-deployment.yml          |
| ClusterIP Service                                         | 05-mysql-clusterip-service.yml   |

## Passo-02: Criar os seguintes manifestos Kubernetes
### Criar manifesto Storage Class
- https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode
- **Nota Importante:** O modo `WaitForFirstConsumer` atrasará a vinculação e provisionamento do volume de um PersistentVolume até que um Pod usando o PersistentVolumeClaim seja criado. 

### Criar manifesto Persistent Volume Claims
```bash
# Criar Storage Class & PVC
kubectl apply -f kube-manifests/01-storage-class.yml
kubectl apply -f kube-manifests/02-persistent-volume-claim.yml
kubectl apply -f kube-manifests/03-UserManagement-ConfigMap.yml

# Listar Storage Classes
kubectl get sc

# Listar PVC
kubectl get pvc 

# Listar PV
kubectl get pv
```

### Criar manifesto ConfigMap
- Vamos criar um schema de banco de dados `usermgmt` durante a criação do pod mysql que utilizaremos quando implantarmos o Microserviço de Gerenciamento de Usuários. 

### Criar manifesto MySQL Deployment
- Variáveis de Ambiente
- Volumes
- Volume Mounts

### Criar manifesto MySQL ClusterIP Service
- A qualquer momento teremos apenas um pod mysql neste design, então `ClusterIP: None` usará o `Endereço IP do Pod` em vez de criar ou alocar um IP separado para o `serviço MySQL Cluster IP`.   

## Passo-03: Criar banco de dados MySQL com todos os manifestos acima
```bash
# Criar banco de dados MySQL
kubectl apply -f kube-manifests/deploy/04-mysql-deployment.yml
kubectl apply -f kube-manifests/deploy/05-mysql-clusterip-service.yml

# Listar Storage Classes
kubectl get sc

# Listar PVC
kubectl get pvc 

# Listar PV
kubectl get pv

# Listar pods
kubectl get pods 

# Listar pods baseado no nome do label
kubectl get pods -l app=mysql
```

## Passo-04: Conectar ao banco de dados MySQL
```bash
# Conectar ao banco de dados MYSQL
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11

mysql> show schemas;
+---------------------+
| Database            |
+---------------------+
| information_schema  |
| #mysql50#lost+found |
| mysql               |
| performance_schema  |
| usermgmt    <-       |
+---------------------+
5 rows in set (0.01 sec)

[ou]

# Usar cliente mysql com tag latest
kubectl run -it --rm --image=mysql:latest --restart=Never mysql-client -- mysql -h mysql -pdbpassword11

# Verificar se o schema usermgmt foi criado que fornecemos no ConfigMap
mysql> show schemas;
```

## Passo-05: Referências
- Precisamos discutir referências exclusivamente aqui. 
- Elas ajudarão você a escrever templates eficazes baseados na necessidade em seus ambientes. 
- Algumas funcionalidades ainda estão em estágio alpha hoje (Exemplo: Redimensionamento), mas uma vez que alcancem beta você pode começar a aproveitar esses templates e fazer seus testes. 
- **EBS CSI Driver:** https://github.com/kubernetes-sigs/aws-ebs-csi-driver
- **EBS CSI Driver Dynamic Provisioning:**  https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/examples/kubernetes/dynamic-provisioning
- **EBS CSI Driver - Outros Exemplos como Redimensionamento, Snapshot etc:** https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/examples/kubernetes
- **Documentação de Referência da API k8s:** https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#storageclass-v1-storage-k8s-io


