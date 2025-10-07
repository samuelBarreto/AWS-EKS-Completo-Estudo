---
title: Instalação do AWS Load Balancer Controller no AWS EKS
description: Aprenda a instalar o AWS Load Balancer Controller para implementação de Ingress no AWS EKS
---
 

## Passo-00: Introdução
1. Criar IAM Policy e anotar o Policy ARN
2. Criar IAM Role e k8s Service Account e vinculá-los
3. Instalar o AWS Load Balancer Controller usando HELM3 CLI
4. Entender o conceito de IngressClass e criar uma IngressClass padrão

## Passo-01: Pré-requisitos
### Pré-requisito-1: Utilitários de Linha de Comando eksctl & kubectl
- Deve ser a versão mais recente do eksctl

```bash
# Verificar versão do eksctl
eksctl version

# Para instalar ou atualizar eksctl
# https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

# Verificar versão do kubectl
kubectl version --short
kubectl version

# Para instalar kubectl cli
# https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
```

**Versões do Kubernetes suportadas no EKS (Outubro 2025):**
- **1.31** - Versão mais recente
- **1.30** - Muito estável e amplamente utilizada ✅ (Recomendada)
- **1.29** - Estável com suporte estendido
- **1.28** - Suporte ativo

⚠️ **Importante:** A AWS mantém suporte para as últimas 4-5 versões do Kubernetes. Versões antigas como 1.21 não têm mais suporte.

### Pré-requisito-2: Criar Cluster EKS e Worker Nodes (se não criado)

#### Passo 2.1: Criar Cluster EKS com OIDC Provider
```bash
# Criar o cluster (Control Plane)
# O flag --with-oidc já associa o OIDC provider automaticamente
eksctl create cluster --name=eksdemo1 \
                     --region=us-east-1 \
                     --zones=us-east-1a,us-east-1b \
                     --version="1.30" \
                     --without-nodegroup \
                     --with-oidc

# Verificar se o cluster foi criado
eksctl get cluster
```

#### Passo 2.2: Instalar Addons Essenciais

**a) Instalar Pod Identity Agent**
```bash
# O Pod Identity Agent é necessário para autenticação segura dos pods com AWS services
eksctl create addon --cluster=eksdemo1 \
                   --name=eks-pod-identity-agent \
                   --version=latest
```

**b) Instalar EBS CSI Driver**
```bash
# 1. Obter o Account ID da sua conta AWS
aws sts get-caller-identity --query Account --output text

# 2. Criar IAM role para o EBS CSI Driver
# Substitua 390214104376 pelo seu Account ID
eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster eksdemo1 \
    --role-name AmazonEKSPodIdentityAmazonEBSCSIDriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

# 3. Instalar o EBS CSI Driver addon
# Substitua 390214104376 pelo seu Account ID
eksctl create addon --cluster eksdemo1 \
                   --name aws-ebs-csi-driver \
                   --version latest \
                   --service-account-role-arn arn:aws:iam::390214104376:role/AmazonEKSPodIdentityAmazonEBSCSIDriverRole \
                   --force

# 4. Verificar os addons instalados
eksctl get addon --cluster eksdemo1
```

#### Passo 2.3: Criar Worker Nodes (Node Group)
```bash
# Criar EKS NodeGroup em VPC Private Subnets
# Este comando cria os nós de trabalho onde os pods serão executados
eksctl create nodegroup --cluster=eksdemo1 \
                        --region=us-east-1 \
                        --name=eksdemo1-ng-private1 \
                        --node-type=t3.medium \
                        --nodes-min=2 \
                        --nodes-max=4 \
                        --node-volume-size=20 \
                        --ssh-access \
                        --ssh-public-key=kube-demo \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access \
                        --node-private-networking
```

**📝 Resumo do que foi criado:**
- ✅ EKS Cluster (Control Plane) com OIDC Provider
- ✅ Pod Identity Agent addon
- ✅ EBS CSI Driver addon com IAM Role
- ✅ Node Group com 2-4 nós t3.medium em subnets privadas

### Pré-requisito-3: Verificar Cluster, Node Groups e configurar kubectl

