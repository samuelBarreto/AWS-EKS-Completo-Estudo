---
title: AWS Load Balancer - Roteamento Baseado em Context Path
description: Aprenda a configurar roteamento baseado em Context Path com AWS Load Balancer Controller
---

## Passo-01: Introdução

### Arquitetura da Solução

Neste tutorial, vamos implementar **roteamento baseado em context path** (caminho de contexto) usando um único Application Load Balancer (ALB) para rotear tráfego para **3 aplicações diferentes**.

### 🎯 Objetivo

Implantar 3 aplicações Nginx no Kubernetes com roteamento baseado em path:

| Path | Destino | Aplicação |
|------|---------|-----------|
| `/app1/*` | app1-nginx-nodeport-service | Nginx App1 |
| `/app2/*` | app2-nginx-nodeport-service | Nginx App2 |
| `/*` | app3-nginx-nodeport-service | Nginx App3 (padrão) |

### 📋 Arquitetura de Roteamento

```
Internet → ALB → Ingress Rules:
                   ├─ /app1/* → App1 Service → App1 Pods
                   ├─ /app2/* → App2 Service → App2 Pods
                   └─ /*      → App3 Service → App3 Pods (catch-all)
```

### 🔑 Conceitos Importantes

**Health Check Annotations:**
- Cada aplicação terá seu próprio health check path definido no **Service** (não no Ingress)
- Isso permite que o ALB verifique a saúde de cada target group independentemente
- Annotation usada: `alb.ingress.kubernetes.io/healthcheck-path:`

**Ingress Manifest:**
- Conterá apenas configurações genérica do ALB
- As regras de roteamento (rules) definirão os paths para cada serviço

---  


## Passo-02: Revisar Deployments e Services das Apps

### Diferenças entre as 3 Aplicações

As 3 aplicações são muito similares, diferindo apenas em:

1. **Nome da imagem do container** no Deployment
2. **Path do health check** no Service

### 📦 Detalhes de Cada Aplicação

#### **App1 Nginx**
**📁 Arquivo:** `01-Nginx-App1-Deployment-and-NodePortService.yml`

| Campo | Valor |
|-------|-------|
| **Image** | `1234samue/aula:kubenginx-1.0.0` |
| **Health Check Path** | `/app1/index.html` |
| **Service Name** | `app1-nginx-nodeport-service` |
| **Deployment Name** | `app1-nginx-deployment` |

**Health Check Annotation no Service:**
```yaml
annotations:
  alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html
```

#### **App2 Nginx**
**📁 Arquivo:** `02-Nginx-App2-Deployment-and-NodePortService.yml`

| Campo | Valor |
|-------|-------|
| **Image** | `1234samue/aula:kubenginx-2.0.0` |
| **Health Check Path** | `/app2/index.html` |
| **Service Name** | `app2-nginx-nodeport-service` |
| **Deployment Name** | `app2-nginx-deployment` |

**Health Check Annotation no Service:**
```yaml
annotations:
  alb.ingress.kubernetes.io/healthcheck-path: /app2/index.html
```

#### **App3 Nginx**
**📁 Arquivo:** `03-Nginx-App3-Deployment-and-NodePortService.yml`

| Campo | Valor |
|-------|-------|
| **Image** | `1234samue/aula:kubenginx-3.0.0` |
| **Health Check Path** | `/index.html` |
| **Service Name** | `app3-nginx-nodeport-service` |
| **Deployment Name** | `app3-nginx-deployment` |

**Health Check Annotation no Service:**
```yaml
annotations:
  alb.ingress.kubernetes.io/healthcheck-path: /index.html
```

### 💡 Por que o Health Check está no Service?

Quando usamos **múltiplos backends** em um único ALB:
- ✅ Cada Target Group precisa de seu próprio health check path
- ✅ Definir no **Service** permite configurações específicas por aplicação
- ✅ O Ingress fica mais limpo, com apenas configurações gerais do ALB

---



## Passo-03: Criar Manifesto Ingress com Context Path Routing

### Revisar o Manifesto Ingress

**📁 Arquivo:** `04-ALB-Ingress-ContextPath-Based-Routing.yml`

