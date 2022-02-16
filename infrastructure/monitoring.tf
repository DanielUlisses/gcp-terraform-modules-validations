########################################
# Setup for Stackdriver alert policies #
########################################

output "monitored_resource_project_id" {
  description = "The project in which the resources are being monitored."
  value       = module.stackdriver_alerts.monitored_resource_project_id
}

output "workspace_project_id" {
  description = "The project in which the alerts and notification channels were created."
  value       = module.stackdriver_alerts.workspace_project_id
}

output "notification_channel_ids" {
  description = "List of channels output by custom module"
  value       = module.notification_channels.notification_channel_ids
}

module "stackdriver_alerts" {
  source = "../../modules/tf_mod_gcp_monitoring"

  # Project variables required to be valid for execution
  project_id                    = var.project_id
  monitored_resource_project_id = ""

  resource_label = "gke"

  gke_cluster_names = [module.gke.name]

  gke_connect_dialer_errors_policy = {
    threshold_value  = 0.2
    duration         = 120
    alignment_period = 60
  }

  gke_allocatable_cpu_cores_policy = {
    threshold_value  = 0.5
    duration         = 120
    alignment_period = 60
  }

  gke_allocatable_memory_policy = {
    threshold_value  = 0.5
    duration         = 120
    alignment_period = 60
  }

  gke_allocatable_storage_policy = {
    threshold_value  = 24
    duration         = 120
    alignment_period = 60
  }
}

module "notification_channels" {
  source = "../../modules/tf_mod_gcp_monitoring/modules/notification_channels"

  project_id     = var.project_id
  resource_label = "gke"

  notification_email_addresses = ["dsilva@pythian.com"]
}
