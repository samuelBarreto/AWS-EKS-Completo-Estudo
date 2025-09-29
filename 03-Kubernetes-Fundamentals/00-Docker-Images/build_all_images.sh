#!/bin/bash
# Script para buildar todas as imagens Docker das subpastas

set -e

REPO_PREFIX="${1:-aula}"

if [ -z "$1" ]; then
    echo "Usando repositório local padrão: 'aula'. Para enviar ao Docker Hub, execute:"
    echo "  $0 <dockerhub_user/repo>"
    echo "Exemplo: $0 1234samue/aula"
fi

while IFS= read -r -d '' dockerfile; do
    dir="$(dirname "$dockerfile")"
    if [ -f "$dockerfile" ]; then
        # Nome da pasta pai (ex: kubenginx)
        parent="$(basename "$(dirname "$dir")")"
        # Nome da pasta atual (ex: 1.0.0)
        version="$(basename "$dir")"
        # Se a pasta atual for igual à pai, usar latest
        if [ "$parent" = "$version" ]; then
            version="latest"
        fi
        tag="${parent}-${version}"
        echo "Buildando imagem: ${REPO_PREFIX}:$tag (contexto: $dir)"

        # Para projetos Java Maven, o JAR será compilado dentro do Docker (multi-stage)
        if [ -f "$dir/pom.xml" ]; then
            echo "Projeto Maven detectado - JAR será compilado durante o build Docker"
        fi

        docker build -t "${REPO_PREFIX}:$tag" "$dir"

        if [ -n "$1" ]; then
            echo "Enviando imagem para o registry: ${REPO_PREFIX}:$tag"
            docker push "${REPO_PREFIX}:$tag"
        fi
    fi
done < <(find . -type f -name Dockerfile -print0)

echo "Build de todas as imagens concluído."