```bash
# 1. Verificar EKS Cluster
eksctl get cluster

# 2. Verificar EKS Node Groups
eksctl get nodegroup --cluster=eksdemo1

# 3. Verificar Addons instalados
eksctl get addon --cluster=eksdemo1

# 4. Verificar IAM Service Accounts criadas
eksctl get iamserviceaccount --cluster=eksdemo1
# Você deve ver: ebs-csi-controller-sa

# 5. Configurar kubectl para acessar o cluster
aws eks --region us-east-1 update-kubeconfig --name eksdemo1

# 6. Verificar nodes do cluster
kubectl get nodes -o wide

# 7. Verificar pods do sistema
kubectl get pods -n kube-system

# 8. Verificar se os addons estão rodando
kubectl get pods -n kube-system | grep ebs-csi
kubectl get pods -n kube-system | grep pod-identity
```

**✅ Checklist de Verificação:**
- [ ] Cluster criado e ativo
- [ ] Node Group com 2+ nós em estado Ready
- [ ] Addons instalados (eks-pod-identity-agent, aws-ebs-csi-driver)
- [ ] kubectl configurado e conectando ao cluster
- [ ] Pods do sistema rodando corretamente

**🔍 Verificar no AWS Console:**
1. **EKS → Clusters** → eksdemo1
2. **Compute** → Nodes (verificar se estão em subnets privadas)
3. **Add-ons** → Verificar status dos addons
4. **IAM → Roles** → Procurar por AmazonEKSPodIdentityAmazonEBSCSIDriverRole

## Passo-02: Criar IAM Policy para AWS Load Balancer Controller

O AWS Load Balancer Controller precisa de permissões IAM para gerenciar recursos AWS (ALB, NLB, Target Groups, etc).

**🔗 Referência:** [AWS Load Balancer Controller - GitHub](https://github.com/kubernetes-sigs/aws-load-balancer-controller)

```bash
# Navegar até o diretório correto
cd 08-NEW-ELB-Application-LoadBalancers/08-01-Load-Balancer-Controller-Install

# Fazer download da IAM Policy mais recente
curl -o iam_policy_latest.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

# Verificar o arquivo baixado
ls -lh iam_policy_latest.json
cat iam_policy_latest.json

# Criar a IAM Policy na AWS
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy_latest.json
```

**📋 Exemplo de Output:**
```json
{
    "Policy": {
        "PolicyName": "AWSLoadBalancerControllerIAMPolicy",
        "PolicyId": "ANPAVVWUSWU4CJO6KCSEL",
        "Arn": "arn:aws:iam::390214104376:policy/AWSLoadBalancerControllerIAMPolicy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2025-10-07T19:19:34Z",
        "UpdateDate": "2025-10-07T19:19:34Z"
    }
}
```

**📝 Anotar o Policy ARN:**
```bash
# Copie o ARN da sua policy (substitua o Account ID pelo seu)
Policy ARN: arn:aws:iam::390214104376:policy/AWSLoadBalancerControllerIAMPolicy

# Ou obtenha o ARN com este comando
aws iam list-policies --query 'Policies[?PolicyName==`AWSLoadBalancerControllerIAMPolicy`].Arn' --output text
```

⚠️ **Nota:** Ao visualizar a policy no AWS Console, você pode ver avisos relacionados a ELB v1. Isso é normal e pode ser ignorado, pois algumas ações são específicas para ELB v2 (ALB/NLB).


## Passo-03: Criar IAM Role e Kubernetes Service Account

Este passo vincula uma IAM Role da AWS com uma Service Account do Kubernetes (IRSA - IAM Roles for Service Accounts).

**O que será criado:**
- ✅ AWS IAM Role com a policy anexada
- ✅ Kubernetes Service Account no namespace `kube-system`
- ✅ Trust relationship entre IAM Role e Service Account via OIDC

### Passo-03-01: Verificar se a Service Account já existe

```bash
# Verificar service accounts no namespace kube-system
kubectl get sa -n kube-system | grep load-balancer

# Verificar especificamente a service account do Load Balancer Controller
kubectl get sa aws-load-balancer-controller -n kube-system 2>/dev/null || echo "Service Account não existe (isso é esperado)"
```

### Passo-03-02: Criar IAM Role e Service Account usando eksctl

```bash
# Criar IAM Service Account
# Substitua o Policy ARN pelo seu (obtido no Passo-02)
eksctl create iamserviceaccount \
  --cluster=eksdemo1 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::390214104376:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```

**💡 O que este comando faz:**
1. Cria uma IAM Role na AWS
2. Anexa a policy `AWSLoadBalancerControllerIAMPolicy` à role
3. Configura trust relationship com o OIDC provider do cluster
4. Cria uma Kubernetes Service Account no namespace `kube-system`
5. Anota a Service Account com o ARN da IAM Role

**📋 Exemplo de Output da criação:**
```bash
2022-02-02 10:22:49 [ℹ]  eksctl version 0.82.0
2022-02-02 10:22:49 [ℹ]  using region us-east-1
2022-02-02 10:22:52 [ℹ]  1 iamserviceaccount (kube-system/aws-load-balancer-controller) was included
2022-02-02 10:22:52 [!]  metadata of serviceaccounts that exist in Kubernetes will be updated
2022-02-02 10:22:52 [ℹ]  building iamserviceaccount stack "eksctl-eksdemo1-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"
2022-02-02 10:22:53 [ℹ]  deploying stack...
2022-02-02 10:23:32 [ℹ]  created serviceaccount "kube-system/aws-load-balancer-controller"
```

### Passo-03-03: Verificar recursos criados

**a) Verificar usando eksctl:**
```bash
# Listar todas as IAM Service Accounts do cluster
eksctl get iamserviceaccount --cluster eksdemo1

# Output esperado:
# NAMESPACE       NAME                            ROLE ARN
# kube-system     ebs-csi-controller-sa          arn:aws:iam::390214104376:role/...EBSCSIDriverRole
# kube-system     aws-load-balancer-controller    arn:aws:iam::390214104376:role/...LoadBalancerController
```

