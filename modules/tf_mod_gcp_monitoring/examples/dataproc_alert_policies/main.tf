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

  # Project variables required to be valid for execution
  project_id                    = var.project_id
  monitored_resource_project_id = var.monitored_resource_project_id

  resource_label = "my-label"

  dataproc_job_failed_policy = {
    threshold_value  = 1
    duration         = 60
    alignment_period = 60
  }

  dataproc_job_duration_policy = {
    threshold_value  = 3600
    duration         = 60
    alignment_period = 60
  }
}
