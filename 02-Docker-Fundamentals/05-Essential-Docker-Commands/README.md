# Docker - Comandos Essenciais
- Abaixo estão listados os comandos essenciais que precisamos 

|     Comandos                                                    |    Descrição                                                                    |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| docker ps                                                       | Listar todos os containers em execução                                          |
| docker ps -a                                                    | Listar todos os containers parados e em execução                                |
| docker stop container-id                                        | Parar o container que está em execução                                          |
| docker start container-id                                       | Iniciar o container que está parado                                             |
| docker restart container-id                                     | Reiniciar o container que está em execução                                      |
| docker port container-id                                        | Listar mapeamentos de porta de um container específico                          |
| docker rm container-id or name                                  | Remover o container parado                                                      |
| docker rm -f container-id or name                               | Remover o container em execução forçadamente                                    |
| docker pull image-info                                          | Baixar a imagem do repositório docker hub                                       |
| docker pull aula/springboot-helloworld-rest-api:2.0.0-RELEASE   | Baixar a imagem do repositório docker hub                                       |
| docker exec -it container-name /bin/sh                          | Conectar ao container linux e executar comandos no container                    |
| docker rmi image-id                                             | Remover a imagem docker                                                         |
| docker logout                                                   | Fazer logout do docker hub                                                      |
| docker login -u username -p password                            | Fazer login no docker hub                                                       |
| docker stats                                                    | Exibir um stream ao vivo das estatísticas de uso de recursos do(s) container(s) |
| docker top container-id or name                                 | Exibir os processos em execução de um container                                 |
| docker version                                                  | Mostrar as informações de versão do Docker                                      |