**b) Verificar CloudFormation Stack:**
```bash
# Listar stacks do CloudFormation
aws cloudformation list-stacks --query 'StackSummaries[?contains(StackName, `aws-load-balancer-controller`)].{Name:StackName,Status:StackStatus}' --output table
```

**🔍 No AWS Console:**
1. **CloudFormation** → Procurar stack: `eksctl-eksdemo1-addon-iamserviceaccount-kube-system-aws-load-balancer-controller`
2. Aba **Resources** → Verificar `Role1` (Physical ID)
3. **IAM → Roles** → Abrir a role criada → Verificar:
   - **Permissions**: Policy `AWSLoadBalancerControllerIAMPolicy` anexada
   - **Trust relationships**: Trust com o OIDC provider do cluster

**c) Verificar Kubernetes Service Account:**
```bash
# Listar service accounts do namespace kube-system
kubectl get sa -n kube-system | grep load-balancer

# Descrever a service account em detalhes
kubectl describe sa aws-load-balancer-controller -n kube-system
```

**📋 Output esperado:**
```yaml
Name:                aws-load-balancer-controller
Namespace:           kube-system
Labels:              app.kubernetes.io/managed-by=eksctl
Annotations:         eks.amazonaws.com/role-arn: arn:aws:iam::390214104376:role/eksctl-eksdemo1-addon-iamserviceaccount-kube--Role1-XXXXX
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              <none>
Events:              <none>
```

✅ **Importante:** A annotation `eks.amazonaws.com/role-arn` confirma que a IAM Role está vinculada à Service Account.

## Passo-04: Instalar o AWS Load Balancer Controller usando Helm V3 
### Passo-04-01: Instalar Helm

