
resource "google_monitoring_notification_channel" "email_notification_channels" {
  for_each = var.notification_email_addresses

  display_name = format("Email Alert Notification Channel (%s, %s)", var.resource_label, each.value)
  project      = var.project_id
  type         = "email"

  labels = {
    email_address = each.value
  }
  user_labels = local.user_labels
}
