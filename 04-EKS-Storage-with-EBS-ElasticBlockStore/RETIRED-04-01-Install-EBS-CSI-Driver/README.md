# EKS Storage com EBS - Elastic Block Store

## Passo-01: Introdução
- Criar Política IAM para EBS
- Associar Política IAM à Função IAM dos Worker Nodes
- Instalar EBS CSI Driver

## Passo-02: Criar política IAM
- Ir para Services -> IAM
- Criar uma Política 
  - Selecionar aba JSON e copiar/colar o JSON abaixo
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
```
  - Revisar o mesmo no **Visual Editor** 
  - Clicar em **Review Policy**
  - **Nome:** Amazon_EBS_CSI_Driver
  - **Descrição:** Política para Instâncias EC2 acessarem Elastic Block Store
  - Clicar em **Create Policy**

## Passo-03: Obter a função IAM que os Worker Nodes estão usando e Associar esta política a essa função
```bash
# Obter ARN da Função IAM do Worker node
kubectl -n kube-system describe configmap aws-auth

# do output verificar rolearn
rolearn: arn:aws:iam::180789647333:role/eksctl-eksdemo1-nodegroup-eksdemo-NodeInstanceRole-IJN07ZKXAWNN
```
- Ir para Services -> IAM -> Roles 
- Pesquisar por função com nome **eksctl-eksdemo1-nodegroup** e abrir
- Clicar na aba **Permissions**
- Clicar em **Attach Policies**
- Pesquisar por **Amazon_EBS_CSI_Driver** e clicar em **Attach Policy**

## Passo-04: Implantar Amazon EBS CSI Driver  
- Verificar versão do kubectl, deve ser 1.14 ou posterior
```bash
kubectl version --client --short
```
- Implantar Amazon EBS CSI Driver
```bash
# Implantar EBS CSI Driver
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# Verificar pods ebs-csi executando
kubectl get pods -n kube-system
```
