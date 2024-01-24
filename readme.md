# Roteamento de logs para o cloud logging do GCP
Este repositório se destina à prova de conceito para redirecionar
os logs de uma aplicação que não popula o sysout de uma vm no Compute engine.


## Criação do compute engine
> cd terraform && terraform init

> terraform plan

> terraform apply

## Instalação da aplicação de teste
A aplicação usa a porta 5000, se houver firewall, é necessário permitir esta porta.

- Instalação
> git clone https://github.com/AleixoLucas42/poc-gce-logging-router.git

> bash poc-gce-logging-router/install.sh

## Testar
Para testar basta dar um GET no endereço do servidor na porta 5000, depois dar um cat no arquivo `/var/log/poc-gce-logging-router.log`