```yaml
# Referência de Annotations: https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-cpr-demo
  annotations:
    # Nome do Load Balancer
    alb.ingress.kubernetes.io/load-balancer-name: cpr-ingress
    
    # Configurações Principais do Ingress
    alb.ingress.kubernetes.io/scheme: internet-facing
    
    # Configurações de Health Check (genéricas)
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP 
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    # Nota: O health check PATH está definido em cada Service
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '15'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/success-codes: '200'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'   
spec:
  ingressClassName: my-aws-ingress-class   # Ingress Class                  
  rules:
    - http:
        paths:      
          - path: /app1
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-nodeport-service
                port: 
                  number: 80
          - path: /app2
            pathType: Prefix
            backend:
              service:
                name: app2-nginx-nodeport-service
                port: 
                  number: 80
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app3-nginx-nodeport-service
                port: 
                  number: 80
```

### 📝 Explicação das Regras de Roteamento

| Path | pathType | Backend Service | Comportamento |
|------|----------|-----------------|---------------|
| `/app1` | Prefix | app1-nginx-nodeport-service | Corresponde a `/app1`, `/app1/`, `/app1/*` |
| `/app2` | Prefix | app2-nginx-nodeport-service | Corresponde a `/app2`, `/app2/`, `/app2/*` |
| `/` | Prefix | app3-nginx-nodeport-service | Corresponde a qualquer path (catch-all) |

### ⚠️ **IMPORTANTE: Ordem das Regras**

A **ordem das regras é CRÍTICA** em roteamento baseado em path:

1. ✅ **Correto:** Paths específicos primeiro (`/app1`, `/app2`), catch-all por último (`/`)
2. ❌ **Errado:** Se `path: /` vier primeiro, capturará TODO o tráfego

**Exemplo da ordem correta:**
```
1. /app1  → App1
2. /app2  → App2
3. /      → App3 (catch-all)
```

**Por que isso importa?**
- O ALB processa regras em ordem
- O **primeiro match** vence
- Se `/` estiver primeiro, corresponderá a TODAS as requisições

### 💡 Notas Adicionais

1. **IngressClass:** Se não especificado, usará a IngressClass padrão do cluster
2. **Default IngressClass:** Aquela com annotation `ingressclass.kubernetes.io/is-default-class: "true"`
3. **Health Check Path:** Não está aqui porque cada Service define o seu próprio

---

## Passo-04: Implantar os Manifestos e Testar

```bash
# Navegar para o diretório
cd 08-NEW-ELB-Application-LoadBalancers/08-03-ALB-Ingress-ContextPath-Based-Routing

# Implantar todos os manifestos
kubectl apply -f kube-manifests/
```

### a) Verificar Recursos Kubernetes

```bash
# Listar Pods (devem ser 3 pods, um de cada app)
kubectl get pods

# Ver detalhes dos pods
kubectl get pods -o wide

# Listar Services (devem ser 3 services)
kubectl get svc

# Listar Ingress
kubectl get ingress

# Output esperado:
# NAME               CLASS                  HOSTS   ADDRESS                              PORTS   AGE
# ingress-cpr-demo   my-aws-ingress-class   *       cpr-ingress-xxxx.us-east-1.elb...   80      2m
```

### b) Descrever o Ingress e Verificar Rules

```bash
# Descrever Ingress em detalhes
kubectl describe ingress ingress-cpr-demo

# Procure pela seção "Rules:" no output
# Deve mostrar:
#   Host: *
#     http:
#       /app1   ──> app1-nginx-nodeport-service:80
#       /app2   ──> app2-nginx-nodeport-service:80
#       /       ──> app3-nginx-nodeport-service:80
```

### c) Verificar Logs do Controller

```bash
# Listar pods do AWS Load Balancer Controller
kubectl -n kube-system get pods -l app.kubernetes.io/name=aws-load-balancer-controller

# Ver logs em tempo real
kubectl -n kube-system logs -f deployment/aws-load-balancer-controller --all-containers=true

# Procure por mensagens indicando:
# - Criação do ALB "cpr-ingress"
# - Criação de 3 target groups
# - Registro dos targets
```

---

## Passo-05: Verificar no AWS Console

