# Seu Docker Hub username
$DOCKER_USERNAME = "1234samue"

Write-Host "🐳 Building Docker Images for Context Path Routing..." -ForegroundColor Cyan

# Build App1
Write-Host "`n📦 Building App1..." -ForegroundColor Yellow
Set-Location app1
docker build -t ${DOCKER_USERNAME}/aula:kubenginx-app1-1.0.0 .
Set-Location ..

# Build App2
Write-Host "`n📦 Building App2..." -ForegroundColor Yellow
Set-Location app2
docker build -t ${DOCKER_USERNAME}/aula:kubenginx-app2-1.0.0 .
Set-Location ..

# Build App3
Write-Host "`n📦 Building App3..." -ForegroundColor Yellow
Set-Location app3
docker build -t ${DOCKER_USERNAME}/aula:kubenginx-app3-1.0.0 .
Set-Location ..

Write-Host "`n✅ All images built successfully!" -ForegroundColor Green
Write-Host "`n🚀 Pushing images to Docker Hub..." -ForegroundColor Cyan

# Push App1
Write-Host "`n⬆️ Pushing App1..." -ForegroundColor Yellow
docker push ${DOCKER_USERNAME}/aula:kubenginx-app1-1.0.0

# Push App2
Write-Host "`n⬆️ Pushing App2..." -ForegroundColor Yellow
docker push ${DOCKER_USERNAME}/aula:kubenginx-app2-1.0.0

# Push App3
Write-Host "`n⬆️ Pushing App3..." -ForegroundColor Yellow
docker push ${DOCKER_USERNAME}/aula:kubenginx-app3-1.0.0

Write-Host "`n✅ All images pushed successfully!" -ForegroundColor Green
Write-Host "`n📝 Images created:" -ForegroundColor Cyan
Write-Host "  - ${DOCKER_USERNAME}/aula:kubenginx-app1-1.0.0" -ForegroundColor White
Write-Host "  - ${DOCKER_USERNAME}/aula:kubenginx-app2-1.0.0" -ForegroundColor White
Write-Host "  - ${DOCKER_USERNAME}/aula:kubenginx-app3-1.0.0" -ForegroundColor White

