---
layout: page
title: "Kubernetes - Conceitos Importantes"
description: "Secrets, ConfigMaps, Probes, Requests/Limits e Namespaces"
permalink: /05-kubernetes-concepts/
---

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-10">
      
      <!-- Hero Section -->
      <div class="text-center mb-5">
        <h1 class="display-4 fw-bold mb-3">🚀 Kubernetes - Conceitos Importantes</h1>
        <p class="lead text-muted">Conceitos fundamentais do Kubernetes necessários para deployments robustos e seguros</p>
        <div class="d-flex justify-content-center gap-3 mt-4">
          <span class="badge bg-primary fs-6">Secrets</span>
          <span class="badge bg-secondary fs-6">ConfigMaps</span>
          <span class="badge bg-success fs-6">Probes</span>
          <span class="badge bg-warning fs-6">Namespaces</span>
        </div>
      </div>

      <!-- Overview -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h2 class="card-title">📋 Visão Geral</h2>
          <p class="card-text">Este módulo aborda os conceitos fundamentais do Kubernetes necessários para fazer deployments robustos e seguros de aplicações.</p>
        </div>
      </div>

      <!-- Modules -->
      <div class="row g-4 mb-5">
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🔐 05-01 - Kubernetes Secrets</h5>
              <p class="card-text">Gerenciamento seguro de credenciais</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Implementação segura</li>
                <li><i class="fas fa-check text-success me-2"></i>Melhores práticas</li>
                <li><i class="fas fa-check text-success me-2"></i>Integração com ferramentas</li>
                <li><i class="fas fa-check text-success me-2"></i>Exemplos práticos</li>
              </ul>
              <a href="/posts/kubernetes-secrets-guide/" class="btn btn-sm btn-outline-primary">
                <i class="fas fa-arrow-right me-1"></i>
                Ver Guia Completo
              </a>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">⚙️ 05-02 - Init Containers</h5>
              <p class="card-text">Containers de inicialização</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Containers de inicialização</li>
                <li><i class="fas fa-check text-success me-2"></i>Casos de uso práticos</li>
                <li><i class="fas fa-check text-success me-2"></i>Ordem de execução</li>
                <li><i class="fas fa-check text-success me-2"></i>Troubleshooting</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🔍 05-03 - Health Probes</h5>
              <p class="card-text">Liveness e Readiness Probes</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Health checks</li>
                <li><i class="fas fa-check text-success me-2"></i>Configuração de probes</li>
                <li><i class="fas fa-check text-success me-2"></i>Troubleshooting</li>
                <li><i class="fas fa-check text-success me-2"></i>Boas práticas</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">📊 05-04 - Requests e Limits</h5>
              <p class="card-text">Gerenciamento de recursos</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>CPU e Memory limits</li>
                <li><i class="fas fa-check text-success me-2"></i>Quality of Service</li>
                <li><i class="fas fa-check text-success me-2"></i>Otimização de performance</li>
                <li><i class="fas fa-check text-success me-2"></i>Monitoramento</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🏗️ 05-05 - Namespaces</h5>
              <p class="card-text">Organização e isolamento</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Organização de recursos</li>
                <li><i class="fas fa-check text-success me-2"></i>Isolamento de ambientes</li>
                <li><i class="fas fa-check text-success me-2"></i>RBAC por namespace</li>
                <li><i class="fas fa-check text-success me-2"></i>Resource Quotas</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Example: Secrets -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">🔐 Exemplo: Kubernetes Secrets</h3>
          <div class="row">
            <div class="col-md-6">
              <h5>Secret YAML</h5>
              <div class="bg-dark text-light p-3 rounded">
                <pre><code>apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
data:
  password: c2VuaGE=</code></pre>
              </div>
            </div>
            <div class="col-md-6">
              <h5>Deployment usando Secret</h5>
              <div class="bg-dark text-light p-3 rounded">
                <pre><code>env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysql-secret
      key: password</code></pre>
              </div>
            </div>
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
                <li><i class="fas fa-check text-success me-2"></i>Implementar Secrets</li>
                <li><i class="fas fa-check text-success me-2"></i>Configurar Init Containers</li>
                <li><i class="fas fa-check text-success me-2"></i>Configurar Health Checks</li>
              </ul>
            </div>
            <div class="col-md-6">
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Gerenciar recursos</li>
                <li><i class="fas fa-check text-success me-2"></i>Organizar com Namespaces</li>
                <li><i class="fas fa-check text-success me-2"></i>Aplicar boas práticas</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Best Practices -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">💡 Melhores Práticas</h3>
          <div class="row">
            <div class="col-md-6">
              <div class="alert alert-info">
                <h6><i class="fas fa-shield-alt me-2"></i>Segurança</h6>
                <ul class="mb-0">
                  <li>Use Secrets para credenciais</li>
                  <li>Configure RBAC adequadamente</li>
                  <li>Implemente criptografia</li>
                </ul>
              </div>
            </div>
            <div class="col-md-6">
              <div class="alert alert-warning">
                <h6><i class="fas fa-cogs me-2"></i>Performance</h6>
                <ul class="mb-0">
                  <li>Configure Requests e Limits</li>
                  <li>Use Health Probes</li>
                  <li>Monitore recursos</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Next Steps -->
      <div class="card border-0 shadow-sm">
        <div class="card-body text-center">
          <h3 class="card-title">🚀 Próximos Passos</h3>
          <p class="card-text">Após dominar estes conceitos, continue para:</p>
          <div class="d-flex justify-content-center gap-3">
            <a href="/06-eks-storage-rds/" class="btn btn-primary">
              <i class="fas fa-arrow-right me-2"></i>
              RDS Database Integration
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
