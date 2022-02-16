variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

module "notification_channels" {
  source = "../../modules/notification_channels"

  project_id = var.project_id

  resource_label = "my-resource-label"

  notification_pubsub_topics = ["projects/${var.project_id}/topics/my-topic"]
}

output "notification_channel_ids" {
  description = "List of channels output by custom module"
  value       = module.notification_channels.notification_channel_ids
}
