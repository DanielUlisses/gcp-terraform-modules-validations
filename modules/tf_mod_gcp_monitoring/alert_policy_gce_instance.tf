##################################################
# Setup Stackdriver Alert Policies for Instances #
##################################################

# Compute CPU Threshold
resource "google_monitoring_alert_policy" "cpu_usage_policy" {
  project               = var.project_id
  display_name          = format("Compute Instance CPU Usage Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Compute instance CPU utilization is over threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Compute Instance CPU Usage Condition"
    condition_threshold {
      threshold_value = lookup(var.cpu_usage_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="compute.googleapis.com/instance/cpu/utilization"
        AND resource.type="gce_instance"
      EOT
      duration        = format("%ss", lookup(var.cpu_usage_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.cpu_usage_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  count = (var.cpu_usage_policy == null ? 0 : 1)
}

# Compute Disk Throttle Read
resource "google_monitoring_alert_policy" "disk_read_throttled_ops_count_policy" {
  project               = var.project_id
  display_name          = format("Compute Instance Disk Read Throttling Alert Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Compute instance storage is being throttled on reads in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Compute Instance Disk Read Operations Usage Condition"
    condition_threshold {
      threshold_value = lookup(var.disk_read_io_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="compute.googleapis.com/instance/disk/throttled_read_ops_count"
        AND resource.type="gce_instance"
      EOT
      duration        = format("%ss", lookup(var.disk_read_io_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.disk_read_io_policy, "alignment_period"))
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  count = (var.disk_read_io_policy == null ? 0 : 1)
}

# Compute Disk Throttle Write
resource "google_monitoring_alert_policy" "disk_write_throttled_ops_count_policy" {
  project               = var.project_id
  display_name          = format("Compute Instance Disk Write Throttling Alert Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Compute instance storage is being throttled on writes in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Compute Instance Disk Write Operations Usage Condition"
    condition_threshold {
      threshold_value = lookup(var.disk_write_io_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="compute.googleapis.com/instance/disk/throttled_write_ops_count"
        AND resource.type="gce_instance"
      EOT
      duration        = format("%ss", lookup(var.disk_write_io_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.disk_write_io_policy, "alignment_period"))
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }

  count = (var.disk_write_io_policy == null ? 0 : 1)
}

# Compute Instance Uptime
resource "google_monitoring_alert_policy" "gce_instance_uptime_policy" {
  project               = var.project_id
  display_name          = format("Compute Instance Uptime Alert Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Compute instance uptime is below threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Compute Instance Uptime Condition"
    condition_threshold {
      threshold_value = lookup(var.gce_instance_uptime_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="compute.googleapis.com/instance/uptime"
        AND resource.type="gce_instance"
      EOT
      duration        = format("%ss", lookup(var.gce_instance_uptime_policy, "duration"))
      comparison      = "COMPARISON_LT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gce_instance_uptime_policy, "alignment_period"))
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  count = (var.gce_instance_uptime_policy == null ? 0 : 1)
}
# Compute Agent Disk Usage
resource "google_monitoring_alert_policy" "gce_instance_disk_usage_policy" {
  project               = var.project_id
  display_name          = format("Compute Agent Disk Usage Alert Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Compute instance disk usage is over threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Compute Agent Disk Usage Condition"
    condition_threshold {
      threshold_value = lookup(var.gce_instance_disk_usage_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="agent.googleapis.com/disk/percent_used"
        AND resource.type="gce_instance"
        AND metric.labels.state="used"
        AND metric.labels.device!=starts_with("loop")
      EOT
      duration        = format("%ss", lookup(var.gce_instance_disk_usage_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gce_instance_disk_usage_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  count = (var.gce_instance_disk_usage_policy == null ? 0 : 1)
}
# Compute Agent Memory Usage
resource "google_monitoring_alert_policy" "gce_instance_memory_usage_policy" {
  project               = var.project_id
  display_name          = format("Compute Agent Memory Usage Alert Policy(%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Compute instance memory usage is over threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Compute Agent Memory Usage Condition"
    condition_threshold {
      threshold_value = lookup(var.gce_instance_memory_usage_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="agent.googleapis.com/memory/percent_used"
        AND resource.type="gce_instance"
        AND metric.labels.state="used"
      EOT
      duration        = format("%ss", lookup(var.gce_instance_memory_usage_policy, "duration"))
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", lookup(var.gce_instance_memory_usage_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  count = (var.gce_instance_memory_usage_policy == null ? 0 : 1)
}
