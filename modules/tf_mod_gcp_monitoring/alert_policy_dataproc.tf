#################################################
# Setup Stackdriver Alert Policies for Dataflow #
#################################################

# Dataproc Job Failed
resource "google_monitoring_alert_policy" "dataproc_job_failed_policy" {
  project               = var.project_id
  display_name          = "Dataproc Job Failed Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Dataproc job has failed in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Dataproc Job Failed Condition"
    condition_threshold {
      threshold_value = var.dataproc_job_failed_policy.threshold_value
      filter          = <<-EOT
        metric.type="dataproc.googleapis.com/cluster/job/failed_count"
        AND resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.type="cloud_dataproc_cluster"
      EOT
      duration        = format("%ss", var.dataproc_job_failed_policy.duration)
      comparison      = "COMPARISON_GT"
      aggregations {
        group_by_fields      = ["metric.labels.job_type"]
        alignment_period     = format("%ss", var.dataproc_job_failed_policy.alignment_period)
        per_series_aligner   = "ALIGN_COUNT"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  count = var.dataproc_job_failed_policy == null ? 0 : 1
}

# Dataproc Job Duration
resource "google_monitoring_alert_policy" "dataproc_job_duration_policy" {
  project               = var.project_id
  display_name          = "Dataproc Job Duration Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Dataproc job has completed with a duration above the configured threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Dataproc Job Duration Condition"
    condition_threshold {
      threshold_value = var.dataproc_job_duration_policy.threshold_value
      filter          = <<-EOT
        metric.type="dataproc.googleapis.com/cluster/job/completion_time"
        AND resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.type="cloud_dataproc_cluster"
      EOT
      duration        = format("%ss", var.dataproc_job_duration_policy.duration)
      comparison      = "COMPARISON_GT"
      aggregations {
        group_by_fields      = ["metric.labels.job_type"]
        alignment_period     = format("%ss", var.dataproc_job_duration_policy.alignment_period)
        per_series_aligner   = "ALIGN_PERCENTILE_95"
      }
    }
  }

  count = var.dataproc_job_duration_policy == null ? 0 : 1
}