- [Instalar Helm](https://helm.sh/docs/intro/install/) se não instalado
- [Instalar Helm para AWS EKS](https://docs.aws.amazon.com/eks/latest/userguide/helm.html)

```bash
# Instalar Helm (se não instalado) MacOS
brew install helm

# Verificar versão do Helm
helm version
```

### Passo-04-02: Instalar AWS Load Balancer Controller
- **Nota Importante 1:** Se você está fazendo deploy do controller em Amazon EC2 nodes que têm acesso restrito ao Amazon EC2 instance metadata service (IMDS), ou se está fazendo deploy no Fargate, então adicione as seguintes flags ao comando:

```bash
--set region=region-code
--set vpcId=vpc-xxxxxxxx
```

- **Nota Importante 2:** **DESCONTINUADO** 
  - Se você está fazendo deploy em qualquer Região que não seja us-west-2, então adicione a seguinte flag ao comando, substituindo account e region-code com os valores da sua região listados em Amazon EKS add-on container image addresses.
- [Obter Region Code e Account info](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)

```bash
--set image.repository=account.dkr.ecr.region-code.amazonaws.com/amazon/aws-load-balancer-controller
```

- **Nota Importante 3:** **ADICIONADO RECENTEMENTE - RECOMENDADO** 
  - Você não precisa mais usar URIs de imagem específicas por região.

```bash
# Adicionar o repositório eks-charts
helm repo add eks https://aws.github.io/eks-charts

# Atualizar seu repositório local para ter certeza que tem os charts mais recentes
helm repo update

# Instalar o AWS Load Balancer Controller
## Template
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region-code> \
  --set vpcId=<vpc-xxxxxxxx> \
  --set image.repository=public.ecr.aws/eks/aws-load-balancer-controller

## Substituir Cluster Name, Region Code, VPC ID, Image Repo Account ID e Region Code  
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eksdemo1 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-03c78d451fba11905 \
  --set image.repository=public.ecr.aws/eks/aws-load-balancer-controller
```
- **Exemplo de output para passos de instalação do AWS Load Balancer Controller**
```bash
## Exemplo de Output para passos de instalação do AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eksdemo1 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-03c78d451fba11905 \
  --set image.repository=public.ecr.aws/eks/aws-load-balancer-controller

NAME: aws-load-balancer-controller
LAST DEPLOYED: Tue Oct  7 16:27:50 2025
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
AWS Load Balancer controller installed!

```
### Passo-04-03: Verificar que o controller foi instalado e Webhook Service criado
```bash
# Verificar que o controller foi instalado
kubectl -n kube-system get deployment 

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   2/2     2            2           26s
coredns                        2/2     2            2           25m
ebs-csi-controller             0/2     2            0           20m
metrics-server                 2/2     2            2           25m

kubectl -n kube-system get deployment aws-load-balancer-controller

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
aws-load-balancer-controller   2/2     2            2           49s

kubectl -n kube-system describe deployment aws-load-balancer-controller


# Verificar se o AWS Load Balancer Controller Webhook service foi criado
kubectl -n kube-system get svc 
kubectl -n kube-system get svc aws-load-balancer-webhook-service
kubectl -n kube-system describe svc aws-load-balancer-webhook-service

# Exemplo de Output
kubectl -n kube-system get svc aws-load-balancer-webhook-service
NAME                                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
aws-load-balancer-webhook-service   ClusterIP   10.100.53.52   <none>        443/TCP   61m


# Verificar Labels no Service e Selector Labels no Deployment
kubectl -n kube-system get svc aws-load-balancer-webhook-service -o yaml

Observação:
1. Verificar label "spec.selector" em "aws-load-balancer-webhook-service"
2. Comparar com "aws-load-balancer-controller" Deployment "spec.selector.matchLabels"
3. Ambos os valores devem ser iguais, o que significa que o tráfego chegando em "aws-load-balancer-webhook-service" na porta 443 será enviado para porta 9443 nos pods relacionados ao deployment "aws-load-balancer-controller". 
```

### Passo-04-04: Verificar Logs do AWS Load Balancer Controller
```bash
# Listar Pods
kubectl get pods -n kube-system

# Revisar logs do AWS LB Controller POD-1
kubectl -n kube-system logs -f <POD-NAME> 
kubectl -n kube-system logs -f  aws-load-balancer-controller-86b598cbd6-5pjfk

# Revisar logs do AWS LB Controller POD-2
kubectl -n kube-system logs -f <POD-NAME> 
kubectl -n kube-system logs -f aws-load-balancer-controller-86b598cbd6-vqqsk
```

### Passo-04-05: Verificar AWS Load Balancer Controller k8s Service Account - Internals 
```bash
# Listar Service Account e seu secret
kubectl -n kube-system get sa aws-load-balancer-controller
kubectl -n kube-system get sa aws-load-balancer-controller -o yaml
kubectl -n kube-system get secret
kubectl -n kube-system get secret <OBTER_DO_COMANDO_ANTERIOR - secrets.name> -o yaml
kubectl -n kube-system get secret sh.helm.release.v1.aws-load-balancer-controller.v1 
kubectl -n kube-system get secret sh.helm.release.v1.aws-load-balancer-controller.v1 -o yaml
## Decodificar ca.crt usando os dois websites abaixo
https://www.base64decode.org/
https://www.sslchecker.com/certdecoder

## Decodificar token usando os dois websites abaixo
https://www.base64decode.org/
https://jwt.io/
Observação:
1. Revisar o JWT Token decodificado

# Listar Deployment em formato YAML
kubectl -n kube-system get deploy aws-load-balancer-controller -o yaml

Observação:
1. Verificar "spec.template.spec.serviceAccount" e "spec.template.spec.serviceAccountName" no Deployment "aws-load-balancer-controller"
2. Devemos encontrar o Service Account Name como "aws-load-balancer-controller"

# Listar Pods em formato YAML
kubectl -n kube-system get pods
kubectl -n kube-system get pod <AWS-Load-Balancer-Controller-POD-NAME> -o yaml
kubectl -n kube-system get pod aws-load-balancer-controller-65b4f64d6c-h2vh4 -o yaml

Observação:
1. Verificar "spec.serviceAccount" e "spec.serviceAccountName"
2. Devemos encontrar o Service Account Name como "aws-load-balancer-controller"
3. Verificar "spec.volumes". Você deve encontrar algo como abaixo, que são credenciais temporárias para acessar AWS Services
CHECK-1: Verificar "spec.volumes.name = aws-iam-token"
  - name: aws-iam-token
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          audience: sts.amazonaws.com
          expirationSeconds: 86400
          path: token
CHECK-2: Verificar Volume Mounts
    volumeMounts:
    - mountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount
      name: aws-iam-token
      readOnly: true          
CHECK-3: Verificar ENVs cujo nome do path é "token"
    - name: AWS_WEB_IDENTITY_TOKEN_FILE
      value: /var/run/secrets/eks.amazonaws.com/serviceaccount/token          
```

### Passo-04-06: Verificar Certificados TLS para AWS Load Balancer Controller - Internals
```bash
# Listar secret aws-load-balancer-tls
kubectl -n kube-system get secret aws-load-balancer-tls -o yaml

# Verificar ca.crt e tls.crt nos websites abaixo
https://www.base64decode.org/
https://www.sslchecker.com/certdecoder

# Anotar Common Name e SAN do resultado acima
Common Name: aws-load-balancer-controller
SAN: aws-load-balancer-webhook-service.kube-system, aws-load-balancer-webhook-service.kube-system.svc

# Listar Pods em formato YAML
kubectl -n kube-system get pods
kubectl -n kube-system get pod <AWS-Load-Balancer-Controller-POD-NAME> -o yaml
kubectl -n kube-system get pod aws-load-balancer-controller-65b4f64d6c-h2vh4 -o yaml
Observação:
1. Verificar como o secret está montado no AWS Load Balancer Controller Pod
CHECK-2: Verificar Volume Mounts
    volumeMounts:
    - mountPath: /tmp/k8s-webhook-server/serving-certs
      name: cert
      readOnly: true
CHECK-3: Verificar Volumes
  volumes:
  - name: cert
    secret:
      defaultMode: 420
      secretName: aws-load-balancer-tls
```

### Passo-04-07: DESINSTALAR AWS Load Balancer Controller usando Comando Helm (Informação - NÃO EXECUTAR ESTE COMANDO)
- Este passo não deve ser implementado
- Está aqui apenas para sabermos como desinstalar o aws load balancer controller do EKS Cluster
```bash
# Desinstalar AWS Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system 
```



## Passo-05: Conceito de Ingress Class
- Entender o que é Ingress Class 
- Entender como ela substitui a annotation descontinuada padrão `#kubernetes.io/ingress.class: "alb"`
- [Referência de Documentação Ingress Class](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/ingress_class/)
- [Diferentes Ingress Controllers disponíveis hoje](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)


## Passo-06: Revisar Manifesto Kubernetes IngressClass
- **Localização do Arquivo:** `08-01-Load-Balancer-Controller-Install/kube-manifests/01-ingressclass-resource.yaml`
- Entender em detalhes sobre a annotation `ingressclass.kubernetes.io/is-default-class: "true"`
```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: my-aws-ingress-class
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: ingress.k8s.aws/alb

## Nota Adicional
# 1. Você pode marcar uma IngressClass específica como padrão para seu cluster. 
# 2. Definir a annotation ingressclass.kubernetes.io/is-default-class como true em um recurso IngressClass garantirá que novos Ingresses sem um campo ingressClassName especificado serão atribuídos a esta IngressClass padrão.  
# 3. Referência: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/ingress/ingress_class/
```

## Passo-07: Criar Recurso IngressClass
```bash
# Navegar para o Diretório
cd 08-01-Load-Balancer-Controller-Install

# Criar Recurso IngressClass
kubectl apply -f kube-manifests

# Verificar Recurso IngressClass
kubectl get ingressclass

# Descrever Recurso IngressClass
kubectl describe ingressclass my-aws-ingress-class
```

## Referências
- [Instalação do AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
- [Repositório ECR por região](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)
