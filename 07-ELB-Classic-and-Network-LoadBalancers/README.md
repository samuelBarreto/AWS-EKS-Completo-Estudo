# AWS Elastic Load Balancers

## Tipos de Load Balancer da AWS

### 1. Classic Load Balancer (CLB)
- **Camada**: 4 (Transporte) e 7 (Aplicação)
- **Protocolos**: HTTP, HTTPS, TCP, SSL/TLS
- **Características**:
  - Primeira geração de load balancers da AWS
  - Suporte a EC2-Classic e VPC
  - Health checks básicos
  - Sticky sessions
- **Uso**: Aplicações legadas, casos simples
- **Limitações**: Menos recursos avançados, não suporta containers nativamente

### 2. Network Load Balancer (NLB)
- **Camada**: 4 (Transporte)
- **Protocolos**: TCP, UDP, TLS
- **Características**:
  - Ultra-alta performance (milhões de requests/segundo)
  - Baixa latência
  - Preserva IP de origem
  - Suporte a IP estático
  - Health checks avançados
- **Uso**: Aplicações de alta performance, microserviços, gaming
- **Vantagens**: Ideal para tráfego não-HTTP, alta disponibilidade

### 3. Application Load Balancer (ALB)
- **Camada**: 7 (Aplicação)
- **Protocolos**: HTTP, HTTPS, HTTP/2, WebSocket
- **Características**:
  - Roteamento baseado em conteúdo
  - Suporte a containers (ECS, EKS)
  - WebSockets e HTTP/2
  - Integração com AWS WAF
  - Health checks avançados
- **Uso**: Aplicações web modernas, microserviços, APIs
- **Vantagens**: Roteamento inteligente, integração com Kubernetes Ingress

## Comparação Rápida

| Característica | CLB | NLB | ALB |
|----------------|-----|-----|-----|
| **Performance** | Baixa | Ultra-alta | Alta |
| **Latência** | Alta | Baixa | Média |
| **Protocolos** | HTTP/HTTPS/TCP | TCP/UDP/TLS | HTTP/HTTPS |
| **Roteamento** | Básico | IP/Porta | Baseado em conteúdo |
| **Containers** | Não | Sim | Sim (nativo) |
| **Custo** | Baixo | Médio | Médio |

## Integração com Kubernetes

### Network Load Balancer + EKS
- **Service Type**: LoadBalancer
- **Uso**: Exposição de serviços internos
- **Vantagens**: IP estático, alta performance

### Application Load Balancer + EKS
- **Ingress Controller**: AWS Load Balancer Controller
- **Uso**: Roteamento HTTP/HTTPS, SSL termination
- **Vantagens**: Roteamento avançado, integração com AWS

## Próximos Passos
1. **07-01**: Criar EKS Private NodeGroup
2. **07-02**: Configurar Classic Load Balancer
3. **07-03**: Configurar Network Load Balancer
4. **07-04**: Configurar Application Load Balancer (Ingress)