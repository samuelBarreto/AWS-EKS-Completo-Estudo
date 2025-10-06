# Kubernetes - Namespaces

## Visão Geral
Os Namespaces no Kubernetes fornecem um mecanismo para isolar grupos de recursos dentro de um único cluster. Eles são úteis para organizar recursos e fornecer isolamento entre diferentes equipes, projetos ou ambientes.

## 📋 Conteúdo do Módulo

| Nº | Tópico | Descrição | Status |
|----|--------|-----------|--------|
| 1. | **Namespaces Imperativos** | Criação e gerenciamento usando kubectl | ✅ |
| 2. | **Namespaces Declarativos** | Criação usando YAML e LimitRange | ✅ |
| 3. | **Resource Quotas** | Controle de recursos com ResourceQuota | ✅ |

## 🎯 Objetivos de Aprendizado

Ao final deste módulo, você será capaz de:

- **Criar e gerenciar** Namespaces usando kubectl
- **Configurar LimitRanges** para controlar recursos por Namespace
- **Implementar ResourceQuotas** para limitar uso de recursos
- **Organizar recursos** em Namespaces lógicos
- **Aplicar políticas** de isolamento e segurança

## 🚀 Estrutura do Módulo

### **05-05-01: Namespaces Imperativos**
- Criação de Namespaces usando kubectl
- Gerenciamento básico de Namespaces
- Comandos essenciais
- Boas práticas

### **05-05-02: Namespaces com LimitRange**
- Criação declarativa de Namespaces
- Configuração de LimitRange
- Controle de recursos por container
- Exemplos práticos

### **05-05-03: Namespaces com ResourceQuota**
- Implementação de ResourceQuotas
- Controle de recursos por Namespace
- Políticas de isolamento
- Monitoramento de quotas

## 🛠️ Pré-requisitos

- Cluster Kubernetes funcionando
- kubectl configurado
- Conhecimento básico de YAML
- Conceitos de Pods, Deployments e Services

## 📚 Conceitos Importantes

### **Namespaces Padrão**
- `default` - Namespace padrão para recursos não especificados
- `kube-system` - Recursos do sistema Kubernetes
- `kube-public` - Recursos acessíveis publicamente
- `kube-node-lease` - Informações de lease dos nós

### **Isolamento de Recursos**
- Pods em Namespaces diferentes não podem se comunicar por padrão
- Services são isolados por Namespace
- Secrets e ConfigMaps são isolados por Namespace
- ResourceQuotas limitam recursos por Namespace

### **Comandos Essenciais**
```bash
# Listar Namespaces
kubectl get namespaces

# Criar Namespace
kubectl create namespace <nome>

# Deletar Namespace
kubectl delete namespace <nome>

# Ver recursos em um Namespace
kubectl get all -n <namespace>

# Mudar contexto para um Namespace
kubectl config set-context --current --namespace=<namespace>
```

## 🎉 Vamos Começar!

Cada seção contém:
- 📖 Explicação teórica
- 💻 Exemplos práticos
- 📝 Manifests YAML
- 🔧 Comandos kubectl
- 🏋️ Exercícios hands-on

**Escolha uma seção e vamos começar!** 🚀