### 🔍 Verificar Application Load Balancer

**EC2 → Load Balancers:**

1. **Encontrar o ALB:**
   - Nome: `cpr-ingress`
   - Tipo: Application Load Balancer
   - Scheme: internet-facing

2. **Verificar Listener (Porta 80):**
   - Clique na aba **Listeners**
   - Clique em **View/edit rules**
   - Você deve ver **3 regras:**
     - Regra 1: `path is /app1*` → forward to target-group-app1
     - Regra 2: `path is /app2*` → forward to target-group-app2
     - Regra 3: `path is /*` (default) → forward to target-group-app3

3. **Verificar Target Groups (devem ser 3):**
   
   **Target Group 1 (App1):**
   - Nome: `k8s-default-app1ngin-xxxxx`
   - Protocol: HTTP
   - Port: NodePort
   - Health check path: `/app1/index.html`
   - Targets: Devem estar **healthy** ✅
   
   **Target Group 2 (App2):**
   - Nome: `k8s-default-app2ngin-xxxxx`
   - Health check path: `/app2/index.html`
   - Targets: Devem estar **healthy** ✅
   
   **Target Group 3 (App3):**
   - Nome: `k8s-default-app3ngin-xxxxx`
   - Health check path: `/index.html`
   - Targets: Devem estar **healthy** ✅

### 🌐 Acessar as Aplicações

```bash
# Obter o DNS do ALB
kubectl get ingress ingress-cpr-demo -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Acessar via browser:
# http://<ALB-DNS-URL>/app1/index.html  ← Deve mostrar App1
# http://<ALB-DNS-URL>/app2/index.html  ← Deve mostrar App2
# http://<ALB-DNS-URL>/                 ← Deve mostrar App3

# Exemplo (seu DNS será diferente):
# http://cpr-ingress-1234567890.us-east-1.elb.amazonaws.com/app1/index.html
# http://cpr-ingress-1234567890.us-east-1.elb.amazonaws.com/app2/index.html
# http://cpr-ingress-1234567890.us-east-1.elb.amazonaws.com/
```

**✅ Teste completo:**
- [ ] `/app1/index.html` retorna App1 Nginx
- [ ] `/app2/index.html` retorna App2 Nginx
- [ ] `/` (raiz) retorna App3 Nginx
- [ ] Todos os 3 target groups estão healthy

---

## Passo-06: Testar a Importância da Ordem das Regras

Vamos realizar um **experimento** para demonstrar por que a ordem das regras é crítica.

### Passo-06-01: Mover o Path Raiz (/) para o Topo

**🔧 Editar o arquivo:** `04-ALB-Ingress-ContextPath-Based-Routing.yml`

**Mudar de:**
```yaml
spec:
  ingressClassName: my-aws-ingress-class
  rules:
    - http:
        paths:      
          - path: /app1      # ✅ Específico primeiro
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-nodeport-service
                port: number: 80
          - path: /app2      # ✅ Específico primeiro
            pathType: Prefix
            backend:
              service:
                name: app2-nginx-nodeport-service
                port: number: 80
          - path: /          # ✅ Catch-all por último
            pathType: Prefix
            backend:
              service:
                name: app3-nginx-nodeport-service
                port: number: 80
```

**Para (ORDEM ERRADA):**
```yaml
spec:
  ingressClassName: my-aws-ingress-class
  rules:
    - http:
        paths:      
          - path: /          # ❌ Catch-all PRIMEIRO (ERRADO!)
            pathType: Prefix
            backend:
              service:
                name: app3-nginx-nodeport-service
                port: number: 80        
          - path: /app1      # Nunca será alcançado!
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-nodeport-service
                port: number: 80
          - path: /app2      # Nunca será alcançado!
            pathType: Prefix
            backend:
              service:
                name: app2-nginx-nodeport-service
                port: number: 80
```

### Passo-06-02: Aplicar e Testar a Ordem Errada

