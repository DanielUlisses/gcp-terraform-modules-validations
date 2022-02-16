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

  composer_db_health_policy = {
    threshold_value  = 1
    duration         = 60
    alignment_period = 60
  }

  composer_environment_health_policy = {
    threshold_value  = 1
    duration         = 60
    alignment_period = 60
  }

  composer_task_queue_length_policy = {
    threshold_value  = 16
    duration         = 120
    alignment_period = 120
  }

  composer_workflow_failed_run_count_policy = {
    threshold_value  = 0
    duration         = 0
    alignment_period = 60
    state_filter     = "failed"
  }

  composer_workflow_failed_task_run_count_policy = {
    threshold_value  = 0
    duration         = 0
    alignment_period = 60
    state_filter     = "failed"
  }

  composer_workflow_run_duration_policy = [
    {
      threshold_value  = 600
      alignment_period = 60
      duration         = 0
      friendly_name    = "policy name",
      workflow_name    = "my-workflow",
    },
    {
      threshold_value  = 1200
      alignment_period = 120
      duration         = 0
      friendly_name    = "second policy name",
      workflow_name    = "my-workflow-2",
    }
  ]
}
