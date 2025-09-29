# AWS EKS Storage

## AWS EBS CSI Driver
- Vamos usar o EBS CSI Driver e usar volumes EBS para armazenamento persistente do banco de dados MySQL

## Tópicos
1. Instalar EBS CSI Driver
2. Criar Deployment e ClusterIP Service do banco de dados MySQL
3. Criar Deployment e NodePort Service do Microserviço de Gerenciamento de Usuários

## Conceitos
| Objeto Kubernetes                                         | Arquivo YAML |
| --------------------------------------------------------- | --------------------------------------------- |
| Storage Class                                             | 01-storage-class.yml                          |
| Persistent Volume Claim                                   | 02-persistent-volume-claim.yml                |
| Config Map                                                | 03-UserManagement-ConfigMap.yml               |
| Deployment, Environment Variables, Volumes, VolumeMounts  | 04-mysql-deployment.yml                       |
| ClusterIP Service                                         | 05-mysql-clusterip-service.yml                |
| Deployment, Environment Variables                         | 06-UserManagementMicroservice-Deployment.yml  |
| NodePort Service                                          | 07-UserManagement-Service.yml                 |

## Referências:
- **Dynamic Volume Provisioning:** https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/
- https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/deploy/kubernetes/overlays/stable
- https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
- https://github.com/kubernetes-sigs/aws-ebs-csi-driver
- https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/examples/kubernetes/dynamic-provisioning
- https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/deploy/kubernetes/overlays/stable
- https://github.com/kubernetes-sigs/aws-ebs-csi-driver

- **Legacy: Será descontinuado** 
  - https://kubernetes.io/docs/concepts/storage/storage-classes/#aws-ebs
  - https://docs.aws.amazon.com/eks/latest/userguide/storage-classes.html