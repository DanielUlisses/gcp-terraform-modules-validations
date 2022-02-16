
# IMPORTANT: Do not commit secrets to your repository!
# It is highly recommended to encrypt secrets with KMS.
# Use the google_kms_secret data source to pass the value into this module.
# https://www.terraform.io/docs/providers/google/d/google_kms_secret.html

resource "google_monitoring_notification_channel" "webhook_basicauth_notification_channels" {
  for_each = { for config in var.notification_webhook_basicauth : "${config.username}@${config.url}" => config }

  display_name = format("Webhook Basic Auth Alert Notification Channel (%s, %s)", var.resource_label, each.key)
  project      = var.project_id
  type         = "webhook_basicauth"

  labels = {
    url      = each.value.url
    username = each.value.username
  }

  # Warning: All arguments will be stored in the raw state as plain-text
  sensitive_labels {
    password = each.value.password
  }

  user_labels = local.user_labels
}

resource "google_monitoring_notification_channel" "webhook_tokenauth_notification_channels" {
  for_each = var.notification_webhook_tokenauth

  # WARNING: URL including any sensitive URL parameters are exposed to anyone with access to the project
  # Despite this you should still not store these sensitive parameters in the repository unencrypted
  display_name = format("Webhook Alert Notification Channel (%s, %s)", var.resource_label, each.value)
  project      = var.project_id
  type         = "webhook_tokenauth"

  labels = {
    url = each.value
  }

  user_labels = local.user_labels
}
