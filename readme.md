# Roteamento de logs para o cloud logging do GCP
Este repositório se destina à prova de conceito para redirecionar
os logs de uma aplicação para o cloud logging do GCP usando o ops-agent do google.


## Criação do compute engine
> cd terraform && terraform init

> terraform plan

> terraform apply

## Instalação da aplicação de teste
A aplicação usa a porta 5000, se houver firewall, é necessário permitir esta porta.

- Conectar na vm via ssh e executar:
> git clone https://github.com/AleixoLucas42/poc-gce-logging-router.git

> sudo bash poc-gce-logging-router/install.sh

## Testar
- Enviar uma requisição GET no endereço do servidor, interno ou externo, deverá retornar: `Populating /var/log/poc-gce-logging-router.log`
> curl 127.0.0.1:5000/
- (Opcional) verificar o arquivo `/var/log/poc-gce-logging-router.log` se está sendo populado:
> cat /var/log/poc-gce-logging-router.log
- Se não estiver funcionando, pode se verificar o log com o comando:
> journalctl -u poc-gce-logging-router.service

## Configurar o ops-agent para coletar logs personalizados
- Primeiro passo é necessário garantir que esteja instalado o agente de monitoramento do google ops-agent; se não foi usado o terraform para criar a maquina,
é necessário instalar; para instalar, basta ir na aba de observabilidade da maquina em questão no proprio compute engine e lá vão aparecer algumas metricas,
porém outras não, e o google irá recomendar a instalação do agente, para instalar é só um botão na interface e aguardar de 1-2 minutos. Se houver problemas para encontrar o instalador na interface, esta [documentação](https://cloud.google.com/monitoring/agent/ops-agent/install-index) pode ajudar.

- Depois de instalado é necessário configurar um arquivo do agente conforme a [documentação](https://cloud.google.com/logging/docs/agent/ops-agent/configuration?hl=pt-br);
Para nosso cenário ficará assim:
```yaml
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
        receivers: [syslog, poc-gce-logging-router]
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

- Após isso, precisaremos acessar os logs da VM no `logging explorer` (pode demorar 1-2 minutos até o log aparecer na interface) se precisar, pode se basear na query:
> resource.type="gce_instance" resource.labels.instance_id="{INSTANCE_ID}" log_name="projects/{PROJECT_ID}/logs/poc-gce-logging-router"

## Conclusão
O agente de monitoramento padrão do google nos permite indexar no cloud logging, com isso nos da possibilidade de automatizar varias coisas no console do GCP.

### Referencias:
- [Instalação do agente](https://cloud.google.com/monitoring/agent/ops-agent/install-index)
- [Documentação do agente](https://cloud.google.com/logging/docs/agent/ops-agent/configuration?hl=pt-br#logging-receivers)
