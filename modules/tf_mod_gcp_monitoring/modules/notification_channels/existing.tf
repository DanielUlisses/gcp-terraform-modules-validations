data "google_monitoring_notification_channel" "existing_channels_by_name" {
  for_each     = var.notification_existing_channels_by_name
  display_name = each.value
  project      = var.project_id
}
