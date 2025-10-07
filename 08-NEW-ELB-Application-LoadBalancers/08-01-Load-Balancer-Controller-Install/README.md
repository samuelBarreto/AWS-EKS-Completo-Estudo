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

## Passo-04: Instalar o AWS Load Balancer Controller usando Helm

### Passo-04-01: Verificar e instalar Helm (se necessário)

```bash
# Verificar se o Helm está instalado
helm version

# Se não estiver instalado:
# MacOS/Linux: brew install helm
# Windows: choco install kubernetes-helm
# Ou siga: https://helm.sh/docs/intro/install/
```

### Passo-04-02: Preparar informações necessárias

```bash
# Obter o VPC ID do cluster
aws eks describe-cluster --name eksdemo1 --query "cluster.resourcesVpcConfig.vpcId" --output text

# Exemplo de output: vpc-03c78d451fba11905
```

### Passo-04-03: Instalar o AWS Load Balancer Controller

```bash
# 1. Adicionar o repositório Helm do EKS
helm repo add eks https://aws.github.io/eks-charts

# 2. Atualizar repositórios locais
helm repo update eks

# 3. Instalar o AWS Load Balancer Controller
# ⚠️ Substitua o VPC ID pelo seu (obtido no comando anterior)
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eksdemo1 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-03c78d451fba11905 \
  --set image.repository=public.ecr.aws/eks/aws-load-balancer-controller
```

**📝 Explicação dos parâmetros:**
- `clusterName`: Nome do cluster EKS
- `serviceAccount.create=false`: Não cria service account (já criamos no Passo-03)
- `serviceAccount.name`: Nome da service account existente
- `region`: Região AWS do cluster
- `vpcId`: VPC ID onde o cluster está rodando
- `image.repository`: Repositório público da imagem (não precisa mais de repositório específico por região)

**📋 Exemplo de Output:**
```bash
NAME: aws-load-balancer-controller
LAST DEPLOYED: Tue Oct  7 16:27:50 2025
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
AWS Load Balancer controller installed!
```

**💡 Notas Importantes:**
- ✅ Para EC2 nodes com IMDS restrito ou Fargate, os parâmetros `region` e `vpcId` são obrigatórios (já incluídos acima)
- ✅ A imagem pública `public.ecr.aws/eks/aws-load-balancer-controller` funciona em todas as regiões
- ❌ Não é mais necessário usar repositórios ECR específicos por região

### Passo-04-04: Verificar a instalação

**a) Verificar Deployment:**
```bash
# Listar todos os deployments no kube-system
kubectl -n kube-system get deployment

# Verificar especificamente o Load Balancer Controller
kubectl -n kube-system get deployment aws-load-balancer-controller

# Output esperado:
# NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
# aws-load-balancer-controller   2/2     2            2           49s

# Ver detalhes do deployment
kubectl -n kube-system describe deployment aws-load-balancer-controller
```

**b) Verificar Pods:**
```bash
# Listar pods do Load Balancer Controller
kubectl -n kube-system get pods -l app.kubernetes.io/name=aws-load-balancer-controller

# Verificar status dos pods (devem estar Running)
kubectl -n kube-system get pods -l app.kubernetes.io/name=aws-load-balancer-controller -o wide
```

**c) Verificar Webhook Service:**
```bash
# Listar o webhook service
kubectl -n kube-system get svc aws-load-balancer-webhook-service

# Output esperado:
# NAME                                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
# aws-load-balancer-webhook-service   ClusterIP   10.100.53.52    <none>        443/TCP   2m

# Ver detalhes do service
kubectl -n kube-system describe svc aws-load-balancer-webhook-service
```

**d) Verificar Labels e Selectors:**
```bash
# Verificar labels do Service
kubectl -n kube-system get svc aws-load-balancer-webhook-service -o jsonpath='{.spec.selector}' | jq

# Verificar labels do Deployment
kubectl -n kube-system get deployment aws-load-balancer-controller -o jsonpath='{.spec.selector.matchLabels}' | jq
```

