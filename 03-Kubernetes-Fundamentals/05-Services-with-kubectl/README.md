# Kubernetes - Services

## Passo-01: Introdução aos Services
- **Tipos de Service**
  1. ClusterIp
  2. NodePort
  3. LoadBalancer
  4. ExternalName
- Vamos analisar ClusterIP e NodePort nesta seção com um exemplo detalhado.
- O tipo LoadBalancer é usado principalmente em provedores de nuvem e varia de acordo com cada nuvem, então veremos conforme o provedor (por nuvem).
- ExternalName não possui comandos imperativos, sendo necessário escrever a definição YAML. Vamos abordar esse tipo conforme a necessidade ao longo do curso.

## Passo-02: Service ClusterIP - Configuração da aplicação Backend
- Criar um deployment para a aplicação Backend (Spring Boot REST Application)
- Criar um service ClusterIP para balancear a carga da aplicação backend.
```
# Criar Deployment para o Backend Rest App
kubectl create deployment my-backend-rest-app --image=1234samue/aula:02-kube-backend-helloworld-springboot-kube-helloworld
kubectl get deploy

# Criar Service ClusterIp para o Backend Rest App
kubectl expose deployment my-backend-rest-app --port=8080 --target-port=8080 --name=my-backend-service
kubectl get svc
Observação: Não é necessário especificar "--type=ClusterIp" pois o padrão é criar um Service ClusterIp.
```
- **Nota Importante:** Se a porta da aplicação backend (Container Port: 8080) e a porta do Service (8080) forem iguais, não é necessário usar **--target-port=8080**, mas para evitar confusão, foi incluído. O mesmo vale para a aplicação frontend e seu service.

- **Fonte da aplicação Backend HelloWorld** [kube-helloworld](../00-Docker-Images/02-kube-backend-helloworld-springboot/kube-helloworld)

## Passo-03: Service NodePort - Configuração da aplicação Frontend
- Já implementamos o **Service NodePort** várias vezes (em pods, replicasets e deployments), mas vamos implementar novamente para ter uma visão arquitetural completa em relação ao service ClusterIp.
- Criar um deployment para a aplicação Frontend (Nginx atuando como Reverse Proxy)
- Criar um service NodePort para balancear a carga da aplicação frontend.
- **Nota Importante:** No Nginx reverse proxy, certifique-se de atualizar o nome do service backend `my-backend-service` ao construir o container frontend. Já construímos e deixamos pronto para este demo (aula/kube-frontend-nginx:1.0.0)
- **Arquivo de configuração do Nginx**
```conf
server {
    listen       80;
    server_name  localhost;
    location / {
    # Atualize abaixo o nome do Service Cluster-IP do backend e a porta
    # proxy_pass http://<Nome-do-Service-ClusterIp-Backend>:<Porta>;
    proxy_pass http://my-backend-service:8080;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
- **Local da imagem Docker:** https://hub.docker.com/repository/docker/aula/kube-frontend-nginx
- **Fonte da aplicação Frontend Nginx Reverse Proxy** [kube-frontend-nginx](../00-Docker-Images/03-kube-frontend-nginx)
```
# Criar Deployment para o Frontend Nginx Proxy
kubectl create deployment my-frontend-nginx-app --image=1234samue/aula:frontend-nginx-2.0.0
kubectl get deploy

# Criar Service NodePort para o Frontend Nginx Proxy
kubectl expose deployment my-frontend-nginx-app  --type=NodePort --port=80 --target-port=80 --name=my-frontend-service
kubectl get svc

# Capturar IP e Porta para acessar a aplicação
kubectl get svc
kubectl get nodes -o wide
http://<node1-public-ip>:<Node-Port>/hello

# Escalar backend para 10 réplicas
kubectl scale --replicas=10 deployment/my-backend-rest-app

# Testar novamente para ver o balanceamento de carga do backend
http://<node1-public-ip>:<Node-Port>/hello
```

## Tópicos Pendentes
- Vamos abordar estes itens conforme avançarmos no curso para o respectivo provedor de nuvem:
  - LoadBalancer
  - ExternalName