# AWS EKS - Elastic Kubernetes Service - Estudos 


## Módulos do Curso

| S.No | Nome do Serviço AWS |
| ---- | ---------------- |
| 1.   | Criar Cluster AWS EKS usando eksctl CLI |
| 2.   | [Fundamentos do Docker](https://github.com/stacksimplify/docker-fundamentals) |
| 3.   | [Fundamentos do Kubernetes](https://github.com/stacksimplify/kubernetes-fundamentals) |
| 4.   | Armazenamento EKS com AWS EBS CSI Driver |
| 5.   | Conceitos Importantes do Kubernetes para Deployments de Aplicações |
| 5.1  | Kubernetes - Secrets |
| 5.2  | Kubernetes - Init Containers |
| 5.3  | Kubernetes - Liveness & Readiness Probes |
| 5.4  | Kubernetes - Requests & Limits |
| 5.5  | Kubernetes - Namespaces, Limit Range e Resource Quota |
| 6.   | Armazenamento EKS com AWS RDS MySQL Database |
| 7.   | Load Balancing usando CLB & NLB |
| 7.1  | Load Balancing usando CLB - AWS Classic Load Balancer |
| 7.2  | Load Balancing usando NLB - AWS Network Load Balancer |
| 8.   | Load Balancing usando ALB - AWS Application Load Balancer |
| 8.1  | ALB Ingress Controller - Instalar |
| 8.2  | ALB Ingress - Básico |
| 8.3  | ALB Ingress - Roteamento baseado em context path |
| 8.4  | ALB Ingress - SSL |
| 8.5  | ALB Ingress - SSL Redirect HTTP para HTTPS |
| 8.6  | ALB Ingress - External DNS |
| 9.   | Deployar workloads Kubernetes no AWS Fargate Serverless |
| 9.1  | Perfis AWS Fargate - Básico |
| 9.2  | Perfis AWS Fargate - Avançado usando YAML |
| 10.  | Construir e Fazer Push de Container para AWS ECR e usar no EKS |
| 11.  | DevOps com AWS Developer Tools CodeCommit, CodeBuild e CodePipeline |
| 12.  | Deploy de Microserviços no EKS - Service Discovery |
| 13.  | Rastreamento Distribuído de Microserviços usando AWS X-Ray |
| 14.  | Deployments Canary de Microserviços |
| 15.  | EKS HPA - Horizontal Pod Autoscaler |
| 16.  | EKS VPA - Vertical Pod Autoscaler |
| 17.  | EKS CA - Cluster Autoscaler |
| 18.  | Monitoramento EKS usando CloudWatch Agent & Fluentd - Container Insights |


## Serviços AWS Abordados

| S.No | Nome do Serviço AWS |
| ---- | ---------------- |
| 1.   | AWS EKS - Elastic Kubernetes Service  |
| 2.   | AWS EBS - Elastic Block Store  |
| 3.   | AWS RDS - Relational Database Service MySQL  |
| 4.   | AWS CLB - Classic Load Balancer  |
| 5.   | AWS NLB - Network Load Balancer  |
| 6.   | AWS ALB - Application Load Balancer  |
| 7.   | AWS Fargate - Serverless  |
| 8.   | AWS ECR - Elastic Container Registry  |
| 9.   | AWS Developer Tool - CodeCommit  |
| 10.  | AWS Developer Tool - CodeBuild  |
| 11.  | AWS Developer Tool - CodePipeline  |
| 12.  | AWS X-Ray  |
| 13.  | AWS CloudWatch - Container Insights  |
| 14.  | AWS CloudWatch - Log Groups & Log Insights  |
| 15.  | AWS CloudWatch - Alarms  |
| 16.  | AWS Route53  |
| 17.  | AWS Certificate Manager  |
| 18.  | EKS CLI - eksctl  |


## Conceitos Kubernetes Abordados

| S.No | Nome do Conceito Kubernetes |
| ---- | ------------------- |
| 1.   | Arquitetura Kubernetes  |
| 2.   | Pods  |
| 3.   | ReplicaSets  |
| 4.   | Deployments  |
| 5.   | Services - Node Port Service  |
| 6.   | Services - Cluster IP Service  |
| 7.   | Services - External Name Service  |
| 8.   | Services - Ingress Service  |
| 9.   | Services - Ingress SSL & SSL Redirect  |
| 10.  | Services - Ingress & External DNS  |
| 11.  | Imperativo - com kubectl  |
| 12.  | Declarativo - Declarativo com YAML  |
| 13.  | Secrets |
| 14.  | Init Containers |
| 15.  | Liveness & Readiness Probes |
| 16.  | Requests & Limits |
| 17.  | Namespaces - Imperativo |
| 18.  | Namespaces - Limit Range |
| 19.  | Namespaces - Resource Quota |
| 20.  | Storage Classes |
| 21.  | Persistent Volumes |
| 22.  | Persistent Volume Claims |
| 23.  | Services - Load Balancers |
| 24.  | Annotations |
| 25.  | Canary Deployments |
| 26.  | HPA - Horizontal Pod Autoscaler |
| 27.  | VPA - Vertical Pod Autoscaler |
| 28.  | CA - Cluster Autoscaler |
| 29.  | DaemonSets |
| 30.  | DaemonSets - Fluentd para logs |
| 31.  | Config Maps |

## Lista de Imagens Docker no Docker Hub

| Nome da Aplicação  | Nome da Imagem Docker |
| ----------------- | ----------------- |
| Simple Nginx V1  | stacksimplify/kubenginx:1.0.0  |
| Spring Boot Hello World API  | stacksimplify/kube-helloworld:1.0.0  |
| Simple Nginx V2  | stacksimplify/kubenginx:2.0.0  |
| Simple Nginx V3  | stacksimplify/kubenginx:3.0.0  |
| Simple Nginx V4  | stacksimplify/kubenginx:4.0.0  |
| Backend Application  | stacksimplify/kube-helloworld:1.0.0  |
| Frontend Application  | stacksimplify/kube-frontend-nginx:1.0.0  |
| Kube Nginx App1  | stacksimplify/kube-nginxapp1:1.0.0  |
| Kube Nginx App2  | stacksimplify/kube-nginxapp2:1.0.0  |
| Kube Nginx App2  | stacksimplify/kube-nginxapp2:1.0.0  |
| Microserviço de Gerenciamento de Usuários com MySQLDB  | stacksimplify/kube-usermanagement-microservice:1.0.0  |
| Microserviço de Gerenciamento de Usuários com H2 DB  | stacksimplify/kube-usermanagement-microservice:2.0.0-H2DB  |
| Microserviço de Gerenciamento de Usuários com MySQL DB e AWS X-Ray  | stacksimplify/kube-usermanagement-microservice:3.0.0-AWS-XRay-MySQLDB  |
| Microserviço de Gerenciamento de Usuários com H2 DB e AWS X-Ray  | stacksimplify/kube-usermanagement-microservice:4.0.0-AWS-XRay-H2DB  |
| Microserviço de Notificação V1  | stacksimplify/kube-notifications-microservice:1.0.0  |
| Microserviço de Notificação V2  | stacksimplify/kube-notifications-microservice:2.0.0  |
| Microserviço de Notificação V1 com AWS X-Ray  | stacksimplify/kube-notifications-microservice:3.0.0-AWS-XRay  |
| Microserviço de Notificação V2 com AWS X-Ray  | stacksimplify/kube-notifications-microservice:4.0.0-AWS-XRay  |


## Lista de Imagens Docker que você constrói no AWS ECR

| Nome da Aplicação  | Nome da Imagem Docker |
| ----------------- | ----------------- |
| AWS Elastic Container Registry  | YOUR-AWS-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com/aws-ecr-kubenginx:DATETIME-REPOID  |
| Caso de Uso DevOps  | YOUR-AWS-ACCOUNT-ID.dkr.ecr.us-east-1.amazonaws.com/eks-devops-nginx:DATETIME-REPOID  |


## Aplicações de Exemplo
- Microserviço de Gerenciamento de Usuários
- Microserviço de Notificação
- Aplicações Nginx

## O que os estudantes aprenderão no seu curso?
- Você escreverá manifests kubernetes com confiança após passar pelas seções de escrita de templates ao vivo
- Você aprenderá 30+ conceitos kubernetes e usará 18 Serviços AWS em combinação com EKS
- Você aprenderá Fundamentos do Kubernetes em abordagens imperativas e declarativas
- Você aprenderá a escrever e fazer deploy de manifests k8s para conceitos de armazenamento como storage class, persistent volume claim pvc, mysql e EBS CSI Driver
- Você aprenderá a alternar do Armazenamento EBS nativo para o Banco de Dados RDS usando o serviço external name do k8s
- Você aprenderá a escrever e fazer deploy de manifests k8s de load balancer para Classic e Network load balancers
- Você aprenderá a escrever manifests k8s de ingress habilitando recursos como roteamento baseado em context path, SSL, SSL Redirect e External DNS. 
- Você aprenderá a escrever manifests k8s para perfis fargate avançados e fazer deployments de workloads em modo misto tanto em EC2 quanto em Fargate Serverless
- Você aprenderá a usar ECR - Elastic Container Registry em combinação com EKS. 
- Você implementará conceitos DevOps com AWS Code Services como CodeCommit, CodeBuild e CodePipeline
- Você implementará conceitos centrais de microserviços como Service Discovery, Rastreamento Distribuído usando X-Ray e Canary Deployments
- Você aprenderá a habilitar recursos de Autoscaling como HPA, VPA e Cluster Autoscaler
- Você aprenderá a habilitar monitoramento e logging para cluster EKS e workloads no cluster usando CloudWatch Container Insights
- Você aprenderá fundamentos do Docker implementando casos de uso como baixar imagem do Docker Hub e executar no desktop local e construir uma imagem localmente, testar e fazer push para Docker Hub.
- Você começará lentamente aprendendo Fundamentos do Docker e passará para Kubernetes. 
- Você dominará muitos comandos kubectl durante o processo

## Existem requisitos ou pré-requisitos do curso?
- Você deve ter uma conta AWS para me acompanhar nas atividades práticas.
- Você não precisa ter conhecimento básico de Docker ou kubernetes para começar este curso.  


## Quem são seus estudantes-alvo?
- Arquitetos AWS ou Sysadmins ou Desenvolvedores que estão planejando dominar Elastic Kubernetes Service (EKS) para executar aplicações no Kubernetes
- Qualquer iniciante que está interessado em aprender kubernetes na nuvem usando AWS EKS. 
- Qualquer iniciante que está interessado em aprender DevOps Kubernetes e deployments de Microserviços no Kubernetes

## Cada um dos meus cursos vem com
- Experiências de Aprendizado Práticas Incríveis Passo a Passo
- Experiência de Implementação Real
- Suporte Amigável na seção Q&A
- Garantia de Reembolso de 30 Dias "Sem Perguntas"!

