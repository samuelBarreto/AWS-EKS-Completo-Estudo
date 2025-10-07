---
title: AWS Load Balancer Controller - Fundamentos de Ingress
description: Aprenda os fundamentos do AWS Load Balancer Controller com Ingress no EKS
---

## Passo-01: Introdução

Neste tutorial, vamos aprender os conceitos fundamentais de **Ingress** no Kubernetes usando o **AWS Load Balancer Controller**.

### Arquitetura da Aplicação

Vamos implantar uma aplicação simples Nginx (App1) e expô-la através de um **Application Load Balancer (ALB)** usando um recurso **Ingress**.

### Conceitos Importantes de Ingress

**📚 Recursos que vamos explorar:**
- **[Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/)** - Configurações do ALB via annotations
- **[ingressClassName](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/ingress_class/)** - Especifica qual controller processa o Ingress
- **defaultBackend** - Serviço padrão quando nenhuma regra corresponde
- **rules** - Regras de roteamento baseadas em path/host

### Dois Cenários Práticos

1. **Cenário 1:** Ingress com `defaultBackend` (mais simples)
2. **Cenário 2:** Ingress com `rules` (mais flexível e recomendado)

---

## 📦 Cenário 1: Ingress com Default Backend

### Passo-02: Revisar Deployment da App1

**📁 Arquivo:** `01-kube-manifests-default-backend/01-Nginx-App1-Deployment-and-NodePortService.yml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1-nginx-deployment
  labels:
    app: app1-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app1-nginx
  template:
    metadata:
      labels:
        app: app1-nginx
    spec:
      containers:
        - name: app1-nginx
          image: 1234samue/aula:kubenginx-1.0.0
          ports:
            - containerPort: 80
```

**📝 Explicação:**
- **Deployment** básico do Kubernetes
- **1 réplica** do pod Nginx
- Imagem customizada com aplicação de exemplo
- **Porta 80** exposta no container

### Passo-03: Revisar NodePort Service da App1

**📁 Arquivo:** `01-kube-manifests-default-backend/01-Nginx-App1-Deployment-and-NodePortService.yml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app1-nginx-nodeport-service
  labels:
    app: app1-nginx
  annotations:
    # Nota: Adicione health check path annotations no nível do service
    # se planejar usar múltiplos targets em um load balancer
    # alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html
spec:
  type: NodePort
  selector:
    app: app1-nginx
  ports:
    - port: 80
      targetPort: 80  
```

**📝 Explicação:**
- **Service do tipo NodePort** - Expõe os pods em uma porta dos nós do cluster
- **Selector** - Seleciona pods com label `app: app1-nginx`
- **Porta 80** - Porta do service que mapeia para a porta 80 dos pods

### Passo-04: Revisar Manifesto do Ingress com Default Backend

**📁 Arquivo:** `01-kube-manifests-default-backend/02-ALB-Ingress-Basic.yml`

**🔗 Referência:** [Annotations do ALB Ingress Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/)

```yaml
# Referência de Annotations: https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginxapp1
  labels:
    app: app1-nginx
  annotations:
    # Configurações Principais do Ingress
    alb.ingress.kubernetes.io/scheme: internet-facing
    
    # Configurações de Health Check
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP 
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html    
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '15'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/success-codes: '200'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'
spec:
  ingressClassName: my-aws-ingress-class # Ingress Class
  defaultBackend:
    service:
      name: app1-nginx-nodeport-service
      port:
        number: 80                    
```

**📝 Explicação das Annotations:**

| Annotation | Descrição |
|------------|-----------|
| `scheme: internet-facing` | ALB acessível pela internet (use `internal` para ALB privado) |
| `healthcheck-protocol: HTTP` | Protocolo do health check |
| `healthcheck-port: traffic-port` | Usa a mesma porta do tráfego para health check |
| `healthcheck-path: /app1/index.html` | Path específico para verificar a saúde da aplicação |
| `healthcheck-interval-seconds: '15'` | Intervalo entre health checks (15 segundos) |
| `healthcheck-timeout-seconds: '5'` | Timeout para resposta do health check (5 segundos) |
| `success-codes: '200'` | Código HTTP considerado como sucesso |
| `healthy-threshold-count: '2'` | Número de checks consecutivos bem-sucedidos para considerar saudável |
| `unhealthy-threshold-count: '2'` | Número de checks consecutivos falhados para considerar não-saudável |

