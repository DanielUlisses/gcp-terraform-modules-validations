variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

module "notification_channels" {
  source = "../../modules/notification_channels"

  project_id = var.project_id

  resource_label = "my-label"

  notification_email_addresses = ["you@yourdomain.com", "me@mydomain.net"]
}

output "notification_channel_ids" {
  description = "List of channels output by custom module"
  value       = module.notification_channels.notification_channel_ids
}
