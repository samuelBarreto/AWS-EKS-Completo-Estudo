---
layout: page
title: "Kubernetes - Conceitos Importantes para Deployments"
description: "Secrets, ConfigMaps, Probes, Requests/Limits e Namespaces"
permalink: /05-kubernetes-concepts/
---

# 🚀 Kubernetes - Conceitos Importantes para Deployments

Este módulo aborda os conceitos fundamentais do Kubernetes necessários para fazer deployments robustos e seguros de aplicações.

## 📚 **Conteúdo do Módulo**

### 🔐 **05-01 - Kubernetes Secrets**
- [Guia Completo de Secrets](/posts/kubernetes-secrets-guide/)
- Implementação segura de credenciais
- Melhores práticas de segurança
- Integração com ferramentas externas

### ⚙️ **05-02 - Kubernetes Init Containers**
- Containers de inicialização
- Casos de uso práticos
- Ordem de execução
- Troubleshooting

### 🔍 **05-03 - Liveness e Readiness Probes**
- Health checks em containers
- Configuração de probes
- Troubleshooting de aplicações
- Boas práticas

### 📊 **05-04 - Requests e Limits**
- Gerenciamento de recursos
- CPU e Memory limits
- Quality of Service (QoS)
- Otimização de performance

### 🏗️ **05-05 - Kubernetes Namespaces**
- Organização de recursos
- Isolamento de ambientes
- RBAC por namespace
- Resource Quotas

## 🎯 **Objetivos de Aprendizado**

Ao final deste módulo, você será capaz de:

✅ **Implementar Secrets** de forma segura para credenciais  
✅ **Configurar Init Containers** para preparação de ambiente  
✅ **Configurar Health Checks** com Liveness e Readiness Probes  
✅ **Gerenciar recursos** com Requests e Limits  
✅ **Organizar recursos** com Namespaces  

## 🛠️ **Recursos Práticos**

### **Manifestos Kubernetes**
- [Secrets YAML](/05-Kubernetes-Important-Concepts-for-Application-Deployments/05-01-Kubernetes-Secrets/)
- [ConfigMaps](/05-Kubernetes-Important-Concepts-for-Application-Deployments/05-01-Kubernetes-Secrets/)
- [Deployments com Probes](/05-Kubernetes-Important-Concepts-for-Application-Deployments/05-03-Kubernetes-Liveness-and-Readiness-Probes/)
- [Resource Management](/05-Kubernetes-Important-Concepts-for-Application-Deployments/05-04-Kubernetes-Requests-Limits/)

### **Exemplos de Aplicação**
- Microserviço de Gerenciamento de Usuários
- Integração com MySQL usando Secrets
- Health checks para aplicações web
- Gerenciamento de recursos por namespace

## 📖 **Artigos Relacionados**

- [Kubernetes Secrets: Guia Completo](/posts/kubernetes-secrets-guide/)
- [ConfigMaps vs Secrets: Quando usar cada um?](#)
- [Implementando RBAC no Kubernetes](#)
- [Monitoramento de Segurança em Clusters K8s](#)

## 🚀 **Próximo Módulo**

Após dominar estes conceitos, continue para:
**[06 - EKS Storage with RDS Database](/06-eks-storage-rds/)** - Integração com bancos de dados gerenciados

---

**💡 Dica:** Este módulo é fundamental para deployments em produção. Certifique-se de entender bem cada conceito antes de prosseguir!
