# Fluxo-1: Baixar Imagem Docker do Docker Hub e Executá-la

## Passo-1: Verificar versão do Docker e fazer login no Docker Hub
```
docker version
docker login
```

## Passo-2: Baixar Imagem do Docker Hub
```
docker pull aula/dockerintro-springboot-helloworld-rest-api:1.0.0-RELEASE
```

## Passo-3: Executar a Imagem Docker Baixada e Acessar a Aplicação
- Copie o nome da imagem docker do Docker Hub
```
docker run --name app1 -p 80:8080 -d aula/dockerintro-springboot-helloworld-rest-api:1.0.0-RELEASE
http://localhost/hello

# Para Mac com Apple Chips (use aplicação diferente)
Passo-1: Instale Docker com binário Apple Chips (https://docs.docker.com/desktop/mac/install/) na sua máquina mac

Passo-2: Execute o container da aplicação Nginx simples. 
docker run --name kube1 -p 80:80 --platform linux/amd64 -d  aula/kubenginx:1.0.0
http://localhost

## Saída de Exemplo
 docker run --name kube1 -p 80:80 --platform linux/amd64 -d  aula/kubenginx:1.0.0
370f238d97556813a4978572d24983d6aaf80d4300828a57f27cda3d3d8f0fec
 curl http://localhost
<!DOCTYPE html>
<html>
   <body style="background-color:lightgoldenrodyellow;">
      <h1>Welcome to Stack Simplify</h1>
      <p>Kubernetes Fundamentals Demo</p>
      <p>Application Version: V1</p>
   </body>
</html>%
 

```

## Passo-4: Listar Containers em Execução
```
docker ps
docker ps -a
docker ps -a -q
```

## Passo-5: Conectar ao Terminal do Container
```
docker exec -it <nome-do-container> /bin/sh
```

## Passo-6: Parar e Iniciar Container 
```
docker stop <nome-do-container>
docker start  <nome-do-container>
```

## Passo-7: Remover Container 
```
docker stop <nome-do-container> 
docker rm <nome-do-container>
```

## Passo-8: Remover Imagem
```
docker images
docker rmi  <id-da-imagem>
```

