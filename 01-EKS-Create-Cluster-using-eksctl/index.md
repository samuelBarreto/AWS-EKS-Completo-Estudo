---
layout: page
title: "EKS Cluster Creation"
description: "Criação de cluster EKS com eksctl - Do básico ao avançado"
permalink: /01-EKS-Create-Cluster-using-eksctl/
---

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-10">
      
      <!-- Hero Section -->
      <div class="text-center mb-5">
        <h1 class="display-4 fw-bold mb-3">🚀 EKS Cluster Creation</h1>
        <p class="lead text-muted">Aprenda a criar e gerenciar clusters EKS na AWS usando o eksctl</p>
        <div class="d-flex justify-content-center gap-3 mt-4">
          <span class="badge bg-primary fs-6">AWS EKS</span>
          <span class="badge bg-secondary fs-6">eksctl</span>
          <span class="badge bg-success fs-6">Kubernetes</span>
        </div>
      </div>

      <!-- Overview -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h2 class="card-title">📋 Visão Geral</h2>
          <p class="card-text">Este módulo ensina a criar e gerenciar clusters EKS na AWS usando o eksctl, a ferramenta oficial para gerenciamento de clusters EKS.</p>
        </div>
      </div>

      <!-- Modules -->
      <div class="row g-4 mb-5">
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">⚙️ 01-01 - Install CLIs</h5>
              <p class="card-text">Instalação e configuração das ferramentas necessárias</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>AWS CLI</li>
                <li><i class="fas fa-check text-success me-2"></i>eksctl</li>
                <li><i class="fas fa-check text-success me-2"></i>kubectl</li>
                <li><i class="fas fa-check text-success me-2"></i>Configuração de credenciais</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🏗️ 01-02 - Create EKS Cluster</h5>
              <p class="card-text">Criação de cluster e NodeGroups</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Cluster básico</li>
                <li><i class="fas fa-check text-success me-2"></i>Configuração de NodeGroups</li>
                <li><i class="fas fa-check text-success me-2"></i>Tipos de instâncias</li>
                <li><i class="fas fa-check text-success me-2"></i>Configuração de rede</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">💰 01-03 - EKS Pricing</h5>
              <p class="card-text">Entendendo os custos do EKS</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Custos do EKS</li>
                <li><i class="fas fa-check text-success me-2"></i>Custos de instâncias EC2</li>
                <li><i class="fas fa-check text-success me-2"></i>Custos de Load Balancers</li>
                <li><i class="fas fa-check text-success me-2"></i>Otimização de custos</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🗑️ 01-04 - Delete Cluster</h5>
              <p class="card-text">Limpeza de recursos</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Limpeza de recursos</li>
                <li><i class="fas fa-check text-success me-2"></i>Comandos de delete</li>
                <li><i class="fas fa-check text-success me-2"></i>Verificação de limpeza</li>
                <li><i class="fas fa-check text-success me-2"></i>Boas práticas</li>
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
              <h5>Criar Cluster</h5>
              <div class="bg-dark text-light p-3 rounded">
                <code>eksctl create cluster --name meu-cluster --region us-east-1</code>
              </div>
            </div>
            <div class="col-md-6">
              <h5>Deletar Cluster</h5>
              <div class="bg-dark text-light p-3 rounded">
                <code>eksctl delete cluster --name meu-cluster</code>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Architecture -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">🏗️ Arquitetura EKS</h3>
          <div class="text-center">
            <div class="row g-3">
              <div class="col-md-4">
                <div class="p-3 border rounded">
                  <h6>EKS Control Plane</h6>
                  <small class="text-muted">API Server, etcd, Scheduler</small>
                </div>
              </div>
              <div class="col-md-4">
                <div class="p-3 border rounded">
                  <h6>NodeGroup 1</h6>
                  <small class="text-muted">t3.medium instances</small>
                </div>
              </div>
              <div class="col-md-4">
                <div class="p-3 border rounded">
                  <h6>NodeGroup 2</h6>
                  <small class="text-muted">t3.large instances</small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Cost Estimation -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">💰 Estimativa de Custos</h3>
          <div class="table-responsive">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Recurso</th>
                  <th>Custo Mensal (aproximado)</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><strong>EKS Control Plane</strong></td>
                  <td>$73.20</td>
                </tr>
                <tr>
                  <td><strong>t3.medium (2 instâncias)</strong></td>
                  <td>$60.48</td>
                </tr>
                <tr>
                  <td><strong>Load Balancer</strong></td>
                  <td>$18.25</td>
                </tr>
                <tr class="table-primary">
                  <td><strong>Total</strong></td>
                  <td><strong>~$152/mês</strong></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Next Steps -->
      <div class="card border-0 shadow-sm">
        <div class="card-body text-center">
          <h3 class="card-title">🚀 Próximos Passos</h3>
          <p class="card-text">Após criar seu cluster EKS, continue para:</p>
          <div class="d-flex justify-content-center gap-3">
            <a href="/02-Docker-Fundamentals/" class="btn btn-primary">
              <i class="fas fa-arrow-right me-2"></i>
              Docker Fundamentals
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