**📝 Importante:** Os selectors do Service devem corresponder aos labels do Deployment. Isso garante que o tráfego chegando no webhook service (porta 443) seja roteado para os pods do controller (porta 9443).

### Passo-04-05: Verificar Logs do Controller

```bash
# Listar pods do Load Balancer Controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Verificar logs do primeiro pod (replica 1)
kubectl -n kube-system logs -f deployment/aws-load-balancer-controller --all-containers=true --tail=50

# Ou verificar logs de um pod específico
kubectl -n kube-system logs -f <POD-NAME>

# Exemplo:
# kubectl -n kube-system logs -f aws-load-balancer-controller-86b598cbd6-5pjfk
```

**✅ Logs esperados (indicando sucesso):**
- Mensagens sobre leader election
- Registro de webhook server iniciado
- Sem erros de autenticação ou permissão
- Mensagem: "controller started"

### Passo-04-06: (Opcional) Verificar Internals - Service Account e IRSA

**🔍 Para entender como funciona a integração IAM-Kubernetes (IRSA):**

```bash
# 1. Verificar Service Account
kubectl -n kube-system get sa aws-load-balancer-controller -o yaml

# 2. Verificar Deployment (Service Account está referenciado)
kubectl -n kube-system get deploy aws-load-balancer-controller -o jsonpath='{.spec.template.spec.serviceAccountName}'

# 3. Verificar Pod (como as credenciais AWS são montadas)
POD_NAME=$(kubectl -n kube-system get pods -l app.kubernetes.io/name=aws-load-balancer-controller -o jsonpath='{.items[0].metadata.name}')
kubectl -n kube-system get pod $POD_NAME -o yaml | grep -A 10 "aws-iam-token"

# O que procurar:
# - Volume "aws-iam-token" projetado com token da service account
# - MountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount
# - Env var: AWS_WEB_IDENTITY_TOKEN_FILE aponta para o token
```

**💡 Como funciona:**
1. Pod usa a Service Account `aws-load-balancer-controller`
2. Kubernetes monta um token JWT no pod
3. AWS SDK usa esse token para assumir a IAM Role via OIDC
4. Role fornece credenciais temporárias para acessar AWS APIs

### Passo-04-07: (Opcional) Verificar Certificados TLS do Webhook

```bash
# Verificar secret TLS do webhook
kubectl -n kube-system get secret aws-load-balancer-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -text -noout | grep -A 1 "Subject:"

# Verificar como está montado no pod
POD_NAME=$(kubectl -n kube-system get pods -l app.kubernetes.io/name=aws-load-balancer-controller -o jsonpath='{.items[0].metadata.name}')
kubectl -n kube-system get pod $POD_NAME -o yaml | grep -A 5 "serving-certs"
```

**📝 Certificados TLS:** O controller usa certificados TLS para comunicação segura do webhook. O Helm chart gerencia isso automaticamente.

---

## ✅ Checklist Final de Instalação

- [ ] EKS Cluster criado com OIDC Provider
- [ ] Pod Identity Agent instalado
- [ ] EBS CSI Driver instalado e funcionando
- [ ] IAM Policy `AWSLoadBalancerControllerIAMPolicy` criada
- [ ] IAM Role e Service Account vinculados (IRSA)
- [ ] AWS Load Balancer Controller instalado via Helm
- [ ] 2 replicas do controller em estado Running
- [ ] Webhook service criado e funcionando
- [ ] Logs do controller sem erros

---

## 🗑️ Desinstalação (Apenas para Referência)

**⚠️ NÃO EXECUTE estes comandos agora!** Apenas para referência futura:

```bash
# Desinstalar AWS Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system

# Deletar IAM Service Account
eksctl delete iamserviceaccount \
  --cluster=eksdemo1 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller

# Deletar IAM Policy
aws iam delete-policy \
  --policy-arn arn:aws:iam::390214104376:policy/AWSLoadBalancerControllerIAMPolicy
```

---



## Passo-05: Entender o Conceito de IngressClass

### O que é IngressClass?

