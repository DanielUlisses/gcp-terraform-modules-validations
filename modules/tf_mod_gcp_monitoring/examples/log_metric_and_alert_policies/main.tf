########################################
# Setup for Stackdriver alert policies #
########################################

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

  # Projects must be valid for execution
  project_id                    = var.project_id
  monitored_resource_project_id = var.monitored_resource_project_id

  resource_label = "my-label"

  logging_metric_config = {
    my-metric = {
      metric_name        = "function-error-events"
      log_filter         = "severity>=ERROR"
      metric_description = "Cloud Function Error Events"
      metric_kind        = "DELTA"
      resource_type      = "cloud_function"
      value_type         = "INT64"
    }
  }

  logging_metric_alert_configs = [
    {
      logging_metric_config_key = "my-metric" # Linked to logging_metric_config map keys in this module
      alert_description         = "Cloud Function Logged Error Events Policy"
      aligner                   = "ALIGN_SUM"
      alignment_period          = 60
      comparison                = "COMPARISON_GT"
      condition_name            = "Cloud Function Logged Error Events Condition"
      duration                  = 0
      group_by                  = "resource.labels.function_name"
      threshold_value           = 0
    },
  ]
}
