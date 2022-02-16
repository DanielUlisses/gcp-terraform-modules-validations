# Local variables
locals {
  monitored_resource_project_id = var.monitored_resource_project_id != "" ? var.monitored_resource_project_id : var.project_id
}
