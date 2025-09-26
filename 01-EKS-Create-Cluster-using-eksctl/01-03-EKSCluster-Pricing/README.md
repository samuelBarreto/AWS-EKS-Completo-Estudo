# Preços do Cluster EKS

## Passo-01: Nota Muito Importante sobre Preços do EKS
- EKS não é gratuito (Diferente de outros Serviços AWS)
- Em resumo, não há free-tier para EKS.
### Preços do Cluster EKS
    - Pagamos $0.10 por hora para cada cluster Amazon EKS
    - Por Dia: $2.4
    - Por 30 dias: $72
### Preços dos Worker Nodes EKS - EC2
    - Você paga pelos recursos AWS (ex: instâncias EC2 ou volumes EBS) 
    - Servidor T3 Medium na N.Virginia
        - $0.0416 por Hora
        - Por Dia: $0.9984 - Aproximadamente $1
        - Por Mês: $30 por 1 servidor t3.medium
    - Referência: https://aws.amazon.com/ec2/pricing/on-demand/
    - Em resumo, se executarmos 1 Cluster EKS e 1 worker node t3.medium **continuamente** por 1 mês, nossa conta será em torno de $102 a $110
    - Se levarmos 5 dias para completar este curso, e se executarmos 1 Cluster EKS e 2 Worker nodes t3.medium continuamente por 5 dias, nos custará aproximadamente $25. 
### Perfil EKS Fargate
    - O preço do AWS Fargate é calculado baseado nos recursos de **vCPU e memória** usados desde o momento que você inicia o download da imagem do container até o Pod EKS terminar.
    - **Referência:** https://aws.amazon.com/fargate/pricing/    
    - O suporte do Amazon EKS para AWS Fargate está disponível em us-east-1, us-east-2, eu-west-1, e ap-northeast-1.

### Custos Adicionais:
    - Volumes EBS: ~$5-10 por mês (dependendo do tamanho)
    - Load Balancer: $16-22 por mês (se usar)
    - Transferência de Dados: Variável

### Total Estimado: $140-160 por mês

### Notas Importantes    
- **Nota Importante-1:** Se você está usando sua Conta AWS pessoal, então certifique-se de deletar e recriar cluster e worker nodes conforme necessário. 
- **Nota Importante-2:** Não podemos parar nossas Instâncias EC2 que estão no cluster Kubernetes diferente das Instâncias EC2 regulares. Então precisamos deletar os worker nodes (Node Group) se não estivermos usando durante nosso processo de aprendizado.
 