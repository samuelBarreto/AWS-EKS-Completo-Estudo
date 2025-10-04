---
layout: page
title: "EKS Cluster Creation"
description: "Criação de cluster EKS com eksctl - Do básico ao avançado"
permalink: /01-eks-cluster/
---

# 🚀 EKS Cluster Creation

Aprenda a criar e gerenciar clusters EKS na AWS usando o eksctl, a ferramenta oficial para gerenciamento de clusters EKS.

## 📚 **Conteúdo do Módulo**

### ⚙️ **01-01 - Install CLIs**
- Instalação do AWS CLI
- Instalação do eksctl
- Instalação do kubectl
- Configuração de credenciais

### 🏗️ **01-02 - Create EKS Cluster and NodeGroups**
- Criação de cluster básico
- Configuração de NodeGroups
- Escolha de instâncias EC2
- Configuração de rede

### 💰 **01-03 - EKS Cluster Pricing**
- Custos do EKS
- Custos de instâncias EC2
- Custos de Load Balancers
- Otimização de custos

### 🗑️ **01-04 - Delete EKS Cluster and NodeGroups**
- Limpeza de recursos
- Comandos de delete
- Verificação de limpeza
- Boas práticas

## 🎯 **Objetivos de Aprendizado**

Ao final deste módulo, você será capaz de:

✅ **Instalar e configurar** todas as ferramentas necessárias  
✅ **Criar clusters EKS** usando eksctl  
✅ **Configurar NodeGroups** com diferentes tipos de instâncias  
✅ **Entender os custos** envolvidos no EKS  
✅ **Limpar recursos** adequadamente  

## 🛠️ **Recursos Práticos**

### **Comandos Essenciais**
```bash
# Criar cluster
eksctl create cluster --name meu-cluster --region us-east-1

# Criar NodeGroup
eksctl create nodegroup --cluster=meu-cluster --name=workers

# Deletar cluster
eksctl delete cluster --name meu-cluster
```

### **Configurações Avançadas**
```yaml
# cluster-config.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: meu-cluster
  region: us-east-1

nodeGroups:
  - name: workers
    instanceType: t3.medium
    desiredCapacity: 2
```

## 📊 **Arquitetura EKS**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   EKS Control   │    │   NodeGroup 1   │    │   NodeGroup 2   │
│     Plane       │    │   (t3.medium)   │    │   (t3.large)    │
│                 │    │                 │    │                 │
│ • API Server    │    │ • Pods          │    │ • Pods          │
│ • etcd          │    │ • kubelet       │    │ • kubelet       │
│ • Scheduler     │    │ • kube-proxy    │    │ • kube-proxy    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 💰 **Estimativa de Custos**

| Recurso | Custo Mensal (aproximado) |
|---------|---------------------------|
| **EKS Control Plane** | $73.20 |
| **t3.medium (2 instâncias)** | $60.48 |
| **Load Balancer** | $18.25 |
| **Total** | **~$152/mês** |

## 📖 **Artigos Relacionados**

- [EKS vs ECS: Qual escolher?](#)
- [Configurando Auto Scaling no EKS](#)
- [Security Best Practices para EKS](#)

## 🚀 **Próximo Módulo**

Após criar seu cluster EKS, continue para:
**[02 - Docker Fundamentals](/02-docker/)** - Conceitos básicos do Docker

---

**💡 Dica:** Sempre teste em ambiente de desenvolvimento antes de criar clusters em produção!
