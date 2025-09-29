
# Services com YAML

## Passo-01: Introdução aos Services
- Vamos analisar detalhadamente os dois tipos de service abaixo com exemplos de frontend e backend:
  - NodePort Service
  - ClusterIP Service

## Passo-02: Criar Deployment Backend & Service ClusterIP
- Escreva o template de Deployment para a aplicação REST backend.
- Escreva o template de Service ClusterIP para a aplicação REST backend.
- **Notas importantes:**
  - O nome do Service ClusterIP deve ser `name: my-backend-service` pois está configurado no reverse proxy nginx do frontend (`default.conf`).
  - Teste com outro nome e entenda o problema que ocorre
  - Também discutimos isso na seção [05-Services-with-kubectl](/05-Services-with-kubectl/README.md)
```
kubectl get all
kubectl apply -f 01-backend-deployment.yml -f 02-backend-clusterip-service.yml
kubectl get all
```

## Passo-03: Criar Deployment Frontend & Service NodePort
- Escreva o template de Deployment para a aplicação Nginx frontend
- Escreva o template de Service NodePort para a aplicação Nginx frontend
```
cd <Course-Repo>\kubernetes-fundamentals\10-Services-with-YAML\kube-manifests
kubectl get all
kubectl apply -f 03-frontend-deployment.yml -f 04-frontend-nodeport-service.yml
kubectl get all
```
- **Acessar aplicação REST**
```
# Obter IP externo dos nodes
kubectl get nodes -o wide

# Acessar aplicação REST (Porta estática 31234 configurada no template do service frontend)
http://<ip-publico-node1>:31234/hello
```

## Passo-04: Excluir & Recriar objetos usando kubectl apply
### Excluir objetos (arquivo por arquivo)
```
kubectl delete -f 01-backend-deployment.yml -f 02-backend-clusterip-service.yml -f 03-frontend-deployment.yml -f 04-frontend-nodeport-service.yml
kubectl get all
```
### Recriar objetos usando arquivos YAML em uma pasta
```
cd <Course-Repo>\kubernetes-fundamentals\10-Services-with-YAML
kubectl apply -f kube-manifests/
kubectl get all
```
### Excluir objetos usando arquivos YAML em uma pasta
```
cd <Course-Repo>\kubernetes-fundamentals\10-Services-with-YAML
kubectl delete -f kube-manifests/
kubectl get all
```

## Referências adicionais - Use Label Selectors para get e delete
- https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#using-labels-effectively
- https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors