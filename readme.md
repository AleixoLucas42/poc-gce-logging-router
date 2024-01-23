# Roteamento de logs para o cloud logging do GCP
Este repositório se destina à prova de conceito para redirecionar
os logs de uma aplicação que não popula o sysout de uma vm no Compute engine.


## Criação do compute engine

```gcloud
gcloud compute instances create poc-gce-logging-router \
    --project={PROJECT_ID} \
    --zone=us-central1-a \
    --machine-type=e2-micro \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet={VPC_NETWORK} \
    --no-restart-on-failure \
    --maintenance-policy=TERMINATE \
    --provisioning-model=SPOT \
    --instance-termination-action=DELETE \
    --service-account=498298766729-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=poc-gce-logging-router,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240110,mode=rw,size=10,type=projects/{PROJECT_ID}/zones/us-central1-a/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
```

## Instalação da aplicação de teste (bash install.sh)
A aplicação usa a porta 5000, se houver firewall, é necessário permitir esta porta.

- Instalação
> git clone https://github.com/AleixoLucas42/poc-gce-logging-router.git /opt/poc-gce-logging-router && bash install.sh

- Reiniciar o daemon
> sudo systemctl daemon-reload

- Iniciar a aplicação
> sudo systemctl start poc-gce-logging-router

- Habilitar na inicialização
> sudo systemctl enable poc-gce-logging-router

## Testar
Para testar basta dar um GET no endereço do servidor na porta 5000, depois dar um cat no arquivo `/var/log/poc-gce-logging-router.log`