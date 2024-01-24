# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "poc-gce-logging-router" {
    boot_disk {
        auto_delete = true
        device_name = "poc-gce-logging-router"

        initialize_params {
        image = "projects/debian-cloud/global/images/debian-11-bullseye-v20240110"
        size  = 10
        type  = "pd-balanced"
        }

        mode = "READ_WRITE"
    }

    can_ip_forward      = false
    deletion_protection = false
    enable_display      = false

    labels = {
        goog-ec-src           = "vm_add-tf"
        goog-ops-agent-policy = "v2-x86-template-1-1-0"
    }

    machine_type = "e2-medium"

    metadata = {
        enable-osconfig = "TRUE"
    }

    name = "poc-gce-logging-router"

    network_interface {
        access_config {
        network_tier = "PREMIUM"
        }

        queue_count = 0
        stack_type  = "IPV4_ONLY"
        subnetwork  = "projects/{TF_PROJECT_ID}/regions/us-central1/subnetworks/{TF_VPC_NETWORK}"
    }

    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        preemptible         = false
        provisioning_model  = "STANDARD"
    }

    service_account {
        email  = "498298766729-compute@developer.gserviceaccount.com"
        scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
    }

    shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
        enable_vtpm                 = true
    }

    tags = ["poc-gce-logging-router"]
    zone = "us-central1-a"
}
