output "project_id" {
  description = "The project for which the notification channels were created."
  value       = var.project_id
}

output "notification_channel_ids" {
  description = "List of all channels created or referenced by this module"
  value = concat(
    [for channel in google_monitoring_notification_channel.email_notification_channels : channel.id],
    [for channel in google_monitoring_notification_channel.slack_notification_channels : channel.id],
    [for channel in data.google_monitoring_notification_channel.existing_channels_by_name : channel.id],
    [for channel in google_monitoring_notification_channel.pubsub_notification_channels : channel.id],
    [for channel in google_monitoring_notification_channel.webhook_basicauth_notification_channels : channel.id],
    [for channel in google_monitoring_notification_channel.webhook_tokenauth_notification_channels : channel.id],
  )
}
