# Hello World Spring Boot Application

## 📋 Visão Geral

Esta é uma aplicação Spring Boot simples que demonstra conceitos básicos de microserviços, incluindo:
- API REST com Spring Boot
- Monitoramento com Spring Boot Actuator
- Injeção de dependências com Spring
- Containerização com Docker
- Deploy em Kubernetes

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend        │    │   Database      │
│   (Nginx)       │───▶│   (Spring Boot)  │───▶│   (MySQL)       │
│   Port: 80      │    │   Port: 8080     │    │   Port: 3306    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🚀 Tecnologias Utilizadas

- **Java 8**
- **Spring Boot 2.2.7**
- **Spring Web**
- **Spring Boot Actuator**
- **Maven**
- **Docker**
- **Kubernetes**

## 📁 Estrutura do Projeto

```
kube-helloworld/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/aula/helloworld/
│       │       ├── HelloworldApplication.java
│       │       ├── HelloWorldController.java
│       │       └── serverinfo/
│       │           └── ServerInformationService.java
│       └── resources/
│           └── application.properties
├── Dockerfile
├── pom.xml
└── README.md
```

## 🔧 Configuração

### Dependências Maven

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

### Propriedades da Aplicação

```properties
# Actuator endpoints configuration
management.endpoints.web.exposure.include=health,info,metrics,env
management.endpoint.health.show-details=always
management.info.env.enabled=true

# Server info
server.port=8080
```

## 🌐 Endpoints da API

### Endpoint Principal
```http
GET /hello
```
**Resposta:**
```json
"Hello World V1 from Spring Boot Application"
```

### Endpoints de Monitoramento (Actuator)

| Endpoint | Descrição | Exemplo |
|----------|-----------|---------|
| `/actuator/health` | Status de saúde da aplicação | `{"status":"UP"}` |
| `/actuator/info` | Informações da aplicação | `{"app":{"name":"kube-helloworld"}}` |
| `/actuator/metrics` | Métricas da aplicação | `{"names":["jvm.memory.used"]}` |
| `/actuator/env` | Variáveis de ambiente | `{"activeProfiles":[],"propertySources":[]}` |
| `/actuator` | Lista todos os endpoints | `{"_links":{"self":{"href":"/actuator"}}}` |

## 🐳 Containerização

### Dockerfile Multi-Stage

```dockerfile
# Stage 1: Build stage - Compile the JAR
FROM openjdk:8-jdk-alpine AS builder

# Install Maven
RUN apk add --no-cache maven

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package

# Stage 2: Runtime stage - Create final image
FROM openjdk:8-jre-alpine

# Set working directory
WORKDIR /app

# Copy the JAR from builder stage
COPY --from=builder /app/target/hello-world-rest-api.jar app.jar

# Create volume for temporary files
VOLUME /tmp

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT [ "sh", "-c", "java -jar /app/app.jar" ]
```

### Build da Imagem

```bash
# Build local
docker build -t 1234samue/aula:kube-helloworld .

# Build e push para Docker Hub
bash build_all_images.sh 1234samue/aula
```

## ☸️ Deploy no Kubernetes

### 1. Criar Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-backend-rest-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-backend-rest-app
  template:
    metadata:
      labels:
        app: my-backend-rest-app
    spec:
      containers:
      - name: aula
        image: 1234samue/aula:kube-helloworld
        ports:
        - containerPort: 8080
```

### 2. Criar Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-backend-service
spec:
  selector:
    app: my-backend-rest-app
  ports:
  - port: 8080
    targetPort: 8080
  type: ClusterIP
```

### 3. Comandos de Deploy

```bash
# Aplicar manifestos
kubectl apply -f deployment.yml
kubectl apply -f service.yml

# Verificar status
kubectl get pods
kubectl get services

# Ver logs
kubectl logs <pod-name>

# Port forward para teste local
kubectl port-forward <pod-name> 8080:8080
```

## 🧪 Testando a Aplicação

### 1. Teste Local

```bash
# Executar aplicação
mvn spring-boot:run

# Testar endpoints
curl http://localhost:8080/hello
curl http://localhost:8080/actuator/health
```

### 2. Teste com Docker

```bash
# Executar container
docker run -p 8080:8080 1234samue/aula:kube-helloworld

# Testar endpoints
curl http://localhost:8080/hello
curl http://localhost:8080/actuator/health
```

### 3. Teste no Kubernetes

```bash
# Port forward
kubectl port-forward <pod-name> 8080:8080

# Testar endpoints
curl http://localhost:8080/hello
curl http://localhost:8080/actuator/health
```

## 📊 Monitoramento

### Health Check

```bash
curl http://localhost:8080/actuator/health
```

**Resposta:**
```json
{
  "status": "UP",
  "components": {
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 499963174912,
        "free": 123456789012,
        "threshold": 10485760
      }
    }
  }
}
```

### Métricas

```bash
curl http://localhost:8080/actuator/metrics
```

## 🔄 Atualizações e Rollback

### Atualizar Imagem

```bash
# Atualizar deployment
kubectl set image deployment/my-backend-rest-app aula=1234samue/aula:kube-helloworld:v2.0

# Verificar rollout
kubectl rollout status deployment/my-backend-rest-app
```

### Rollback

```bash
# Ver histórico
kubectl rollout history deployment/my-backend-rest-app

# Rollback para versão anterior
kubectl rollout undo deployment/my-backend-rest-app

# Rollback para versão específica
kubectl rollout undo deployment/my-backend-rest-app --to-revision=2
```

## 🐛 Troubleshooting

### Problemas Comuns

1. **Pod em CrashLoopBackOff**
   ```bash
   kubectl describe pod <pod-name>
   kubectl logs <pod-name> --previous
   ```

2. **Erro de conexão**
   ```bash
   kubectl get services
   kubectl get endpoints
   ```

3. **Problemas de memória**
   ```bash
   kubectl top pods
   kubectl describe pod <pod-name>
   ```

### Logs Úteis

```bash
# Logs da aplicação
kubectl logs <pod-name>

# Logs anteriores
kubectl logs <pod-name> --previous

# Logs em tempo real
kubectl logs -f <pod-name>

# Logs de container específico
kubectl logs <pod-name> -c <container-name>
```

## 📚 Referências

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)

## 👥 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

**Desenvolvido com ❤️ usando Spring Boot e Kubernetes**
