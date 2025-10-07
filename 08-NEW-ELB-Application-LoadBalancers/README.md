# Load Balancing de Workloads no EKS usando AWS Application Load Balancer

## Tópicos
- Vamos explorar este tópico de forma muito extensa, passo a passo e módulo por módulo
- Abaixo está a lista de tópicos cobertos na perspectiva do AWS ALB Ingress


| N°  | Nome do Tópico                                                 |
| --  | -------------------------------------------------------------- |
| 1.  | Instalação do AWS Load Balancer Controller                     |
| 2.  | ALB Ingress - Básico                                           |
| 3.  | ALB Ingress - Roteamento baseado em Context Path               |
| 4.  | ALB Ingress - SSL                                              |
| 5.  | ALB Ingress - Redirecionamento SSL (HTTP para HTTPS)           |
| 6.  | ALB Ingress - External DNS                                     |
| 7.  | ALB Ingress - External DNS para k8s Ingress                    |
| 8.  | ALB Ingress - External DNS para k8s Service                    |
| 9.  | ALB Ingress - Roteamento baseado em Virtual Host (Name based)  |
| 10. | ALB Ingress - SSL Discovery - Host                             |
| 11. | ALB Ingress - SSL Discovery - TLS                              |
| 12. | ALB Ingress - Groups                                           |
| 13. | ALB Ingress - Target Type - IP Mode                            |
| 14. | ALB Ingress - Internal Load Balancer                           |


## Referências
- Recomendado consultar todos os links abaixo para entendimento adicional

### AWS Load Balancer Controller
- [Documentação do AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/)


### Referência de Annotations do AWS ALB Ingress
- https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/ingress/annotations/

### Começando com eksctl
- https://eksctl.io/introduction/#getting-started

### External DNS
- https://github.com/kubernetes-sigs/external-dns
- https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/alb-ingress.md
- https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md

## O que é Application Load Balancer (ALB)?

### Características Principais
- **Camada 7** (Aplicação) - HTTP/HTTPS
- Roteamento inteligente baseado em conteúdo
- Suporte a múltiplas aplicações em um único load balancer
- Integração nativa com Kubernetes via Ingress
- WebSockets e HTTP/2
- Integração com AWS WAF (Web Application Firewall)

### ALB vs Outros Load Balancers

| Característica | CLB | NLB | ALB |
|----------------|-----|-----|-----|
| **Camada OSI** | 4 e 7 | 4 | 7 |
| **Protocolos** | HTTP/HTTPS/TCP | TCP/UDP/TLS | HTTP/HTTPS |
| **Roteamento** | Básico | IP/Porta | Path, Host, Headers |
| **Containers** | Não | Sim | Sim (nativo) |
| **SSL/TLS** | Básico | Passthrough | Terminação + SNI |
| **WebSockets** | Não | Sim | Sim |
| **Custo** | Baixo | Médio | Médio |

### Casos de Uso do ALB
- ✅ Aplicações web modernas
- ✅ Microserviços
- ✅ APIs REST
- ✅ Aplicações containerizadas (EKS, ECS)
- ✅ Roteamento baseado em URL/Host
- ✅ Múltiplas aplicações com um único endpoint

## Como funciona ALB Ingress no EKS?

### Fluxo de Trabalho
1. **Você cria** um recurso Kubernetes Ingress
2. **AWS Load Balancer Controller** detecta o Ingress
3. **Controller provisiona** automaticamente um ALB na AWS
4. **ALB roteia** o tráfego para os pods do Kubernetes
5. **External DNS** (opcional) cria registros DNS automaticamente

### Componentes
- **Ingress Resource**: Define regras de roteamento
- **AWS Load Balancer Controller**: Gerencia ALBs
- **Target Groups**: Grupos de pods/nodes
- **External DNS**: Gerenciamento automático de DNS