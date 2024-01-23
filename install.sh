#/bin/bash

#Delete app folder
rm -rf /opt/poc-gce-logging-router

#Download repo
git clone \
    git@bitbucket.org:pernamlabs/poc-gce-logging-router.git \
        /opt/poc-gce-logging-router

#Criar arquivo de log
touch /var/log/poc-gce-logging-router.log &&\
    chmod 777 /var/log/poc-gce-logging-router.log

#Instalação de dependencias
pip3 install -r /opt/poc-gce-logging-router/requirements.txt

#Criar arquivo de serviço
rm -rf /etc/systemd/system/poc-gce-logging-router.service
ln -s /opt/poc-gce-logging-router/poc-gce-logging-router.service /etc/systemd/system/poc-gce-logging-router.service

#Habilitação e inicialização do serviço
systemctl daemon-reload
systemctl start poc-gce-logging-router
systemctl enable poc-gce-logging-router