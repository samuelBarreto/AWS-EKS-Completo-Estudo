# Arquitetura do Kubernetes

## Passo-01: Por que Kubernetes?

Kubernetes é utilizado porque facilita o gerenciamento, escalabilidade e automação de aplicações em containers. Ele permite alta disponibilidade, balanceamento de carga, atualizações sem downtime e recuperação automática de falhas. Com Kubernetes, empresas podem orquestrar múltiplos containers em diferentes servidores de forma eficiente e segura.


## Passo-02: Arquitetura do Kubernetes

A arquitetura do Kubernetes é composta por dois principais componentes: o plano de controle (control plane) e os nós de trabalho (worker nodes). O plano de controle gerencia o cluster, tomando decisões sobre agendamento e manutenção do estado desejado. Os nós de trabalho executam os containers das aplicações. Os principais elementos são:
- API Server: ponto de entrada para comandos e comunicação.
- etcd: armazenamento do estado do cluster.
- Scheduler: decide onde os pods serão executados.
- Controller Manager: garante que o estado desejado seja mantido.
- Kubelet: agente que roda em cada nó de trabalho.
- Kube Proxy: gerencia a rede e o acesso aos serviços.

