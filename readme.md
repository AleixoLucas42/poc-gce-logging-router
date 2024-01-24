# Log routing from compute engine file to GCP cloud logging
This repository is intended as a proof of concept for redirecting
an application's logs to GCP cloud logging using Google's ops-agent.

## Creation of the compute engine
> cd terraform && terraform init

> terraform plan

> terraform apply

## Installing the test application
The application uses port 5000, if there is a firewall, this port must be allowed.

- Connect to the vm via ssh and run:
> git clone https://github.com/AleixoLucas42/poc-gce-logging-router.git

> sudo bash poc-gce-logging-router/install.sh

## Testing
- Sending a GET request to the server address:port, internal or external, should return: `Populating /var/log/poc-gce-logging-router.log`
> curl 127.0.0.1:5000/
- (Optional) check the file `/var/log/poc-gce-logging-router.log` if it is being populated:
> cat /var/log/poc-gce-logging-router.log
- If it is not working, you can check the log with the command:
> journalctl -u poc-gce-logging-router.service

## Configure ops-agent to collect custom logs
- The first step is to ensure that the google ops-agent monitoring agent is installed; if terraform was not used to create the machine,
it is necessary to install. To install, just go to the observability tab of the machine in question on compute engine itself and some metrics will appear there,
however, others do not, and Google will recommend installing the agent. To install, just press a button on the interface and wait 1-2 minutes. If you have trouble finding the installer in the interface, this [documentation](https://cloud.google.com/monitoring/agent/ops-agent/install-index) may help.

- Once installed, it is necessary to configure an agent file according to [documentation](https://cloud.google.com/logging/docs/agent/ops-agent/configuration?hl=pt-br);
For our scenario it will look like this:
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

- Now we will need to restart the agent
>  sudo systemctl restart google-cloud-ops-agent"*"

- After that, we check VM logs in the `logging explorer` (it may take 1-2 minutes for the log to appear in the interface) if necessary, you can use the query:
> resource.type="gce_instance" resource.labels.instance_id="{INSTANCE_ID}" log_name="projects/{PROJECT_ID}/logs/poc-gce-logging-router"

## Conclusion
Google's standard monitoring agent allows us to index custom log files in cloud logging, which gives us the possibility of automating several things in the GCP console.

### References:
- [Agent installation](https://cloud.google.com/monitoring/agent/ops-agent/install-index)
- [Agent documentation](https://cloud.google.com/logging/docs/agent/ops-agent/configuration?hl=pt-br#logging-receivers)