**💡 Notas Importantes:**
- ❌ `kubernetes.io/ingress.class: "alb"` - Notação antiga (ainda funciona, mas não recomendada)
- ✅ `ingressClassName: my-aws-ingress-class` - Notação moderna (recomendada)
- 🎯 `defaultBackend` - Roteia TODO o tráfego para um único serviço (sem regras de path)

### Passo-05: Implantar e Verificar (Cenário 1 - Default Backend)

```bash
# Navegar para o diretório
cd 08-NEW-ELB-Application-LoadBalancers/08-02-ALB-Ingress-Basics

# Implantar os manifestos
kubectl apply -f 01-kube-manifests-default-backend/
```

**a) Verificar Deployment e Pods:**
```bash
# Verificar Deployment
kubectl get deploy

# Verificar Pods (devem estar Running)
kubectl get pods

# Ver detalhes do deployment
kubectl describe deploy app1-nginx-deployment
```

**b) Verificar Ingress:**
```bash
# Listar Ingress (anotar o campo ADDRESS)
kubectl get ingress

# Output esperado:
# NAME                 CLASS                  HOSTS   ADDRESS                                                  PORTS   AGE
# ingress-nginxapp1    my-aws-ingress-class   *       k8s-default-ingressn-xxxxx.us-east-1.elb.amazonaws.com  80      2m

# Descrever Ingress em detalhes
kubectl describe ingress ingress-nginxapp1
```

**📝 Observações importantes:**
- O campo `ADDRESS` mostrará o DNS do ALB criado automaticamente
- Pode levar 2-3 minutos para o ALB ser provisionado e estar disponível

**c) Verificar Service:**
```bash
# Listar Services
kubectl get svc

# Verificar service específico
kubectl describe svc app1-nginx-nodeport-service
```

**d) Verificar no AWS Console:**

🔍 **EC2 → Load Balancers:**
1. Procure pelo ALB criado (nome começará com `k8s-`)
2. Verifique a aba **Listeners** → Porta 80
3. Verifique as **Rules** dentro do listener
4. Clique em **Target Groups** e verifique os targets registrados
5. Confirme que os targets estão **healthy**

**e) Acessar a Aplicação:**
```bash
# Obter o DNS do ALB
kubectl get ingress ingress-nginxapp1 -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Acessar via Browser:
# http://<ALB-DNS-URL>
# http://<ALB-DNS-URL>/app1/index.html

# Exemplo:
# http://k8s-default-ingressn-xxxxx.us-east-1.elb.amazonaws.com
# http://k8s-default-ingressn-xxxxx.us-east-1.elb.amazonaws.com/app1/index.html
```

**f) Verificar Logs do Controller (Troubleshooting):**
```bash
# Listar pods do controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Ver logs do controller
kubectl -n kube-system logs -f deployment/aws-load-balancer-controller --all-containers=true

# Ou logs de um pod específico
kubectl -n kube-system logs -f <POD-NAME>
```

**✅ Checklist de Verificação:**
- [ ] Deployment criado e pods Running
- [ ] Service criado e funcionando
- [ ] Ingress criado com ADDRESS preenchido
- [ ] ALB criado no AWS Console
- [ ] Target Group com targets healthy
- [ ] Aplicação acessível via browser

### Passo-06: Limpar Recursos (Cenário 1)

```bash
# Deletar todos os recursos do Cenário 1
kubectl delete -f 01-kube-manifests-default-backend/

# Verificar se o Ingress foi deletado
kubectl get ingress

# Verificar se o ALB foi deletado no AWS Console
# EC2 → Load Balancers (pode levar alguns minutos)
```

⚠️ **IMPORTANTE:** Sempre delete os recursos Ingress quando não estiver usando! ALBs ociosos geram custos significativos na AWS.

---

## 📦 Cenário 2: Ingress com Rules (Regras)

### Passo-07: Entender Ingress Path Types

Antes de revisar o manifesto, é importante entender os tipos de correspondência de path (Path Types):

