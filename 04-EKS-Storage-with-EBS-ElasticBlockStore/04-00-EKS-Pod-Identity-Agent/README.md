
# Amazon EKS Pod Identity Agent - Demonstração

## Amazon EKS Pod Identity – Fluxo de Alto Nível
O Amazon EKS Pod Identity permite que pods no seu cluster assumam funções IAM de forma segura, sem gerenciar credenciais estáticas ou usar anotações IRSA. O fluxo de alto nível está ilustrado abaixo:

![Componentes do EKS Pod Identity](images/04-00-PIA.png)

![Fluxo do EKS Pod Identity](images/Pod-Identity-Worklow.jpg)

1. **Criar Role IAM**  
   Um administrador IAM cria uma role que pode ser assumida pelo novo principal de serviço do EKS:  
   `pods.eks.amazonaws.com`.  
   - A política de confiança pode ser restrita pelo ARN do cluster ou conta AWS.  
   - Anexe as políticas IAM necessárias (ex: AmazonS3ReadOnlyAccess).  

2. **Criar Associação de Pod Identity**  
   O administrador do EKS associa a Role IAM a uma Service Account + Namespace do Kubernetes.  
   - Feito via Console EKS ou API `CreatePodIdentityAssociation`.  

3. **Mutação via Webhook**  
   Quando um pod usando essa Service Account é criado, o **EKS Pod Identity Webhook** (executando no plano de controle) altera o spec do pod:  
   - Injeta variáveis de ambiente como `AWS_CONTAINER_CREDENTIALS_FULL_URI`.  
   - Monta um token de service account projetado para uso pelo Pod Identity Agent.  

**Exemplo de verificação da mutação:**    
```bash
kubectl exec -it aws-cli -- env | grep AWS_CONTAINER
AWS_CONTAINER_CREDENTIALS_FULL_URI=http://169.254.170.23/v1/credentials
AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE=/var/run/secrets/pods.eks.amazonaws.com/serviceaccount/eks-pod-identity-token
```


4. **Pod solicita credenciais**
   Dentro do pod, o AWS SDK/CLI usa a cadeia de provedores de credenciais padrão.

   * Ele descobre as variáveis de ambiente injetadas e chama o **EKS Pod Identity Agent** executando como DaemonSet no nó worker.

   **4a. PIA Agent chama a API de autenticação do EKS**

   * O Pod Identity Agent troca o token projetado com a **API Auth do EKS** usando `AssumeRoleForPodIdentity`.

   **4b. API Auth do EKS valida a associação**

   * A API verifica a associação de Pod Identity (Namespace + ServiceAccount → Role IAM).
   * Se válido, retorna credenciais IAM temporárias para o Pod Identity Agent.

5. **Pod acessa recursos AWS**
   O AWS SDK/CLI dentro do pod agora possui credenciais válidas e temporárias, podendo chamar serviços AWS (ex: listar buckets S3).
   

---

### Pontos-chave
* Pods recebem **credenciais IAM temporárias** automaticamente — não é necessário `aws configure`.
* Utiliza a **cadeia padrão de credenciais do AWS SDK** (sem necessidade de alterar código).
* Requer o **Add-on EKS Pod Identity Agent** rodando nos nós worker.
* Suportado apenas em versões mais recentes do AWS SDK e CLI.

