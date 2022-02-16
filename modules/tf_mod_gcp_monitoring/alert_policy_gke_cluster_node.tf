######################################################
# Setup Stackdriver Alert Policies for Cluster nodes #
######################################################

# Allocatable CPU Cores Threshold
resource "google_monitoring_alert_policy" "gke_allocatable_cpu_cores_policy" {
  for_each = (var.gke_allocatable_cpu_cores_policy == null ? [] : var.gke_cluster_names)

  project               = var.project_id
  display_name          = format("GKE Node Allocatable CPU Cores Policy (%s, %s)", var.resource_label, each.value)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "GKE node allocatable CPU cores is under threshold in project ${local.monitored_resource_project_id}, cluster ${each.value}."
  }
  combiner = "OR"
  conditions {
    display_name = "GKE Node Allocatable CPU Cores Condition"
    condition_threshold {
      threshold_value = lookup(var.gke_allocatable_cpu_cores_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.label."cluster_name"="${each.value}"
        AND metric.type="kubernetes.io/node/cpu/allocatable_cores"
        AND resource.type="k8s_node"
      EOT
      duration        = format("%ss", lookup(var.gke_allocatable_cpu_cores_policy, "duration"))
      comparison      = "COMPARISON_LT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gke_allocatable_cpu_cores_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}

# Allocatable Memory Threshold
resource "google_monitoring_alert_policy" "gke_allocatable_memory_policy" {
  for_each = (var.gke_allocatable_memory_policy == null ? [] : var.gke_cluster_names)

  project               = var.project_id
  display_name          = format("GKE Node Allocatable Memory Policy (%s, %s)", var.resource_label, each.value)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "GKE node allocatable memory is under threshold in project ${local.monitored_resource_project_id}, cluster ${each.value}."
  }
  combiner = "OR"
  conditions {
    display_name = "GKE Node Allocatable Memory Condition"
    condition_threshold {
      threshold_value = 1024 * 1024 * 1024 * lookup(var.gke_allocatable_memory_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.label."cluster_name"="${each.value}"
        AND metric.type="kubernetes.io/node/memory/allocatable_bytes"
        AND resource.type="k8s_node"
      EOT
      duration        = format("%ss", lookup(var.gke_allocatable_memory_policy, "duration"))
      comparison      = "COMPARISON_LT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gke_allocatable_memory_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}

# Allocatable Storage Threshold
resource "google_monitoring_alert_policy" "gke_allocatable_storage_policy" {
  for_each = (var.gke_allocatable_storage_policy == null ? [] : var.gke_cluster_names)

  project               = var.project_id
  display_name          = format("GKE Node Allocatable Storage Policy (%s, %s)", var.resource_label, each.value)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "GKE node allocatable storage is under threshold in project ${local.monitored_resource_project_id}, cluster ${each.value}."
  }
  combiner = "OR"
  conditions {
    display_name = "GKE Node Allocatable Storage Condition"
    condition_threshold {
      threshold_value = 1024 * 1024 * 1024 * lookup(var.gke_allocatable_storage_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND resource.label."cluster_name"="${each.value}"
        AND metric.type="kubernetes.io/node/ephemeral_storage/allocatable_bytes"
        AND resource.type="k8s_node"
      EOT
      duration        = format("%ss", lookup(var.gke_allocatable_storage_policy, "duration"))
      comparison      = "COMPARISON_LT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gke_allocatable_storage_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}
