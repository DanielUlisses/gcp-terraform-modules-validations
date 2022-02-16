#####################################################################
# Setup Stackdriver Service Runtime Alert Policies for EDP Projects #
#####################################################################

### Service Runtime ###

# API Request Latency
resource "google_monitoring_alert_policy" "service_runtime_api_request_latency_policy" {
  project               = var.project_id
  display_name          = "Service API Latency Policy (${var.resource_label}, ${element(split(".", lookup(var.service_runtime_api_request_latency_policy[count.index], "service_name", "")), 0)})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "The ${element(split(".", lookup(var.service_runtime_api_request_latency_policy[count.index], "service_name")), 0)} API is experiencing high latency in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Service API Latency Condition (${element(split(".", lookup(var.service_runtime_api_request_latency_policy[count.index], "service_name")), 0)})"
    condition_threshold {
      threshold_value = lookup(var.service_runtime_api_request_latency_policy[count.index], "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="serviceruntime.googleapis.com/api/request_latencies"
        AND resource.type="consumed_api"
        AND resource.label.service="${lookup(var.service_runtime_api_request_latency_policy[count.index], "service_name", "")}"
      EOT
      comparison      = "COMPARISON_GT"
      duration        = format("%ss", lookup(var.service_runtime_api_request_latency_policy[count.index], "duration"))
      aggregations {
        alignment_period     = format("%ss", lookup(var.service_runtime_api_request_latency_policy[count.index], "alignment_period"))
        per_series_aligner   = "ALIGN_PERCENTILE_95"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  count = length(var.service_runtime_api_request_latency_policy)
}

# Consumer Quota Exceeded
resource "google_monitoring_alert_policy" "service_runtime_quota_policy" {
  project               = var.project_id
  display_name          = "Service Runtime Quota Exceeded Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "A quota limit has been exceeded in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Service Quota Limit Exceeded Condition"
    condition_threshold {
      threshold_value = lookup(var.service_runtime_quota_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="serviceruntime.googleapis.com/quota/exceeded"
        AND resource.type="consumer_quota"
      EOT
      comparison      = "COMPARISON_GT"
      duration        = format("%ss", lookup(var.service_runtime_quota_policy, "duration"))
    }
  }

  count = (var.service_runtime_quota_policy == null ? 0 : 1)
}
