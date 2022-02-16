##################################################
# Setup Stackdriver Alert Policies for Cloud SQL #
##################################################

# SQL Instance uptime Policy
resource "google_monitoring_alert_policy" "sql_instance_state_alert_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Uptime Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Uptime is below threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Uptime Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_uptime_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/up"
        AND resource.type="cloudsql_database"
      EOT
      duration        = format("%ss", lookup(var.sql_instance_uptime_policy, "duration"))
      comparison = "COMPARISON_LT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = format("%ss", lookup(var.sql_instance_uptime_policy, "alignment_period"))
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }
    }
  }
  count = (var.sql_instance_uptime_policy == null ? 0 : 1)
}

# SQL CPU Utilization Policy
resource "google_monitoring_alert_policy" "sql_cpu_alert_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - CPU utilization Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance CPU utilization is over threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - CPU utilization Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_cpu_utilization_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/cpu/utilization"
        AND resource.type="cloudsql_database"
      EOT
      duration        = format("%ss", lookup(var.sql_cpu_utilization_policy, "duration"))
      comparison = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = format("%ss", lookup(var.sql_cpu_utilization_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields    = ["resource.labels.database_id"]
      }
    }
  }
  count = (var.sql_cpu_utilization_policy == null ? 0 : 1)
}

# SQL Instance Total Memory quota Policy
resource "google_monitoring_alert_policy" "sql_instance_memory_quota_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Total Memory quota Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Total Memory quota is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Total Memory quota Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_memory_quota_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/memory/quota"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_memory_quota_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = format("%ss", lookup(var.sql_instance_memory_quota_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }
  count = (var.sql_instance_memory_quota_policy == null ? 0 : 1)
}

# SQL Instance Total Memory Usage Policy
resource "google_monitoring_alert_policy" "sql_instance_memory_usage_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Total Memory Usage Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Total Memory Usage is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Total Memory Usage Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_memory_usage_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/memory/usage"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_memory_usage_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = format("%ss", lookup(var.sql_instance_memory_usage_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }
  count = (var.sql_instance_memory_usage_policy == null ? 0 : 1)
}

# SQL Instance Memory Utilization Policy
resource "google_monitoring_alert_policy" "sql_instance_memory_utilization_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Memory Utilization Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Memory Utilization is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Memory Utilization Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_memory_utilization_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/memory/utilization"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_memory_utilization_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = format("%ss", lookup(var.sql_instance_memory_utilization_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields    = ["resource.labels.database_id"]
      }
    }
  }
  count = (var.sql_instance_memory_utilization_policy == null ? 0 : 1)
}

# SQL Instance Total Disk quota Policy
resource "google_monitoring_alert_policy" "sql_instance_disk_quota_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Total Disk quota Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Total Disk quota is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Total Disk quota Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_disk_quota_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/disk/quota"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_disk_quota_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = format("%ss", lookup(var.sql_instance_disk_quota_policy, "alignment_period"))
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }
  count = (var.sql_instance_disk_quota_policy == null ? 0 : 1)
}

# SQL Instance Disk Utilization Policy
resource "google_monitoring_alert_policy" "sql_instance_disk_utilization_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Disk Utilization Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Disk Utilization is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Disk Utilization Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_disk_utilization_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/disk/utilization"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_disk_utilization_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = format("%ss", lookup(var.sql_instance_disk_utilization_policy, "alignment_period"))
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.labels.database_id"]
      }
    }
  }
  count = (var.sql_instance_disk_utilization_policy == null ? 0 : 1)
}

# SQL Instance Disk read IO Policy
resource "google_monitoring_alert_policy" "sql_instance_disk_read_io_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Disk read IO Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Disk read IO operations is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Disk read IO Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_disk_read_io_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/disk/read_ops_count"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_disk_read_io_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = format("%ss", lookup(var.sql_instance_disk_read_io_policy, "alignment_period"))
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.labels.database_id"]
      }
    }
  }
  count = (var.sql_instance_disk_read_io_policy == null ? 0 : 1)
}

# SQL Instance Disk write IO Policy
resource "google_monitoring_alert_policy" "sql_instance_disk_write_io_policy" {
  project               = var.project_id
  display_name          = format("Cloud SQL - Instance Disk write IO Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "SQL instance Disk write IO operations is above threshold in project ${local.monitored_resource_project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "Cloud SQL Instance - Disk write IO Condition"
    condition_threshold {
      threshold_value = lookup(var.sql_instance_disk_write_io_policy, "threshold_value")
      filter          = <<-EOT
        resource.label."project_id"="${local.monitored_resource_project_id}"
        AND metric.type="cloudsql.googleapis.com/database/disk/write_ops_count"
        AND resource.type="cloudsql_database"
      EOT
      duration    = format("%ss", lookup(var.sql_instance_disk_write_io_policy, "duration"))
      comparison  = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = format("%ss", lookup(var.sql_instance_disk_write_io_policy, "alignment_period"))
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.labels.database_id"]
      }
    }
  }
  count = (var.sql_instance_disk_write_io_policy == null ? 0 : 1)
}
