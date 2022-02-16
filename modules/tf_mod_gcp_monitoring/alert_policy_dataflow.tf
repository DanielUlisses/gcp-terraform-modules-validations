#################################################
# Setup Stackdriver Alert Policies for Dataflow #
#################################################

# Dataflow Job Failed
resource "google_monitoring_alert_policy" "dataflow_job_failed_policy" {
  project               = var.project_id
  display_name          = "EDP Dataflow Job Failed Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Dataflow job has failed in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDP Dataflow Job Failed Condition"
    condition_threshold {
      threshold_value = var.dataflow_job_failed_policy.threshold_value
      filter          = <<-EOT
        metric.type="dataflow.googleapis.com/job/is_failed"
        AND resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.type="dataflow_job"
      EOT
      duration        = format("%ss", var.dataflow_job_failed_policy.duration)
      comparison      = "COMPARISON_LT"
      aggregations {
        group_by_fields    = ["resource.labels.job_name"]
        alignment_period   = format("%ss", var.dataflow_job_failed_policy.alignment_period)
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  count = var.dataflow_job_failed_policy == null ? 0 : 1
}


# Dataflow Job Elapsed Time
resource "google_monitoring_alert_policy" "dataflow_elapsed_time_policy" {
  project               = var.project_id
  display_name          = "EDP Dataflow Elapsed Time Policy (${var.resource_label}, ${var.dataflow_elapsed_time_policy[count.index].friendly_name})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Dataflow batch job elapsed time is longer than ${var.dataflow_elapsed_time_policy[count.index].duration} in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDP Dataflow Elapsed Time Condition (${var.resource_label}, ${var.dataflow_elapsed_time_policy[count.index].friendly_name})"
    condition_threshold {
      threshold_value = var.dataflow_elapsed_time_policy[count.index].threshold_value
      filter          = <<-EOT
        metric.type="dataflow.googleapis.com/job/elapsed_time"
        AND resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.type="dataflow_job"
        AND resource.label.job_name=starts_with("${var.dataflow_elapsed_time_policy[count.index].job_name}")
      EOT
      comparison      = "COMPARISON_GT"
      duration        = format("%ss", var.dataflow_elapsed_time_policy[count.index].duration)
      aggregations {
        group_by_fields    = ["resource.labels.job_name"]
        alignment_period   = format("%ss", var.dataflow_elapsed_time_policy[count.index].alignment_period)
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  count = var.dataflow_elapsed_time_policy == null ? 0 : length(var.dataflow_elapsed_time_policy)
}

# Dataflow System Lag
resource "google_monitoring_alert_policy" "dataflow_job_system_lag_policy" {
  project               = var.project_id
  display_name          = "EDP Dataflow System Lag Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Dataflow job has failed to process data for longer than threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDP Dataflow System Lag Condition"
    condition_threshold {
      threshold_value = var.dataflow_job_system_lag_policy.threshold_value
      filter          = <<-EOT
        metric.type="dataflow.googleapis.com/job/system_lag"
        AND resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.type="dataflow_job"
      EOT
      duration        = format("%ss", var.dataflow_job_system_lag_policy.duration)
      comparison      = "COMPARISON_GT"
      aggregations {
        group_by_fields    = ["resource.labels.job_name"]
        alignment_period   = format("%ss", var.dataflow_job_system_lag_policy.alignment_period)
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  count = var.dataflow_job_system_lag_policy == null ? 0 : 1
}
