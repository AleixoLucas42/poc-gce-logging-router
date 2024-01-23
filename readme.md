# Roteamento de logs para o cloud logging do GCP
Este repositório se destina à prova de conceito para redirecionar
os logs de uma aplicação que não popula o sysout de uma vm no Compute engine.


## Instalação da aplicação de teste (bash install.sh)
A aplicação usa a porta 5000, se houver firewall, é necessário permitir esta porta.

- Instalação
> bash install.sh

- Reiniciar o daemon
> sudo systemctl daemon-reload

- Iniciar a aplicação
> sudo systemctl start poc-gce-logging-router

- Habilitar na inicialização
> sudo systemctl enable poc-gce-logging-router

## Testar
Para testar basta dar um GET no endereço do servidor na porta 5000, depois dar um cat no arquivo 