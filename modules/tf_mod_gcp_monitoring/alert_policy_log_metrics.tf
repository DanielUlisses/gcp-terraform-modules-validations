#####################################################
# Setup Log-Based Metric and Related Alert Policies #
#####################################################

### Log Based Metric and Alert Policy ###

# Logging Metric Resource
resource "google_logging_metric" "logging_metric_event" {
  for_each = var.logging_metric_config

  project     = local.monitored_resource_project_id
  name        = each.value["metric_name"]
  description = each.value["metric_description"]
  filter      = format("resource.type=%s AND %s", each.value["resource_type"], each.value["log_filter"])
  metric_descriptor {
    metric_kind = each.value["metric_kind"]
    value_type  = each.value["value_type"]
  }
}

# Logging Metric Alert
resource "google_monitoring_alert_policy" "logging_metric_event_policy" {
  for_each = { for config in var.logging_metric_alert_configs : "${config.logging_metric_config_key}/${config.alert_description}" => config }

  project = var.project_id
  display_name = format("%s (%s, %s)",
    lookup(each.value, "alert_description"),
    google_logging_metric.logging_metric_event[each.value["logging_metric_config_key"]].id,
    var.resource_label,
  )
  notification_channels = var.stackdriver_notification_channels

  combiner = "OR"
  conditions {
    display_name = format("%s (%s)", lookup(each.value, "condition_name"), var.resource_label)
    condition_threshold {
      threshold_value = lookup(each.value, "threshold_value")
      filter          = <<-FILTER
      resource.label."project_id"=${local.monitored_resource_project_id}
      AND resource.type="${var.logging_metric_config[each.value["logging_metric_config_key"]]["resource_type"]}"
      AND metric.type="logging.googleapis.com/user/${google_logging_metric.logging_metric_event[each.value["logging_metric_config_key"]].id}"
      FILTER
      comparison      = lookup(each.value, "comparison")
      duration        = format("%ss", lookup(each.value, "duration"))
      aggregations {
        alignment_period   = format("%ss", lookup(each.value, "alignment_period"))
        per_series_aligner = lookup(each.value, "aligner")
        group_by_fields    = formatlist("%s", lookup(each.value, "group_by"))
      }
    }
  }
}
