
# Project variables required to be valid for execution
variable "project_id" {
  description = "GCP Project ID for the workspace and default project ID for monitored resources"
  type        = string
}

variable "monitored_resource_project_id" {
  description = <<-DESCRIPTION
    GCP Project ID for the resource being monitored.
    If left empty, defaults to the workspace host project ID (I.E. The `project_id` variable above).
  DESCRIPTION
  type        = string
  default     = ""
}

output "monitored_resource_project_id" {
  description = "The project in which the resources are being monitored."
  value       = module.stackdriver_alerts.monitored_resource_project_id
}

output "workspace_project_id" {
  description = "The project in which the alerts and notification channels were created."
  value       = module.stackdriver_alerts.workspace_project_id
}

module "stackdriver_alerts" {
  source = "../../"

  # Project variables required to be valid for execution
  project_id                    = var.project_id
  monitored_resource_project_id = var.monitored_resource_project_id

  resource_label = "my-label"

  service_runtime_api_request_latency_policy = [
    {
      service_name     = "bigquery.googleapis.com"
      threshold_value  = 12
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "cloudfunctions.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "composer.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "compute.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "container.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "dataflow.googleapis.com"
      threshold_value  = 18
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "dataproc.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "logging.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "monitoring.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "pubsub.googleapis.com"
      threshold_value  = 15
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "sql-component.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "storage-api.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    },
    {
      service_name     = "storage-component.googleapis.com"
      threshold_value  = 3
      alignment_period = 60
      duration         = 60
    }
  ]

  service_runtime_quota_policy = {
    threshold_value = 1
    duration        = 120
  }
}
