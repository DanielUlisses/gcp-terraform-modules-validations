output "monitored_resource_project_id" {
  description = "The project in which the resources are being monitored."
  value       = local.monitored_resource_project_id
}

output "workspace_project_id" {
  description = "The project in which the alerts and notification channels were created."
  value       = var.project_id
}

output "cluster_names" {
  description = "The clusters for which the node alert policies were created."
  value       = var.gke_cluster_names
}

output "notification_channel_ids" {
  description = "List of all channels created or referenced by this module"
  value       = var.stackdriver_notification_channels
}