### Referências adicionais
* [Amazon EKS Pod Identity Blog Post](https://aws.amazon.com/blogs/containers/amazon-eks-pod-identity-a-new-way-for-applications-on-eks-to-obtain-iam-credentials/)

---

## Passo-00: O que vamos fazer
Neste demo, vamos entender e implementar o **Amazon EKS Pod Identity Agent (PIA)**.

1. Instalar o add-on **EKS Pod Identity Agent**  
2. Criar um **Pod AWS CLI Kubernetes** no cluster EKS e tentar listar buckets S3 (isso irá falhar inicialmente)  
3. Criar uma **Role IAM** com política de confiança para Pod Identity → permitir que Pods acessem o **Amazon S3**  
4. Criar uma **Associação de Pod Identity** entre a Service Account do Kubernetes e a Role IAM  
5. Testar novamente no Pod AWS CLI, listar buckets S3 com sucesso  
6. Com esse fluxo, vamos entender claramente como o **Pod Identity Agent** funciona no EKS  

---

## Passo-01: Instalar o EKS Pod Identity Agent
1. Abra o **Console EKS** → **Clusters** → selecione seu cluster (`eksdemo1`)  
2. Vá em **Add-ons** → **Get more add-ons**  
3. Procure por **EKS Pod Identity Agent**  
4. Clique em **Next** → **Create**  

Isso instala um **DaemonSet** (`eks-pod-identity-agent`) que habilita associações de Pod Identity.

```yaml
# Listar recursos PIA no k8s
kubectl get daemonset -n kube-system

# Listar pods no k8s
kubectl get pods -n kube-system
```

---

## Passo-02: Deploy do Pod AWS CLI (sem associação de Pod Identity)
### Passo-02-01: Criar Service Account 
- ![01_k8s_service_account.yaml](kube-manifests/01_k8s_service_account.yaml)
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-cli-sa
  namespace: default
```

### Passo-02-02: Criar um Pod Kubernetes simples com imagem AWS CLI:
- ![02_k8s_aws_cli_pod.yaml](kube-manifests/02_k8s_aws_cli_pod.yaml)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: aws-cli
  namespace: default
spec:
  serviceAccountName: aws-cli-sa
  containers:
  - name: aws-cli
    image: amazon/aws-cli
    command: ["sleep", "infinity"]
```

### Passo-02-03: Deploy do Pod CLI
```bash
kubectl apply -f kube-manifests/
kubectl get pods
```

### Passo-02-04: Executar no pod e tentar listar buckets S3:
```bash
kubectl exec -it aws-cli -- aws s3 ls
```

**Observação:** ❌ Isso deve **falhar** pois o Pod não possui permissões IAM associadas.  

#### Mensagem de erro
```
kalyan-mini2:04-00-EKS-Pod-Identity-Agent kalyan$ kubectl exec -it aws-cli -- aws s3 ls

An error occurred (AccessDenied) when calling the ListBuckets operation: User: arn:aws:sts::180789647333:assumed-role/eksctl-eksdemo1-nodegroup-eksdemo1-NodeInstanceRole-kxEPBrWVcOzO/i-0d65729d6d09d2540 is not authorized to perform: s3:ListAllMyBuckets because no identity-based policy allows the s3:ListAllMyBuckets action
command terminated with exit code 254
```

**Nota importante:** Veja como o erro faz referência ao **EC2 NodeInstanceRole** — isso prova que o Pod não tinha mapeamento IAM direto.

---

## Passo-03: Criar Role IAM para Pod Identity
1. Vá ao **Console IAM** → **Roles** → **Create Role**  
2. Selecione **Trusted entity type** → **Custom trust policy**  
3. Adicione a política de confiança para Pod Identity, por exemplo:  

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "pods.eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
}
```

4. Anexe a política **AmazonS3ReadOnlyAccess**  
5. Crie a role → exemplo de nome: `EKS-PodIdentity-S3-ReadOnly-Role-101`  

---

## Passo-04: Criar Associação de Pod Identity
* Vá ao **Console EKS** → Cluster → **Access** → **Pod Identity Associations**  
* Crie nova associação:  

  * Namespace: `default`  
  * Service Account: `aws-cli-sa`  
  * Role IAM: `EKS-PodIdentity-S3-ReadOnly-Role-101`  
  * Clique em **create**  

---

## Passo-05: Testar novamente

> Os pods não atualizam automaticamente as credenciais após uma nova associação de Pod Identity; é necessário reiniciá-los.

1. Reiniciar o Pod
```bash
# Excluir Pod
kubectl delete pod aws-cli -n default

# Criar Pod
kubectl apply -f kube-manifests/02_k8s_aws_cli_pod.yaml

# Listar Pods
kubectl get pods
```

2. Executar no Pod:
```bash
# Listar buckets S3
kubectl exec -it aws-cli -- aws s3 ls
```

**Observação:** Desta vez deve **funcionar**, listando todos os buckets S3.

---

## Passo-06: Limpeza

```bash
# 1. Excluir o pod aws-cli
kubectl delete -f kube-manifests/
```

- **Remover Associação de Pod Identity** → via **Console EKS → Access → Pod Identity Associations**  
- **Remover Role IAM** → via **Console IAM → Roles** `EKS-PodIdentity-S3-ReadOnly-Role-101`

---

## Passo-07: Recapitulando o conceito

* **Sem associação de Pod Identity:** O pod não possui permissões IAM → chamadas à API AWS falham  
* **Com associação de Pod Identity:** O Pod Identity Agent mapeia a Service Account do Pod → Role IAM → Permissões AWS → chamadas à API funcionam  

---



