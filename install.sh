#/bin/bash

#Delete app folder
rm -rf /opt/poc-gce-logging-router

#Download repo
git clone \
    git@github.com:AleixoLucas42/poc-gce-logging-router.git \
        /opt/poc-gce-logging-router
wget https://github.com/AleixoLucas42/poc-gce-logging-router/releases/download/RELEASE-v1.0/main -P /opt/poc-gce-logging-router

#Criar arquivo de log
touch /var/log/poc-gce-logging-router.log &&\
    chmod 777 /var/log/poc-gce-logging-router.log

#Criar arquivo de serviço
rm -rf /etc/systemd/system/poc-gce-logging-router.service
ln -s /opt/poc-gce-logging-router/poc-gce-logging-router.service /etc/systemd/system/poc-gce-logging-router.service

#Habilitação e inicialização do serviço
systemctl daemon-reload
systemctl start poc-gce-logging-router
systemctl enable poc-gce-logging-router