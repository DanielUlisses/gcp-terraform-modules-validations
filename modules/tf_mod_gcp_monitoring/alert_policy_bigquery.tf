
#################################################
# Setup Stackdriver Alert Policies for Bigquery #
#################################################

# Slots
resource "google_monitoring_alert_policy" "bigquery_slots_policy" {
  project               = var.project_id
  display_name          = format("Bigquery Slots Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = format("Bigquery has less than %s slot(s) available in project %s.", var.bigquery_slots_policy["threshold_value"], var.project_id)
  }
  combiner = "OR"
  conditions {
    display_name = "EDP Bigquery Available Slots Condition"
    condition_threshold {
      threshold_value = var.bigquery_slots_policy["threshold_value"]
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="bigquery.googleapis.com/slots/total_available"
        AND resource.type="global"
      EOT
      comparison      = "COMPARISON_LT"
      duration        = format("%ss", var.bigquery_slots_policy["duration"])
      aggregations {
        alignment_period   = format("%ss", var.bigquery_slots_policy["alignment_period"])
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  count = var.bigquery_slots_policy == null ? 0 : 1
}
