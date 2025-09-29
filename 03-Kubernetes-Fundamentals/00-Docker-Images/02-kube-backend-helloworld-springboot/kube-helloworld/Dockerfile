# Stage 1: Build stage - Compile the JAR
FROM openjdk:8-jdk-alpine AS builder

# Install Maven
RUN apk add --no-cache maven

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies (for better Docker layer caching)
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