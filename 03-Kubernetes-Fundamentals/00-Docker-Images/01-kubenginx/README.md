# 🐳 Docker Images para Context Path Routing

Este diretório contém os Dockerfiles para criar 3 imagens customizadas do Nginx para demonstrar **Context Path Based Routing** no Kubernetes com AWS Load Balancer Controller.

## 📋 Estrutura das Imagens

### App1 - `/app1/index.html`
- **Cor de fundo:** Vermelho claro
- **Path:** `/app1/index.html`
- **Tag:** `kubenginx-app1-1.0.0`

### App2 - `/app2/index.html`
- **Cor de fundo:** Verde claro
- **Path:** `/app2/index.html`
- **Tag:** `kubenginx-app2-1.0.0`

### App3 - `/index.html` (raiz)
- **Cor de fundo:** Azul claro
- **Path:** `/index.html`
- **Tag:** `kubenginx-app3-1.0.0`

## 🚀 Como Usar

### Opção 1: Usar script automatizado (Recomendado)

**No Windows PowerShell:**
```powershell
cd 03-Kubernetes-Fundamentals\00-Docker-Images\01-kubenginx
.\build-and-push.ps1
```

**No Linux/Mac:**
```bash
cd 03-Kubernetes-Fundamentals/00-Docker-Images/01-kubenginx
chmod +x build-and-push.sh
./build-and-push.sh
```

### Opção 2: Build manual

```bash
# Navegar para o diretório
cd 03-Kubernetes-Fundamentals/00-Docker-Images/01-kubenginx

# Build App1
cd app1
docker build -t 1234samue/aula:kubenginx-app1-1.0.0 .
docker push 1234samue/aula:kubenginx-app1-1.0.0
cd ..

# Build App2
cd app2
docker build -t 1234samue/aula:kubenginx-app2-1.0.0 .
docker push 1234samue/aula:kubenginx-app2-1.0.0
cd ..

# Build App3
cd app3
docker build -t 1234samue/aula:kubenginx-app3-1.0.0 .
docker push 1234samue/aula:kubenginx-app3-1.0.0
cd ..
```

## 🔧 Atualizar Manifestos Kubernetes

Após criar as imagens, atualize os manifestos:

**`08-03-ALB-Ingress-ContextPath-Based-Routing/kube-manifests/01-Nginx-App1-Deployment-and-NodePortService.yml`:**
```yaml
spec:
  containers:
    - name: app1-nginx
      image: 1234samue/aula:kubenginx-app1-1.0.0
```

**`02-Nginx-App2-Deployment-and-NodePortService.yml`:**
```yaml
spec:
  containers:
    - name: app2-nginx
      image: 1234samue/aula:kubenginx-app2-1.0.0
```

**`03-Nginx-App3-Deployment-and-NodePortService.yml`:**
```yaml
spec:
  containers:
    - name: app3-nginx
      image: 1234samue/aula:kubenginx-app3-1.0.0
```

## ✅ Testar Localmente

```bash
# Testar App1
docker run -d -p 8081:80 1234samue/aula:kubenginx-app1-1.0.0
curl http://localhost:8081/app1/index.html

# Testar App2
docker run -d -p 8082:80 1234samue/aula:kubenginx-app2-1.0.0
curl http://localhost:8082/app2/index.html

# Testar App3
docker run -d -p 8083:80 1234samue/aula:kubenginx-app3-1.0.0
curl http://localhost:8083/index.html
```

## 📝 Notas

- Certifique-se de estar logado no Docker Hub: `docker login`
- Substitua `1234samue` pelo seu username do Docker Hub
- As imagens usam cores diferentes para fácil identificação visual

