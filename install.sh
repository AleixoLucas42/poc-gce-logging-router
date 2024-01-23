#/bin/bash

#Delete app
rm -rf /opt/poc-gce-logging-router
systemctl stop poc-gce-logging-router
systemctl disable poc-gce-logging-route

#Download repo
git clone https://github.com/AleixoLucas42/poc-gce-logging-router.git /opt/poc-gce-logging-router
wget https://github.com/AleixoLucas42/poc-gce-logging-router/releases/download/RELEASE-v1.0/main -P /opt/poc-gce-logging-router
chmod 777 /opt/poc-gce-logging-router/main

#Criar arquivo de log
rm -rf /var/log/poc-gce-logging-router.log
touch /var/log/poc-gce-logging-router.log &&\
    chmod 777 /var/log/poc-gce-logging-router.log

#Criar arquivo de serviço
rm -rf /etc/systemd/system/poc-gce-logging-router.service
ln -s /opt/poc-gce-logging-router/poc-gce-logging-router.service /etc/systemd/system/poc-gce-logging-router.service

#Habilitação e inicialização do serviço
systemctl daemon-reload
systemctl start poc-gce-logging-router
systemctl enable poc-gce-logging-router