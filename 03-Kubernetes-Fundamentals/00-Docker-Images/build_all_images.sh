#!/bin/bash
# Script para buildar todas as imagens Docker das subpastas

set -e

REPO_PREFIX="${1:-aula}"

if [ -z "$1" ]; then
    echo "Usando repositório local padrão: 'aula'. Para enviar ao Docker Hub, execute:"
    echo "  $0 <dockerhub_user/repo>"
    echo "Exemplo: $0 1234samue/aula"
fi

for dir in */*/ ; do
    if [ -f "$dir/Dockerfile" ]; then
        # Extrai nome da pasta para tag
        tag=$(basename "$dir")
        echo "Buildando imagem: ${REPO_PREFIX}:$tag"
        
        # Para projetos Java Maven, o JAR será compilado dentro do Docker (multi-stage)
        if [ -f "$dir/pom.xml" ]; then
            echo "Projeto Maven detectado - JAR será compilado durante o build Docker"
        fi
        
        docker build -t "${REPO_PREFIX}:$tag" "$dir"

        # Se um prefixo foi fornecido (provável Docker Hub), fazer push
        if [ -n "$1" ]; then
            echo "Enviando imagem para o registry: ${REPO_PREFIX}:$tag"
            docker push "${REPO_PREFIX}:$tag"
        fi
    fi
done

echo "Build de todas as imagens concluído."
