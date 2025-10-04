---
layout: page
title: "Docker Fundamentals"
description: "Conceitos básicos do Docker - Containers, Images, Registry"
permalink: /02-docker/
---

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-10">
      
      <!-- Hero Section -->
      <div class="text-center mb-5">
        <h1 class="display-4 fw-bold mb-3">🐳 Docker Fundamentals</h1>
        <p class="lead text-muted">O Docker é a base para entender Kubernetes. Aprenda todos os conceitos essenciais.</p>
        <div class="d-flex justify-content-center gap-3 mt-4">
          <span class="badge bg-primary fs-6">Docker</span>
          <span class="badge bg-secondary fs-6">Containers</span>
          <span class="badge bg-success fs-6">Images</span>
        </div>
      </div>

      <!-- Overview -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h2 class="card-title">📋 Visão Geral</h2>
          <p class="card-text">Este módulo cobre todos os conceitos essenciais do Docker que você precisa saber antes de partir para Kubernetes.</p>
        </div>
      </div>

      <!-- Modules -->
      <div class="row g-4 mb-5">
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">📖 02-01 - Docker Introduction</h5>
              <p class="card-text">Conceitos fundamentais do Docker</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>O que são containers</li>
                <li><i class="fas fa-check text-success me-2"></i>Docker vs VMs</li>
                <li><i class="fas fa-check text-success me-2"></i>Arquitetura do Docker</li>
                <li><i class="fas fa-check text-success me-2"></i>Casos de uso</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">⚙️ 02-02 - Docker Installation</h5>
              <p class="card-text">Instalação em diferentes sistemas</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Instalação no Windows</li>
                <li><i class="fas fa-check text-success me-2"></i>Instalação no Linux</li>
                <li><i class="fas fa-check text-success me-2"></i>Instalação no macOS</li>
                <li><i class="fas fa-check text-success me-2"></i>Verificação da instalação</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">📥 02-03 - Pull and Run</h5>
              <p class="card-text">Trabalhando com imagens do Docker Hub</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Docker Hub</li>
                <li><i class="fas fa-check text-success me-2"></i>Pull de imagens</li>
                <li><i class="fas fa-check text-success me-2"></i>Execução de containers</li>
                <li><i class="fas fa-check text-success me-2"></i>Comandos básicos</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🔨 02-04 - Build and Push</h5>
              <p class="card-text">Criando e publicando imagens</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Dockerfile</li>
                <li><i class="fas fa-check text-success me-2"></i>Build de imagens</li>
                <li><i class="fas fa-check text-success me-2"></i>Teste local</li>
                <li><i class="fas fa-check text-success me-2"></i>Push para Docker Hub</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🛠️ 02-05 - Essential Commands</h5>
              <p class="card-text">Comandos essenciais do Docker</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Comandos de container</li>
                <li><i class="fas fa-check text-success me-2"></i>Comandos de imagem</li>
                <li><i class="fas fa-check text-success me-2"></i>Comandos de rede</li>
                <li><i class="fas fa-check text-success me-2"></i>Comandos de volume</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Commands Section -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">🛠️ Comandos Essenciais</h3>
          <div class="row">
            <div class="col-md-6">
              <h5>Pull e Run</h5>
              <div class="bg-dark text-light p-3 rounded">
                <code>docker pull nginx<br>
docker run -d -p 80:80 nginx</code>
              </div>
            </div>
            <div class="col-md-6">
              <h5>Build e Push</h5>
              <div class="bg-dark text-light p-3 rounded">
                <code>docker build -t minha-app .<br>
docker push meu-usuario/minha-app</code>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Dockerfile Example -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">📝 Exemplo de Dockerfile</h3>
          <div class="bg-dark text-light p-3 rounded">
            <pre><code>FROM nginx:alpine
COPY index.html /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]</code></pre>
          </div>
        </div>
      </div>

      <!-- Learning Objectives -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">🎯 Objetivos de Aprendizado</h3>
          <div class="row">
            <div class="col-md-6">
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Entender containers</li>
                <li><i class="fas fa-check text-success me-2"></i>Instalar Docker</li>
                <li><i class="fas fa-check text-success me-2"></i>Baixar e executar imagens</li>
              </ul>
            </div>
            <div class="col-md-6">
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Criar imagens personalizadas</li>
                <li><i class="fas fa-check text-success me-2"></i>Fazer push para registries</li>
                <li><i class="fas fa-check text-success me-2"></i>Usar comandos essenciais</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Next Steps -->
      <div class="card border-0 shadow-sm">
        <div class="card-body text-center">
          <h3 class="card-title">🚀 Próximos Passos</h3>
          <p class="card-text">Após dominar Docker, continue para:</p>
          <div class="d-flex justify-content-center gap-3">
            <a href="/03-kubernetes/" class="btn btn-primary">
              <i class="fas fa-arrow-right me-2"></i>
              Kubernetes Fundamentals
            </a>
            <a href="/" class="btn btn-outline-secondary">
              <i class="fas fa-home me-2"></i>
              Voltar ao Início
            </a>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>
