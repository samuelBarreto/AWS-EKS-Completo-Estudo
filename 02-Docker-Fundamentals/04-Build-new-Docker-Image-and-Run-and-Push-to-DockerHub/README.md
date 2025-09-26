# Fluxo-2: Criar uma nova Imagem Docker, Executar como Container e Fazer Push para Docker Hub

## Passo Pré-requisito
- Crie sua conta no Docker Hub. 
- https://hub.docker.com/
- **Nota Importante**: Nos comandos listados abaixo, sempre que você vir **aula** você pode substituir pelo seu ID da conta do docker hub. 


## Passo-1: Executar o container base do Nginx
- Acesse a URL http://localhost
```
docker run --name mynginxdefault -p 80:80 -d nginx
docker ps
docker stop mynginxdefault
```

## Passo-2: Criar Dockerfile e copiar nosso index.html personalizado
- **Dockerfile**
```
FROM nginx
COPY index.html /usr/share/nginx/html
```

## Passo-3: Construir Imagem Docker e executá-la
```
docker build -t aula/mynginx_image1:v1 .
docker run --name mynginx1 -p 80:80 -d aula/mynginx_image1:v1

Substitua pelo seu ID da conta do docker hub
docker build -t <seu-id-docker-hub>/mynginx_image1:v1 .
docker run --name mynginx1 -p 80:80 -d <seu-id-docker-hub>/mynginx_image1:v1
```

## Passo-4: Fazer tag e push da Imagem Docker para o docker hub
```
docker images
docker tag aula/mynginx_image1:v1 aula/mynginx_image1:v1-release
docker push aula/mynginx_image1:v1-release

Substitua pelo seu ID da conta do docker hub
docker tag <seu-id-docker-hub>/mynginx_image1:v1 <seu-id-docker-hub>/mynginx_image1:v1-release
docker push <seu-id-docker-hub>/mynginx_image1:v1-release
```
## Passo-5: Verificar o mesmo no docker hub
- Faça login no docker hub e verifique a imagem que fizemos push
- URL: https://hub.docker.com/repositories