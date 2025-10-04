# 📝 Guia: Como Criar Novas Páginas

## 🎯 **Estrutura de Pastas**

As páginas devem ser organizadas dentro das pastas correspondentes do seu projeto:

```
aws-eks-kubernetes-masterclass/
├── 01-EKS-Create-Cluster-using-eksctl/
│   └── index.md                    # Página principal do módulo
├── 02-Docker-Fundamentals/
│   └── index.md                    # Página principal do módulo
├── 05-Kubernetes-Important-Concepts-for-Application-Deployments/
│   └── index.md                    # Página principal do módulo
└── _template-page.md               # Template para novas páginas
```

## 🛠️ **Como Criar uma Nova Página**

### **1. Escolha a Pasta Correta**
- Identifique qual módulo sua página pertence
- Navegue até a pasta correspondente

### **2. Crie o Arquivo `index.md`**
Use o template `_template-page.md` como base:

```markdown
---
layout: page
title: "Título da Página"
description: "Descrição da página para SEO"
permalink: /url-da-pagina/
---

<!-- Conteúdo da página aqui -->
```

### **3. Atualize os Links**
- Atualize o `permalink` para corresponder à URL desejada
- Certifique-se que os links internos estão corretos

## 📋 **Template Completo**

```markdown
---
layout: page
title: "Título da Página"
description: "Descrição da página para SEO"
permalink: /url-da-pagina/
---

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-10">
      
      <!-- Hero Section -->
      <div class="text-center mb-5">
        <h1 class="display-4 fw-bold mb-3">🎯 Título da Página</h1>
        <p class="lead text-muted">Descrição da página em formato de lead</p>
        <div class="d-flex justify-content-center gap-3 mt-4">
          <span class="badge bg-primary fs-6">Tag 1</span>
          <span class="badge bg-secondary fs-6">Tag 2</span>
          <span class="badge bg-success fs-6">Tag 3</span>
        </div>
      </div>

      <!-- Overview -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h2 class="card-title">📋 Visão Geral</h2>
          <p class="card-text">Descrição geral do que será abordado nesta página.</p>
        </div>
      </div>

      <!-- Content Sections -->
      <div class="row g-4 mb-5">
        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">🔧 Seção 1</h5>
              <p class="card-text">Descrição da seção</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Item 1</li>
                <li><i class="fas fa-check text-success me-2"></i>Item 2</li>
                <li><i class="fas fa-check text-success me-2"></i>Item 3</li>
              </ul>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body">
              <h5 class="card-title">⚙️ Seção 2</h5>
              <p class="card-text">Descrição da seção</p>
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Item 1</li>
                <li><i class="fas fa-check text-success me-2"></i>Item 2</li>
                <li><i class="fas fa-check text-success me-2"></i>Item 3</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Code Examples -->
      <div class="card border-0 shadow-sm mb-5">
        <div class="card-body">
          <h3 class="card-title">🛠️ Exemplos de Código</h3>
          <div class="bg-dark text-light p-3 rounded">
            <pre><code># Exemplo de código aqui
apiVersion: v1
kind: Pod
metadata:
  name: exemplo</code></pre>
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
                <li><i class="fas fa-check text-success me-2"></i>Objetivo 1</li>
                <li><i class="fas fa-check text-success me-2"></i>Objetivo 2</li>
              </ul>
            </div>
            <div class="col-md-6">
              <ul class="list-unstyled">
                <li><i class="fas fa-check text-success me-2"></i>Objetivo 3</li>
                <li><i class="fas fa-check text-success me-2"></i>Objetivo 4</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- Next Steps -->
      <div class="card border-0 shadow-sm">
        <div class="card-body text-center">
          <h3 class="card-title">🚀 Próximos Passos</h3>
          <p class="card-text">Após completar este módulo, continue para:</p>
          <div class="d-flex justify-content-center gap-3">
            <a href="/proxima-pagina/" class="btn btn-primary">
              <i class="fas fa-arrow-right me-2"></i>
              Próxima Página
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
```

## 🎨 **Componentes Bootstrap Disponíveis**

### **Cards**
```html
<div class="card border-0 shadow-sm">
  <div class="card-body">
    <h5 class="card-title">Título</h5>
    <p class="card-text">Conteúdo</p>
  </div>
</div>
```

### **Badges**
```html
<span class="badge bg-primary fs-6">Tag</span>
<span class="badge bg-secondary fs-6">Tag</span>
<span class="badge bg-success fs-6">Tag</span>
```

### **Alertas**
```html
<div class="alert alert-info">
  <h6><i class="fas fa-info-circle me-2"></i>Informação</h6>
  <p>Conteúdo do alerta</p>
</div>
```

### **Botões**
```html
<a href="/link/" class="btn btn-primary">
  <i class="fas fa-arrow-right me-2"></i>
  Texto do Botão
</a>
```

### **Código**
```html
<div class="bg-dark text-light p-3 rounded">
  <pre><code>seu código aqui</code></pre>
</div>
```

## 📝 **Exemplos de Páginas Criadas**

1. **EKS Cluster**: `/01-EKS-Create-Cluster-using-eksctl/index.md`
2. **Docker Fundamentals**: `/02-Docker-Fundamentals/index.md`
3. **Kubernetes Concepts**: `/05-Kubernetes-Important-Concepts-for-Application-Deployments/index.md`

## 🚀 **Próximos Passos**

1. **Escolha uma pasta** do seu projeto
2. **Crie um `index.md`** usando o template
3. **Personalize o conteúdo** conforme necessário
4. **Teste localmente** com `bundle exec jekyll serve`
5. **Faça commit** e push para o GitHub

**🎉 Pronto! Sua página estará online no GitHub Pages!**
