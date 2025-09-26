# Deletar Cluster EKS e Node Groups

## Passo-01: Deletar Node Group
- Podemos deletar um nodegroup separadamente usando o comando `eksctl delete nodegroup` abaixo
```
# Listar Clusters EKS
eksctl get clusters

# Capturar nome do Node Group
eksctl get nodegroup --cluster=<nomeDoCluster>
eksctl get nodegroup --cluster=eksdemo1

# Deletar Node Group
eksctl delete nodegroup --cluster=<nomeDoCluster> --name=<nomeDoNodeGroup>
eksctl delete nodegroup --cluster=eksdemo1 --name=eksdemo1-ng-public1
```

## Passo-02: Deletar Cluster  
- Podemos deletar cluster usando `eksctl delete cluster`
```
# Deletar Cluster
eksctl delete cluster <nomeDoCluster>
eksctl delete cluster eksdemo1
```

## Notas Importantes

### Nota-1: Reverter quaisquer mudanças de Security Group
- Quando criamos um cluster EKS usando `eksctl` ele cria o security group do worker node com acesso apenas à porta 22.
- Quando progredimos através do curso, criaremos muitos **NodePort Services** para acessar e testar nossas aplicações via navegador. 
- Durante este processo, precisamos adicionar uma regra adicional a este security group criado automaticamente, permitindo acesso às aplicações que implantamos. 
- Então o ponto que precisamos entender aqui é quando estamos deletando o cluster usando `eksctl`, seus componentes principais devem estar no mesmo estado, o que significa reverter a mudança que fizemos no security group antes de deletar o cluster.
- Desta forma, o cluster será deletado sem problemas, caso contrário podemos ter problemas e precisamos consultar eventos do cloudformation e deletar manualmente algumas coisas. Em resumo, precisamos ir a muitos lugares para deleções. 

### Nota-2: Reverter quaisquer mudanças de Policy da Role da Instância EC2 Worker Node
- Quando estamos fazendo a `Seção de Armazenamento EBS com EBS CSI Driver` adicionaremos uma política personalizada à role IAM do worker node.
- Quando você estiver deletando o cluster, primeiro reverta essa mudança e delete-a. 
- Desta forma não enfrentamos problemas durante a deleção do cluster.
