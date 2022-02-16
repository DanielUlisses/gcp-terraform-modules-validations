#################################################
# Setup Stackdriver Alert Policies for Clusters #
#################################################

# Allocatable CPU Cores Threshold
resource "google_monitoring_alert_policy" "gke_connect_dialer_errors_policy" {
  for_each = (var.gke_connect_dialer_errors_policy == null ? [] : var.gke_cluster_names)

  project               = var.project_id
  display_name          = format("GKE Cluster Connect Dialer Errors Policy (%s, %s)", var.resource_label, each.value)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "GKE cluster connect dialer errors are above threshold in project ${local.monitored_resource_project_id}, cluster ${each.value}."
  }
  combiner = "OR"
  conditions {
    display_name = "GKE Cluster Connect Dialer Error Rate Condition"
    condition_threshold {
      threshold_value = lookup(var.gke_connect_dialer_errors_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.label."cluster_name"="${each.value}"
        AND metric.type="kubernetes.io/anthos/gkeconnect_dialer_connection_errors_total"
        AND resource.type="k8s_pod"
      EOT
      duration        = format("%ss", lookup(var.gke_connect_dialer_errors_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gke_connect_dialer_errors_policy, "alignment_period"))
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}
