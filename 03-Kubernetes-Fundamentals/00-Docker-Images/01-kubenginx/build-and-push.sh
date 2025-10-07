#!/bin/bash

# Seu Docker Hub username
DOCKER_USERNAME="1234samue"

echo "🐳 Building Docker Images for Context Path Routing..."

# Build App1
echo "📦 Building App1..."
cd app1
docker build -t ${DOCKER_USERNAME}/aula:kubenginx-app1-1.0.0 .
cd ..

# Build App2
echo "📦 Building App2..."
cd app2
docker build -t ${DOCKER_USERNAME}/aula:kubenginx-app2-1.0.0 .
cd ..

# Build App3
echo "📦 Building App3..."
cd app3
docker build -t ${DOCKER_USERNAME}/aula:kubenginx-app3-1.0.0 .
cd ..

echo "✅ All images built successfully!"
echo ""
echo "🚀 Pushing images to Docker Hub..."

# Push App1
echo "⬆️ Pushing App1..."
docker push ${DOCKER_USERNAME}/aula:kubenginx-app1-1.0.0

# Push App2
echo "⬆️ Pushing App2..."
docker push ${DOCKER_USERNAME}/aula:kubenginx-app2-1.0.0

# Push App3
echo "⬆️ Pushing App3..."
docker push ${DOCKER_USERNAME}/aula:kubenginx-app3-1.0.0

echo ""
echo "✅ All images pushed successfully!"
echo ""
echo "📝 Images created:"
echo "  - ${DOCKER_USERNAME}/aula:kubenginx-app1-1.0.0"
echo "  - ${DOCKER_USERNAME}/aula:kubenginx-app2-1.0.0"
echo "  - ${DOCKER_USERNAME}/aula:kubenginx-app3-1.0.0"

