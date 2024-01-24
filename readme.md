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

> sudo bash poc-gce-logging-router/install.sh

## Testar
Para testar basta dar um GET no endereço do servidor na porta 5000, depois dar um cat no arquivo `/var/log/poc-gce-logging-router.log`, se estiver
populando o arquivo a aplicação está funcionando corretamente.

## Configurar o ops-agent para coletar logs personalizados
- Primeiro é necessário garantir que esteja instalado o agente de monitoramento do google ops-agent; se não foi usado o terraform para criar a maquina,
é necessário instalar; para instalar, basta ir na aba de observabilidade da maquina em questão no proprio compute engine e lá vão aparecer algumas metricas,
porém outras não, e o google irá recomendar a instalação do agente, para isntalar é só um botão na interface e aguardar de 1-2 minutos.

- Depois de instalado é necessário configurar um arquivo do agente conforme a [documentação](https://cloud.google.com/logging/docs/agent/ops-agent/configuration?hl=pt-br);
Para nosso cenário ficará assim:
```
logging:
  receivers:
    syslog:
      type: files
      include_paths:
      - /var/log/messages
      - /var/log/syslog
    poc-gce-logging-router:
      type: files
      include_paths:
      - /var/log/poc-gce-logging-router.log
  service:
    pipelines:
      default_pipeline:
        receivers: [syslog]
metrics:
  receivers:
    hostmetrics:
      type: hostmetrics
      collection_interval: 60s
  processors:
    metrics_filter:
      type: exclude_metrics
      metrics_pattern: []
  service:
    pipelines:
      default_pipeline:
        receivers: [hostmetrics]
        processors: [metrics_filter]
```

- Agora precisaremos reiniciar o agente
>  sudo systemctl restart google-cloud-ops-agent"*"