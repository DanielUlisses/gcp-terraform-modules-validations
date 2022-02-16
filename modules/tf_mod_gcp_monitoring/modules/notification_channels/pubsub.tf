
resource "google_monitoring_notification_channel" "pubsub_notification_channels" {
  for_each = var.notification_pubsub_topics

  display_name = format("Pubsub Alert Notification Channel (%s, %s)", var.resource_label, each.value)
  project      = var.project_id
  type         = "pubsub"

  labels = {
    topic = each.value
  }

  user_labels = local.user_labels
}