O **IngressClass** é um recurso do Kubernetes que define qual controlador de Ingress deve processar um recurso Ingress específico.

**📚 Por que usar IngressClass?**
- Substitui a annotation descontinuada `kubernetes.io/ingress.class: "alb"`
- Permite múltiplos controllers de Ingress no mesmo cluster
- Facilita a gestão de diferentes tipos de load balancers

**🔗 Referências:**
- [AWS Load Balancer Controller - IngressClass](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/ingress_class/)
- [Kubernetes - Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

---

## Passo-06: Criar e Aplicar IngressClass Padrão

### Passo-06-01: Revisar o Manifesto IngressClass

**📁 Arquivo:** `kube-manifests/01-ingressclass-resource.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: my-aws-ingress-class
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: ingress.k8s.aws/alb
```

**📝 Explicação:**
- `name: my-aws-ingress-class` - Nome da IngressClass (pode ser qualquer nome)
- `ingressclass.kubernetes.io/is-default-class: "true"` - Define como IngressClass padrão do cluster
- `controller: ingress.k8s.aws/alb` - Especifica que o AWS Load Balancer Controller gerenciará os Ingresses

**💡 IngressClass Padrão:**
- Quando marcada como `default`, todos os recursos Ingress **sem** `ingressClassName` especificado usarão esta classe automaticamente
- Só deve haver **uma** IngressClass padrão por cluster

### Passo-06-02: Aplicar o Manifesto IngressClass

```bash
# Navegar até o diretório
cd 08-NEW-ELB-Application-LoadBalancers/08-01-Load-Balancer-Controller-Install

# Aplicar o manifesto
kubectl apply -f kube-manifests/01-ingressclass-resource.yaml

# Verificar se foi criado
kubectl get ingressclass
```

**📋 Output esperado:**
```
NAME                   CONTROLLER            PARAMETERS   AGE
my-aws-ingress-class   ingress.k8s.aws/alb   <none>       10s
```

### Passo-06-03: Verificar IngressClass

```bash
# Listar todas as IngressClasses
kubectl get ingressclass

# Ver detalhes
kubectl describe ingressclass my-aws-ingress-class

# Ver em YAML
kubectl get ingressclass my-aws-ingress-class -o yaml
```

**✅ Verificar:**
- Annotation `ingressclass.kubernetes.io/is-default-class: "true"` presente
- Controller: `ingress.k8s.aws/alb`

---

## 🎉 Instalação Completa!

Parabéns! Você instalou com sucesso o **AWS Load Balancer Controller** no seu cluster EKS.

**🚀 Próximos Passos:**
1. Criar aplicações de exemplo
2. Configurar recursos Ingress para expor as aplicações
3. O AWS Load Balancer Controller criará automaticamente Application Load Balancers (ALBs)

**📖 Recursos úteis:**
- [AWS Load Balancer Controller - Documentação](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [Exemplos de Ingress](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/)
- [Troubleshooting](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/troubleshooting/)

---

## 📚 Referências e Documentação

- [AWS EKS - AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
- [AWS Load Balancer Controller - GitHub](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
- [AWS Load Balancer Controller - Documentação Oficial](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [Kubernetes - Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
- [EKS Add-ons - Container Images por Região](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)

---

## 🆘 Troubleshooting Comum

**Problema:** Pods do controller não iniciam
```bash
# Verificar logs
kubectl -n kube-system logs deployment/aws-load-balancer-controller

# Verificar eventos
kubectl -n kube-system get events --sort-by='.lastTimestamp'
```

**Problema:** Erro de permissão IAM
```bash
# Verificar se a IAM Role está corretamente vinculada
kubectl -n kube-system describe sa aws-load-balancer-controller | grep Annotations

# Testar permissões AWS CLI
aws sts get-caller-identity
```

**Problema:** Webhook não está funcionando
```bash
# Verificar webhook service
kubectl -n kube-system get svc aws-load-balancer-webhook-service

# Verificar certificados
kubectl -n kube-system get secret aws-load-balancer-tls
```
