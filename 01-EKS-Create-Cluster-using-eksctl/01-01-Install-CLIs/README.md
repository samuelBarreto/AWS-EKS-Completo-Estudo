# Instalar AWS, kubectl e eksctl CLI's

## Passo-00: Introdução
- Instalar AWS CLI
- Instalar kubectl CLI
- Instalar eksctl CLI

## Passo-01: Instalar AWS CLI
- Referência-1: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
- Referência-2: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
### Passo-01-01: MAC - Instalar e configurar AWS CLI
- Baixar o binário e instalar via linha de comando usando os dois comandos abaixo.
```
# Baixar Binário
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

# Instalar o binário
sudo installer -pkg ./AWSCLIV2.pkg -target /
```
- Verificar a instalação
```
aws --version
aws-cli/2.0.7 Python/3.7.4 Darwin/19.4.0 botocore/2.0.0dev11

which aws
```
- Referência: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html

### Passo-01-02: Windows 10 - Instalar e configurar AWS CLI
- O AWS CLI versão 2 é suportado no Windows XP ou posterior.
- O AWS CLI versão 2 suporta apenas versões 64-bit do Windows.
- Baixar Binário: https://awscli.amazonaws.com/AWSCLIV2.msi
- Instalar o binário baixado (instalação padrão do windows)
```
aws --version
aws-cli/2.0.8 Python/3.7.5 Windows/10 botocore/2.0.0dev12
```
- Referência: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html

### Passo-01-03: Configurar AWS Command Line usando Security Credentials
- Ir para AWS Management Console --> Services --> IAM
- Selecionar o IAM User: kalyan
- **Nota Importante:** Use apenas IAM user para gerar **Security Credentials**. Nunca use Root User. (Altamente não recomendado)
- Clicar na aba **Security credentials**
- Clicar em **Create access key**
- Copiar Access ID e Secret access key
- Ir para linha de comando e fornecer os detalhes necessários
```
aws configure
AWS Access Key ID [None]: ABCDEFGHIAZBERTUCNGG  (Substitua suas credenciais quando solicitado)
AWS Secret Access Key [None]: uMe7fumK1IdDB094q2sGFhM5Bqt3HQRw3IHZzBDTm  (Substitua suas credenciais quando solicitado)
Default region name [None]: us-east-1
Default output format [None]: json
```
- Testar se AWS CLI está funcionando após configurar o acima
```
aws ec2 describe-vpcs
```

## Passo-02: Instalar kubectl CLI
- **NOTA IMPORTANTE:** Para binários Kubectl do EKS, prefira usar da Amazon (**Amazon EKS-vended kubectl binary**)
- Isso nos ajudará a obter a versão exata do cliente Kubectl baseada na versão do nosso Cluster EKS. Você pode usar o link de documentação abaixo para baixar o binário.
- Referência: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

### Passo-02-01: MAC - Instalar e configurar kubectl
- A versão do Kubectl que estamos usando aqui é 1.16.8 (Pode variar baseado na versão do Cluster que você está planejando usar no AWS EKS)

```
# Baixar o Pacote
mkdir kubectlbinary
cd kubectlbinary
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/darwin/amd64/kubectl

# Fornecer permissões de execução
chmod +x ./kubectl

# Definir o Path copiando para o Diretório Home do usuário
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile

# Verificar a versão do kubectl
kubectl version --short --client
Output: Client Version: v1.16.8-eks-e16311
```


### Passo-02-02: Windows 10 - Instalar e configurar kubectl
- Instalar kubectl no Windows 10
```
mkdir kubectlbinary
cd kubectlbinary
curl -o kubectl.exe https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/windows/amd64/kubectl.exe
```
- Atualizar a variável de ambiente **Path** do sistema
```
C:\Users\KALYAN\Documents\kubectlbinary
```
- Verificar a versão do cliente kubectl
```
kubectl version --short --client
kubectl version --client
```

## Passo-03: Instalar eksctl CLI
### Passo-03-01: eksctl no Mac
```
# Instalar Homebrew no MacOs
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Instalar o Weaveworks Homebrew tap.
brew tap weaveworks/tap

# Instalar o Weaveworks Homebrew tap.
brew install weaveworks/tap/eksctl

# Verificar versão do eksctl
eksctl version
```

### Passo-03-02: eksctl no windows ou linux
- Para sistemas operacionais Windows e Linux, você pode consultar o link de documentação abaixo.
- **Referência:** https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl


## Referências:
- https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html