```bash
# Aplicar as mudanças
kubectl apply -f kube-manifests/

# Aguardar alguns segundos para o ALB atualizar
sleep 30

# Testar (abrir em janela anônima do navegador)
# http://<ALB-DNS-URL>/app1/index.html  ← ❌ DEVE FALHAR (mostrará App3)
# http://<ALB-DNS-URL>/app2/index.html  ← ❌ DEVE FALHAR (mostrará App3)
# http://<ALB-DNS-URL>/                 ← ✅ DEVE PASSAR (mostrará App3)
```

**📝 O que acontece:**
- Como `path: /` com `pathType: Prefix` está primeiro, ele corresponde a **TUDO**
- `/app1/index.html` é capturado pela regra `/` (porque `/app1` começa com `/`)
- As regras `/app1` e `/app2` nunca são alcançadas
- **TODO o tráfego** vai para App3

---

## Passo-07: Reverter para a Ordem Correta

**🔧 Editar novamente:** `04-ALB-Ingress-ContextPath-Based-Routing.yml`

**Voltar para a ordem correta:**
```yaml
spec:
  ingressClassName: my-aws-ingress-class
  rules:
    - http:
        paths:      
          - path: /app1      # ✅ Específico primeiro
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-nodeport-service
                port: number: 80
          - path: /app2      # ✅ Específico primeiro
            pathType: Prefix
            backend:
              service:
                name: app2-nginx-nodeport-service
                port: number: 80
          - path: /          # ✅ Catch-all por último
            pathType: Prefix
            backend:
              service:
                name: app3-nginx-nodeport-service
                port: number: 80
```

```bash
# Aplicar correção
kubectl apply -f kube-manifests/

# Aguardar atualização
sleep 30

# Testar novamente - agora deve funcionar!
# http://<ALB-DNS-URL>/app1/index.html  ← ✅ App1
# http://<ALB-DNS-URL>/app2/index.html  ← ✅ App2
# http://<ALB-DNS-URL>/                 ← ✅ App3
```

### 📚 Lição Aprendida

| Ordem | Resultado |
|-------|-----------|
| Paths específicos primeiro, catch-all último | ✅ Funciona corretamente |
| Catch-all primeiro, paths específicos depois | ❌ Catch-all captura tudo |

**Regra de ouro:**
> Sempre coloque o path `/` (catch-all) como a **última regra** em roteamento baseado em path!

---

## Passo-08: Limpar Recursos

```bash
# Deletar todos os recursos
kubectl delete -f kube-manifests/

# Verificar se o Ingress foi deletado
kubectl get ingress

# Verificar se os pods foram deletados
kubectl get pods

# Verificar se os services foram deletados
kubectl get svc
```

**🔍 Verificar no AWS Console:**
```bash
# EC2 → Load Balancers
# O ALB "cpr-ingress" deve ser deletado automaticamente (pode levar 2-5 minutos)

# EC2 → Target Groups
# Os 3 target groups também devem ser deletados
```

⚠️ **LEMBRETE:** Sempre verifique no Console AWS se os recursos foram realmente deletados para evitar custos desnecessários!

---

## 🎯 Resumo do Aprendizado

### ✅ O que aprendemos:

1. **Context Path Routing:** Rotear múltiplas aplicações com um único ALB
2. **Health Checks:** Definir health check paths específicos por aplicação no Service
3. **Ordem das Regras:** Importância crítica da ordem em path-based routing
4. **Prefix Path Type:** Como funciona o matching com `pathType: Prefix`
5. **Target Groups:** Um ALB criando múltiplos target groups automaticamente

### 💡 Best Practices:

| Prática | Razão |
|---------|-------|
| Paths específicos primeiro | Evita que catch-all capture tudo |
| Health check no Service | Permite configuração específica por app |
| Testar ordem das regras | Validar que o roteamento está correto |
| Sempre limpar recursos | Evitar custos com ALB ocioso |

### 🚀 Próximos Passos:

1. **Host-based routing** - Rotear baseado em domínio
2. **SSL/TLS** - Adicionar HTTPS ao ALB
3. **Autenticação** - Integrar com Cognito ou OIDC
4. **Múltiplos namespaces** - Rotear apps de diferentes namespaces

---

## 📚 Referências

- [AWS Load Balancer Controller - Ingress Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/)
- [Kubernetes Ingress - Path Types](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)
- [AWS ALB - Listener Rules](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-update-rules.html)
