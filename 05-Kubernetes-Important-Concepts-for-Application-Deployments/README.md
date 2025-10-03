# Conceitos Importantes do Kubernetes para Deployments de Aplicações

Este módulo aborda os conceitos fundamentais do Kubernetes necessários para deployments robustos e seguros de aplicações em produção.

## 📋 Conceitos Abordados

| Nº  | Conceito                        | Descrição                                                        | Status |
| --- | ------------------------------- | ---------------------------------------------------------------- | ------ |
| 1.  | **Secrets**                     | Gerenciamento seguro de dados sensíveis (senhas, tokens, chaves) |   ✅  |
| 2.  | **Init Containers**             | Containers que executam antes dos containers principais          |   ✅ |
| 3.  | **Liveness & Readiness Probes** | Verificações de saúde e prontidão dos containers                 |   ✅ |
| 4.  | **Requests & Limits**           | Controle de recursos (CPU e memória)                             |   ✅ |
| 5.  | **Namespaces**                  | Isolamento e organização de recursos                             |   ✅ |

## 🎯 Objetivos de Aprendizado

Ao final deste módulo, você será capaz de:

- **Gerenciar Secrets** de forma segura para credenciais e dados sensíveis
- **Configurar Init Containers** para preparar o ambiente antes da aplicação principal
- **Implementar Health Checks** com Liveness e Readiness Probes
- **Definir Requests e Limits** para otimizar o uso de recursos
- **Organizar recursos** usando Namespaces para melhor isolamento

## 🚀 Estrutura do Módulo

### **05-01: Kubernetes Secrets**
- O que são Secrets
- Criando e gerenciando Secrets
- Usando Secrets em Deployments
- Boas práticas de segurança

### **05-02: Init Containers**
- Conceito e casos de uso
- Configuração de Init Containers
- Ordem de execução
- Exemplos práticos

### **05-03: Liveness e Readiness Probes**
- Diferença entre Liveness e Readiness
- Configuração de Health Checks
- Troubleshooting de aplicações
- Exemplos de configuração

### **05-04: Requests e Limits**
- Controle de recursos
- Configuração de CPU e Memória
- QoS Classes
- Monitoramento de recursos

### **05-05: Namespaces**
- Isolamento de recursos
- Criação e gerenciamento de Namespaces
- Resource Quotas
- Contextos e permissões

## 🛠️ Pré-requisitos

- Cluster Kubernetes funcionando
- kubectl configurado
- Conhecimento básico de YAML
- Conceitos de Pods, Deployments e Services

## 📚 Recursos Adicionais

- [Documentação Oficial do Kubernetes](https://kubernetes.io/docs/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Security Best Practices](https://kubernetes.io/docs/concepts/security/)

## 🎉 Vamos Começar!

Cada seção contém:
- 📖 Explicação teórica
- 💻 Exemplos práticos
- 📝 Manifests YAML
- 🔧 Comandos kubectl
- 🏋️ Exercícios hands-on

**Escolha um conceito e vamos começar!** 🚀