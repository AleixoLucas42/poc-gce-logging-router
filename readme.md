# Roteamento de logs para o cloud logging do GCP
Este repositório se destina à prova de conceito para redirecionar
os logs de uma aplicação que não popula o sysout de uma vm no Compute engine.


## Instalação da aplicação de teste (bash install.sh)
A aplicação usa a porta 5000, se houver firewall, é necessário permitir esta porta.

- Download do repositório
> git clone git@bitbucket.org:pernamlabs/poc-gce-logging-router.git /opt/poc-gce-logging-router

- Criação do arquivo de log da aplicação de demonstração
> touch /var/log/poc-gce-logging-router.log && chmod 777 /var/log/poc-gce-logging-router.log

- Instalação das dependencias
> pip3 install -r /opt/poc-gce-logging-router/requirements.txt

- Criação do arquivo de serviço do linux
> sudo ln -s /opt/poc-gce-logging-router/poc-gce-logging-router.service /etc/systemd/system/poc-gce-logging-router.service

- Reiniciar o daemon
> sudo systemctl daemon-reload

- Iniciar a aplicação
> sudo systemctl start poc-gce-logging-router

- Habilitar na inicialização
> sudo systemctl enable poc-gce-logging-router

