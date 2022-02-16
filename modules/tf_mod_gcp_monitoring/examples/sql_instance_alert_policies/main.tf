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

  sql_instance_uptime_policy = {
      threshold_value  = 1
      duration         = 60
      alignment_period = 60
  }

  sql_cpu_utilization_policy = {
      threshold_value  = 0.85
      duration         = 300
      alignment_period = 60
  }

  sql_instance_memory_quota_policy = {
    threshold_value  = 1649267441664
    duration         = 120
    alignment_period = 60
  }
  
  sql_instance_memory_usage_policy = {
    threshold_value  = 274877906944
    duration         = 120
    alignment_period = 60
  }

  sql_instance_memory_utilization_policy = {
    threshold_value  = 85
    duration         = 120
    alignment_period = 60
  }

  sql_instance_disk_quota_policy = {
    threshold_value  = 2199023255552
    duration         = 120
    alignment_period = 60
  }

  sql_instance_disk_utilization_policy = {
    threshold_value  = 85
    duration         = 120
    alignment_period = 60
  }

  sql_instance_disk_read_io_policy = {
    threshold_value  = 1000
    duration         = 60
    alignment_period = 60
  }

  sql_instance_disk_write_io_policy = {
    threshold_value  = 1000
    duration         = 60
    alignment_period = 60
  }
}
