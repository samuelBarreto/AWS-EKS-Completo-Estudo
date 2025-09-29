# Amazon EBS CSI Driver no EKS (com Pod Identity)

## Passo-00: O que faremos

1. Instalar o add-on **Amazon EBS CSI Driver** (com função IAM via "Create recommended role")
2. Verificar a instalação usando `kubectl`

---

## Passo-01: Instalar Amazon EBS CSI Driver

1. Ainda em **Add-ons** → **Get more add-ons**
2. Pesquisar por **Amazon EBS CSI driver (`aws-ebs-csi-driver`)**
3. Na etapa **Permissions**, escolher **Create recommended role**

   * O console criará uma função IAM com as políticas gerenciadas:
     **`AmazonEBSCSIDriverPolicy`** e **`AmazonEKSClusterPolicy`**
   * A confiança é automaticamente definida para **`pods.eks.amazonaws.com`**

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

4. Clicar em **Create**

> Isso implanta o Deployment **EBS CSI controller** e o DaemonSet **EBS CSI node**.

---

## Passo-02: Verificar a instalação

```bash
# Listar pods no kube-system
kubectl get pods -n kube-system
```

**Saída esperada (exemplo):**

```bash
NAME                                  READY   STATUS    RESTARTS   AGE
aws-node-np6bt                        2/2     Running   0          2h
coredns-6b9575c64c-bvlxh              1/1     Running   0          2h45m
ebs-csi-controller-6c794c785d-27mcc   6/6     Running   0          15m
ebs-csi-node-bf4nq                    3/3     Running   0          15m
eks-pod-identity-agent-mkxmw          1/1     Running   0          42m
kube-proxy-6svwq                      1/1     Running   0          2h
metrics-server-75c7985757-c2cbf       1/1     Running   0          2h45m
```

```bash
# DaemonSets
kubectl get ds -n kube-system
```

**Saída esperada (exemplo):**

```bash
NAME                     DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR              AGE
aws-node                 2         2         2       2            2           <none>                     2h45m
ebs-csi-node             2         2         2       2            2           kubernetes.io/os=linux     15m
eks-pod-identity-agent   2         2         2       2            2           <none>                     42m
kube-proxy               2         2         2       2            2           <none>                     2h45m
```

```bash
# Deployments
kubectl get deploy -n kube-system
```

**Saída esperada (exemplo):**

```bash
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
coredns              2/2     2            2           2h45m
ebs-csi-controller   2/2     2            2           16m
metrics-server       2/2     2            2           2h45m
```

---

## Resumo

* Instalado o add-on **Amazon EBS CSI Driver** (com função IAM recomendada)
* Verificado que os **pods do EBS CSI controller** e o **DaemonSet EBS CSI node** estão executando com sucesso no cluster

---
