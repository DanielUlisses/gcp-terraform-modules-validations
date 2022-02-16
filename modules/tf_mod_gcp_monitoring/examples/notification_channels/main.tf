########################################
# Setup for Stackdriver alert policies #
########################################

# Project variables required to be valid for execution
variable "project_id" {
  description = "GCP Project ID for the workspace and default project ID for monitored resources"
  type        = string
}

output "monitored_resource_project_id" {
  description = "The project in which the resources are being monitored."
  value       = module.stackdriver_alerts.monitored_resource_project_id
}

output "workspace_project_id" {
  description = "The project in which the alerts and notification channels were created."
  value       = module.stackdriver_alerts.workspace_project_id
}

output "notification_channel_ids" {
  description = "List of channels output by custom module"
  value       = module.stackdriver_alerts.notification_channel_ids
}

locals {
  # Use KMS secret data source to handle secret decryption and pass decrypted secrets to module
  # https://www.terraform.io/docs/providers/google/d/google_kms_secret.html
  secret_plaintext = "do-not-store-secrets-in-your-repository"
}

module "notification_channels" {
  source = "../../modules/notification_channels"

  # Projects must be valid for execution
  project_id = var.project_id

  resource_label = "my-notification-channel-resource-label"
  user_labels = {
    my-user-label-key = "my-user-label-value",
  }

  notification_email_addresses   = ["foo@example.com", "bar@example.com"]
  notification_webhook_tokenauth = ["https://example.com?auth_token=${local.secret_plaintext}"]
  notification_webhook_basicauth = [{
    url      = "https://example.com/my-webhook"
    username = "my-user"
    password = local.secret_plaintext
  }]
  notification_pubsub_topics = ["projects/${var.project_id}/topics/my-topic"]
}


module "stackdriver_alerts" {
  source = "../../"

  # Projects must be valid for execution
  project_id = var.project_id

  resource_label = "my-alert-resource-label"

  # notification channels to use for all policies defined by this module
  stackdriver_notification_channels = module.notification_channels.notification_channel_ids

  # example policy
  bigquery_slots_policy = {
    alignment_period = 60
    duration         = 60
    threshold_value  = 32
  }
}
