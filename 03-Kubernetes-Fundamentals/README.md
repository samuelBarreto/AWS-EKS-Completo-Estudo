# Kubernetes Fundamentals
# Fundamentos do Kubernetes

## Conteúdo

| Nº   | Conteúdo do Curso         |
| ---- | ------------------------- |
| 1.   | Arquitetura do Kubernetes |
| 2.   | Pods com kubectl          |
| 3.   | ReplicaSets com kubectl   |
| 4.   | Deployments com kubectl   |
| 5.   | Services com kubectl      |
| 6.   | Fundamentos do YAML       |
| 7.   | Pods com YAML             |
| 8.   | ReplicaSets com YAML      |
| 9.   | Deployments com YAML      |
| 10.  | Services com YAML         |

## Abordagem Imperativa & Declarativa
- Pods
- ReplicaSets
- Deployments
- Services

## Lista de Imagens Docker

| Nome da Aplicação           | Nome da Imagem Docker          |
| --------------------------- | ------------------------------ |
| Nginx Simples V1            | aula/kubenginx:1.0.0           |
| API Spring Boot Hello World | aula/kube-helloworld:1.0.0     |
| Nginx Simples V2            | aula/kubenginx:2.0.0           |
| Nginx Simples V3            | aula/kubenginx:3.0.0           |
| Nginx Simples V4            | aula/kubenginx:4.0.0           |
| Aplicação Backend           | aula/kube-helloworld:1.0.0     |
| Aplicação Frontend          | aula/kube-frontend-nginx:1.0.0 |

## Fundamentos do Kubernetes - Passo a Passo

### EKS - Instalar AWS CLI, kubectl CLI e eksctl CLI
- **Passo-01:** Introdução às CLIs
- **Passo-02:** Instalar AWS CLI
- **Passo-03:** Instalar kubectl CLI
- **Passo-04:** Instalar eksctl CLI

### EKS - Criar Cluster usando eksctl
- **Passo-01:** Introdução ao Cluster EKS
- **Passo-02:** Criar Cluster EKS
- **Passo-03:** Criar IAM OIDC Provider e Node Group Gerenciado em Subnets Públicas
- **Passo-04:** Verificar Node Groups do Cluster EKS

### Observação sobre Preço do Cluster EKS e Exclusão
- **Passo-01:** Observação sobre Preço do Cluster EKS
- **Passo-02:** Excluir Node Group do Cluster EKS

### Arquitetura do Kubernetes
- **Passo-01:** Arquitetura do Kubernetes
- **Passo-02:** Kubernetes vs Arquitetura AWS EKS
- **Passo-03:** Fundamentos do Kubernetes - Introdução

### Kubernetes - Pods com kubectl
- **Passo-01:** Introdução aos Pods
- **Passo-02:** Demonstração de Pods
- **Passo-03:** Introdução ao Node Port Service
- **Passo-04:** Demonstração de Node Port Service e Pods
- **Passo-05:** Interagir com Pod - Conectar ao container em um pod
- **Passo-06:** Excluir Pod

### Kubernetes - ReplicaSets com kubectl
- **Passo-01:** Introdução ao ReplicaSet
- **Passo-02:** Criar ReplicaSet
- **Passo-03:** Expor, Testar Alta Disponibilidade e Excluir ReplicaSet

### Kubernetes - Deployments com kubectl
- **Passo-02:** Demonstração de Deployments
- **Passo-03:** Atualizar Deployment usando opção Set Image
- **Passo-04:** Editar Deployment usando kubectl edit
- **Passo-05:** Fazer rollback da aplicação para versão anterior - Undo Deployment
- **Passo-06:** Pausar e Retomar Deployments

### Kubernetes - Services com kubectl
- **Passo-01:** Introdução aos Services
- **Passo-02:** Demonstração de Services

### Fundamentos do YAML
- **Passo-01:** Introdução à Abordagem Declarativa do Kubernetes
- **Passo-02:** Fundamentos do YAML

### Kubernetes - Pods com YAML
- **Passo-01:** Criar Manifesto de Pod em YAML
- **Passo-02:** Criar Node Port Service & Testar

### Kubernetes - ReplicaSets com YAML
- **Passo-01:** Criar Manifestos de ReplicaSet com YAML
- **Passo-02:** Criar Node Port Service & Testar

### Kubernetes - Deployments com YAML
- **Passo-01:** Criar Manifesto de Deployment, Deployar & Testar

### Kubernetes - Services com YAML
- **Passo-01:** Aplicação Backend - Criar Deployment e Service ClusterIP
- **Passo-02:** Aplicação Frontend - Criar Deployment e Service NodePort
- **Passo-03:** Deployar e Testar - Aplicações Frontend e Backend


## O que os alunos vão aprender neste curso?
- Você vai aprender a criar Pods, ReplicaSets, Deployments e Services usando kubectl
- Você vai aprender a criar Pods, ReplicaSets, Deployments e Services usando YAML
- Você vai escrever manifestos Kubernetes em YAML com confiança após passar pelas seções práticas de escrita de templates
- Você vai aprender os Fundamentos do Kubernetes nas abordagens imperativa e declarativa
- Você vai aprender a criar um Cluster AWS EKS usando o eksctl CLI
- Você vai dominar muitos comandos kubectl durante o processo
- Você terá instruções passo a passo documentadas em um repositório do github

## Existem requisitos ou pré-requisitos para o curso?
- Você precisa ter uma conta AWS para acompanhar as atividades práticas.
- Você não precisa ter conhecimento prévio de Kubernetes para começar este curso.


## Quem são os alunos-alvo?
- Qualquer iniciante interessado em aprender Kubernetes na nuvem usando AWS EKS.
- Arquitetos AWS, Sysadmins ou Desenvolvedores que desejam dominar o Elastic Kubernetes Service (EKS) para rodar aplicações no Kubernetes

## Cada um dos meus cursos inclui
- Experiências práticas incríveis, passo a passo
- Experiência de implementação real
- Suporte amigável na seção de perguntas e respostas
- Garantia de devolução do dinheiro em 30 dias, sem perguntas!


