
# Google expects slack notification channels to be created manually
# and acquiring an auth_token for slack is not well defined
# https://cloud.google.com/monitoring/support/notification-options#slack
resource "google_monitoring_notification_channel" "slack_notification_channels" {
  for_each = var.notification_slack == null ? toset([]) : var.notification_slack.channels

  display_name = format("Slack Alert Notification Channel (%s, %s)", var.resource_label, each.value)
  project      = var.project_id
  type         = "slack"

  labels = {
    channel_name = each.value
  }

  # IMPORTANT: Do not commit secrets to your repository!
  # It is highly recommended to encrypt secrets with KMS.
  # Use the google_kms_secret data source to pass the value into this module.
  # https://www.terraform.io/docs/providers/google/d/google_kms_secret.html
  sensitive_labels {
    # Warning: All arguments will be stored in the raw state as plain-text
    auth_token = var.notification_slack.auth_token
  }

  user_labels = local.user_labels
}
