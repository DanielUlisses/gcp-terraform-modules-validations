###############################################
# Setup Stackdriver Alert Policies for Pubsub #
###############################################

# Subscription Undelivered Messages

resource "google_monitoring_alert_policy" "pubsub_subscription_undelivered_messages_policy" {
  project               = var.project_id
  display_name          = "Pubsub Subscription Undelivered Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Pubsub subscription has undelivered messages higher than threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Subscription Undelivered Message Condition"
    condition_threshold {
      threshold_value = lookup(var.pubsub_subscription_unacked_messages_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="pubsub.googleapis.com/subscription/num_undelivered_messages"
        AND resource.type="pubsub_subscription"
      EOT
      duration        = format("%ss", lookup(var.pubsub_subscription_unacked_messages_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.pubsub_subscription_unacked_messages_policy, "alignment_period"))
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  count = (var.pubsub_subscription_unacked_messages_policy == null ? 0 : 1)
}

# Topic Unacked Messages

resource "google_monitoring_alert_policy" "pubsub_topic_unacked_messages_policy" {
  project               = var.project_id
  display_name          = "Pubsub Topic Unacked Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Pubsub topic has unacked messages higher than threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Topic Unacked Message Condition"
    condition_threshold {
      threshold_value = lookup(var.pubsub_topic_unacked_messages_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="pubsub.googleapis.com/topic/num_unacked_messages_by_region"
        AND resource.type="pubsub_topic"
      EOT
      duration        = format("%ss", lookup(var.pubsub_topic_unacked_messages_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.pubsub_topic_unacked_messages_policy, "alignment_period"))
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  count = (var.pubsub_topic_unacked_messages_policy == null ? 0 : 1)
}
