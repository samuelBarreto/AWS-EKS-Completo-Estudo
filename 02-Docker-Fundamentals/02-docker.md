---
layout: page
title: "Docker Fundamentals"
description: "Conceitos básicos do Docker - Containers, Images, Registry"
permalink: /02-docker/
---

# 🐳 Docker Fundamentals

O Docker é a base para entender Kubernetes. Este módulo cobre todos os conceitos essenciais do Docker que você precisa saber.

## 📚 **Conteúdo do Módulo**

### 📖 **02-01 - Docker Introduction**
- O que são containers
- Docker vs VMs
- Arquitetura do Docker
- Casos de uso

### ⚙️ **02-02 - Docker Installation**
- Instalação no Windows
- Instalação no Linux
- Instalação no macOS
- Verificação da instalação

### 📥 **02-03 - Pull from DockerHub and Run**
- Docker Hub
- Pull de imagens
- Execução de containers
- Comandos básicos

### 🔨 **02-04 - Build and Push Images**
- Dockerfile
- Build de imagens personalizadas
- Teste local
- Push para Docker Hub

### 🛠️ **02-05 - Essential Docker Commands**
- Comandos de container
- Comandos de imagem
- Comandos de rede
- Comandos de volume

## 🎯 **Objetivos de Aprendizado**

Ao final deste módulo, você será capaz de:

✅ **Entender containers** e sua diferença para VMs  
✅ **Instalar Docker** em diferentes sistemas operacionais  
✅ **Baixar e executar** imagens do Docker Hub  
✅ **Criar imagens personalizadas** com Dockerfile  
✅ **Fazer push** de imagens para registries  
✅ **Usar comandos essenciais** do Docker  

## 🛠️ **Recursos Práticos**

### **Imagens Docker**
- Nginx básico
- Aplicações web simples
- Imagens personalizadas
- Microserviços

### **Dockerfiles de Exemplo**
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### **Comandos Essenciais**
```bash
# Pull e run
docker pull nginx
docker run -d -p 80:80 nginx

# Build e push
docker build -t minha-app .
docker push meu-usuario/minha-app
```

## 📖 **Artigos Relacionados**

- [Docker vs Kubernetes: Quando usar cada um?](#)
- [Container Best Practices](#)
- [Docker Security Guidelines](#)

## 🚀 **Próximo Módulo**

Após dominar Docker, continue para:
**[03 - Kubernetes Fundamentals](/03-kubernetes/)** - Arquitetura e conceitos básicos do K8s

---

**💡 Dica:** Docker é a base do Kubernetes. Certifique-se de entender bem os containers antes de prosseguir para K8s!
