
locals {
  display_name = "Test Notification Channel"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

resource "google_monitoring_notification_channel" "basic" {
  project      = var.project_id
  display_name = local.display_name
  type         = "email"
  labels = {
    email_address = "fake_email@blahblah.com"
  }
}

output "existing_id" {
  description = "List created outside custom notification module"
  value       = google_monitoring_notification_channel.basic.id
}

## The first test run will require an existing notification channel
## Comment out everything below this line for first test run ##

module "notification_channels" {
  source = "../../modules/notification_channels"

  project_id = var.project_id

  resource_label = "my-label"

  notification_existing_channels_by_name = [local.display_name]
  notification_email_addresses           = ["you@yourdomain.com", "me@mydomain.net"] # make sure output format matches

  user_labels = {
    foo = "bar",
  }
}

output "notification_channel_ids" {
  description = "List of channels output by custom module"
  value       = module.notification_channels.notification_channel_ids
}