**📚 Referências:**
- [Ingress Path Types - Kubernetes Docs](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)
- [Melhorias em Path Matching](https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/#better-path-matching-with-path-types)
- [Exemplo de Ingress Rule](https://kubernetes.io/docs/concepts/services-networking/ingress/#the-ingress-resource)

#### Tipos de Path Types:

| Path Type                           | Descrição                                                                                       | Exemplo                              |
|-------------------------------------|------------------------------------------------------------------------------------------------ |------------------------------------- |
| **ImplementationSpecific** (padrão) | Matching depende da implementação do controller. Pode ser tratado como `Prefix` ou `Exact`      | Depende do controller                |
| **Exact**                           | Corresponde ao path exatamente, com case-sensitive                                              | `/app1` corresponde apenas a `/app1` |
| **Prefix**                          | Corresponde baseado em prefixo do path, dividido por `/`. Case-sensitive, elemento por elemento | `/app1` corresponde a `/app1`, `/app1/`, `/app1/page` |

**💡 Recomendação:** Use `Prefix` para a maioria dos casos, pois é mais flexível e permite roteamento hierárquico.

### Passo-08: Revisar Manifesto Ingress com Rules

**📁 Arquivo:** `02-kube-manifests-rules/02-ALB-Ingress-Basic.yml`
```yaml
# Referência de Annotations: https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-nginxapp1
  labels:
    app: app1-nginx
  annotations:
    # Nome do Load Balancer (customizado)
    alb.ingress.kubernetes.io/load-balancer-name: app1ingressrules
    
    # Configurações Principais
    alb.ingress.kubernetes.io/scheme: internet-facing
    
    # Configurações de Health Check
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP 
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/healthcheck-path: /app1/index.html    
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '15'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/success-codes: '200'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'
spec:
  ingressClassName: my-aws-ingress-class # Ingress Class
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-nodeport-service
                port: 
                  number: 80
```

**🔍 Diferenças entre Default Backend e Rules:**

| Característica      | Default Backend              | Rules                           |
|---------------------|------------------------------|---------------------------------|
| **Flexibilidade**   | Baixa - um único serviço     | Alta - múltiplos serviços/paths |
| **Roteamento**      | Todo tráfego para um serviço | Baseado em paths ou hosts       |
| **Uso recomendado** | Apps simples, testes         | Produção, múltiplas apps        |
| **Path matching**   | Não aplicável                | Suporta Exact, Prefix, etc      |

**📝 Explicação do Manifesto:**

- **load-balancer-name:** Nome customizado para o ALB (facilita identificação no Console)
- **rules:** Define regras de roteamento baseadas em HTTP
- **path: /** - Corresponde a todas as requisições que começam com `/`
- **pathType: Prefix** - Usa matching por prefixo (mais flexível)
- **backend:** Define para qual serviço o tráfego será enviado

**💡 Notas:**
1. Se `ingressClassName` não for especificado, usará a IngressClass padrão do cluster
2. IngressClass padrão é aquela com annotation `ingressclass.kubernetes.io/is-default-class: "true"`
3. Com `rules`, é possível adicionar múltiplos paths e serviços no mesmo Ingress

### Passo-09: Implantar e Verificar (Cenário 2 - Rules)

```bash
# Navegar para o diretório
cd 08-NEW-ELB-Application-LoadBalancers/08-02-ALB-Ingress-Basics

# Implantar os manifestos com rules
kubectl apply -f 02-kube-manifests-rules/
```

**a) Verificar Deployment e Pods:**
```bash
# Verificar Deployment
kubectl get deploy

# Verificar Pods (devem estar Running)
kubectl get pods -o wide

# Ver detalhes
kubectl describe deploy app1-nginx-deployment
```

**b) Verificar Ingress:**
```bash
# Listar Ingress
kubectl get ingress

# Output esperado:
# NAME                 CLASS                  HOSTS   ADDRESS                                         PORTS   AGE
# ingress-nginxapp1    my-aws-ingress-class   *       app1ingressrules-xxxxx.us-east-1.elb.amazonaws.com   80      2m

# Descrever Ingress em detalhes
kubectl describe ingress ingress-nginxapp1
```

**📝 Observações:**
- O campo `ADDRESS` mostrará o DNS do ALB com o nome customizado `app1ingressrules`
- Revise a seção **Rules** no output do `describe` - deve mostrar o path `/` roteando para o serviço

**c) Verificar Service:**
```bash
# Listar Services
kubectl get svc

# Ver detalhes do service
kubectl describe svc app1-nginx-nodeport-service
```

**d) Verificar no AWS Console:**

🔍 **EC2 → Load Balancers:**
1. Procure pelo ALB com nome `app1ingressrules`
2. Verifique **Listeners** → Regra na porta 80
3. Clique em **View/edit rules** do listener
   - Deve haver uma regra com condition `path is /`
   - Action deve ser `forward to target-group`
4. Verifique **Target Groups**
   - Targets devem estar **healthy**
   - Health checks devem estar passando

**e) Acessar a Aplicação:**
```bash
# Obter o DNS do ALB
kubectl get ingress ingress-nginxapp1 -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Acessar via Browser:
# http://<ALB-DNS-URL>
# http://<ALB-DNS-URL>/app1/index.html

# Exemplo (seu DNS será diferente):
# http://app1ingressrules-xxxxx.us-east-1.elb.amazonaws.com
# http://app1ingressrules-xxxxx.us-east-1.elb.amazonaws.com/app1/index.html
```

**f) Verificar Logs do Controller:**
```bash
# Ver logs do AWS Load Balancer Controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Logs em tempo real
kubectl -n kube-system logs -f deployment/aws-load-balancer-controller --all-containers=true

# Procure por linhas indicando:
# - Criação do ALB
# - Configuração de target groups
# - Registro de targets
```

**✅ Checklist de Verificação:**
- [ ] Deployment e pods Running
- [ ] Service criado corretamente
- [ ] Ingress com ADDRESS populado
- [ ] ALB com nome "app1ingressrules" no Console
- [ ] Listener com regra de path
- [ ] Target Group com targets healthy
- [ ] Aplicação acessível via browser em `/` e `/app1/index.html`

### Passo-10: Limpar Recursos (Cenário 2)

```bash
# Deletar todos os recursos do Cenário 2
kubectl delete -f 02-kube-manifests-rules/

# Verificar se o Ingress foi deletado
kubectl get ingress

# IMPORTANTE: Aguarde e verifique se o ALB foi deletado
# Isso pode levar 2-5 minutos
```

**🔍 Verificar no AWS Console:**
```bash
# AWS Console → EC2 → Load Balancers
# O ALB "app1ingressrules" deve ser deletado automaticamente
```

⚠️ **ATENÇÃO - CUSTOS:**
- **ALBs geram custos mesmo quando ociosos!**
- Sempre delete recursos Ingress após testes
- Verifique no Console AWS se o ALB foi realmente deletado
- Um ALB pode custar ~$16-20 USD por mês se deixado ocioso

---

## 📊 Comparação: Default Backend vs Rules

| Aspecto                | Default Backend | Rules          |
|------------------------|-----------------|----------------|
| **Complexidade**       | ⭐ Simples      | ⭐⭐ Moderada |
| **Flexibilidade**      | Baixa            | Alta          |
| **Múltiplos services** | ❌ Não           | ✅ Sim        |
| **Path routing**       | ❌ Não           | ✅ Sim        |
| **Host routing**       | ❌ Não           | ✅ Sim        |
| **Uso recomendado**    | Testes, demos     | Produção      |
| **Performance**        | Mesma             | Mesma         |

---

## 🎯 Resumo e Próximos Passos

### O que aprendemos:

✅ **Conceitos:**
- Diferença entre `defaultBackend` e `rules`
- Path Types (Exact, Prefix, ImplementationSpecific)
- Annotations do AWS Load Balancer Controller
- IngressClass e como funciona

✅ **Prática:**
- Criar Deployment e Service
- Configurar Ingress com ALB
- Verificar recursos no Kubernetes e AWS
- Acessar aplicação via ALB
- Limpar recursos adequadamente

### Próximos Passos:

1. **Ingress com múltiplos paths** - Rotear diferentes paths para diferentes serviços
2. **Ingress com SSL/TLS** - Configurar certificados HTTPS
3. **Ingress com host-based routing** - Rotear baseado em domínio
4. **Ingress avançado** - Autenticação, redirecionamentos, rewrites

---

## 📚 Recursos Adicionais

- [AWS Load Balancer Controller - Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/)
- [Kubernetes Ingress Docs](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [AWS ALB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [Ingress Path Types](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)