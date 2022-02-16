#######################################################
# Setup Stackdriver Alert Policies for Cloud Composer #
#######################################################

# Composer Database Health
resource "google_monitoring_alert_policy" "composer_db_health_policy" {
  project               = var.project_id
  display_name          = format("EDL Composer Database Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Cloud Composer database is unhealthy in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDL Composer Database Unhealthy Condition"
    condition_threshold {
      threshold_value = var.composer_db_health_policy.threshold_value
      filter          = <<-EOT
        resource.label.project_id="${local.monitored_resource_project_id}"
        AND metric.type="composer.googleapis.com/environment/database_health"
        AND resource.type="cloud_composer_environment"
      EOT
      comparison      = "COMPARISON_LT"
      duration        = format("%ss", var.composer_db_health_policy.duration)
      aggregations {
        alignment_period   = format("%ss", var.composer_db_health_policy.alignment_period)
        per_series_aligner = "ALIGN_COUNT_TRUE"
      }
    }
  }

  count = var.composer_db_health_policy == null ? 0 : 1
}

# Composer Environment Health
resource "google_monitoring_alert_policy" "composer_environment_health_policy" {
  project               = var.project_id
  display_name          = format("EDL Composer Environment Health Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Cloud Composer environment is unhealthy in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDL Composer Environment Unhealthy Condition"
    condition_threshold {
      threshold_value = var.composer_environment_health_policy.threshold_value
      filter          = <<-EOT
        resource.label.project_id="${local.monitored_resource_project_id}"
        AND metric.type="composer.googleapis.com/environment/healthy" 
        AND resource.type="cloud_composer_environment"
      EOT
      duration        = format("%ss", var.composer_environment_health_policy.duration)
      comparison      = "COMPARISON_LT"
      aggregations {
        alignment_period   = format("%ss", var.composer_environment_health_policy.alignment_period)
        per_series_aligner = "ALIGN_COUNT_TRUE"
      }
    }
  }
  
  count = var.composer_environment_health_policy == null ? 0 : 1
}

# Composer Celery Task Queue Length
resource "google_monitoring_alert_policy" "composer_environment_task_queue_length" {
  project               = var.project_id
  display_name          = format("EDL Composer Environment Task Queue Length (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Cloud Composer celery task queue length is over threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDL Composer Celerey Task Queue Length Condition"
    condition_threshold {
      threshold_value = var.composer_task_queue_length_policy.threshold_value
      filter          = <<-EOT
        resource.label.project_id="${local.monitored_resource_project_id}"
        AND metric.type="composer.googleapis.com/environment/task_queue_length" 
        AND resource.type="cloud_composer_environment"
      EOT
      duration        = format("%ss", var.composer_task_queue_length_policy.duration)
      comparison      = "COMPARISON_GT"
      aggregations {
        alignment_period   = format("%ss", var.composer_task_queue_length_policy.alignment_period)
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  count = var.composer_task_queue_length_policy == null ? 0 : 1
}

# Composer Failed Workflow Run Count
resource "google_monitoring_alert_policy" "composer_workflow_failed_run_count_policy" {
  project               = var.project_id
  display_name          = format("EDL Composer Workflow Failed Run Count Policy (%s)", var.resource_label)
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Cloud Composer ${lookup(var.composer_workflow_failed_run_count_policy, "state_filter","failed")} workflow count is over threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDL Cloud Composer Failed Workflow Condition"
    condition_threshold {
      threshold_value = var.composer_workflow_failed_run_count_policy.threshold_value
      filter          = <<-EOT
        resource.label.project_id="${local.monitored_resource_project_id}"
        AND metric.type="composer.googleapis.com/workflow/run_count" 
        AND resource.type="cloud_composer_workflow" 
        AND metric.label.state="${lookup(var.composer_workflow_failed_run_count_policy, "state_filter","failed")}"
      EOT
      comparison      = "COMPARISON_GT"
      duration        = format("%ss", var.composer_workflow_failed_run_count_policy.duration)
      aggregations {
        group_by_fields    = ["resource.labels.workflow_name"]
        alignment_period   = format("%ss", var.composer_workflow_failed_run_count_policy.alignment_period)
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  count = var.composer_workflow_failed_run_count_policy == null ? 0 : 1
}

# Composer Failed Task Run Count
resource "google_monitoring_alert_policy" "composer_workflow_failed_task_run_count_policy" {
  project               = var.project_id
  display_name          = "EDL Composer Failed Task Run Count Policy (${var.resource_label})"
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = "Cloud Composer workflow ${lookup(var.composer_workflow_failed_task_run_count_policy, "state_filter","")} task count is over threshold in project ${var.project_id}."
  }
  combiner = "OR"
  conditions {
    display_name = "EDL Cloud Composer Failed Task Run Condition"
    condition_threshold {
      threshold_value = var.composer_workflow_failed_task_run_count_policy.threshold_value
      filter          = <<-EOT
        resource.label.project_id="${local.monitored_resource_project_id}"
        AND metric.type="composer.googleapis.com/workflow/task/run_count" 
        AND resource.type="cloud_composer_workflow" 
        AND metric.label.state="${lookup(var.composer_workflow_failed_task_run_count_policy, "state_filter","failed")}"
      EOT
      comparison      = "COMPARISON_GT"
      duration        = format("%ss", var.composer_workflow_failed_task_run_count_policy.duration)
      aggregations {
        group_by_fields    = ["metric.labels.task_name","resource.labels.workflow_name"]
        alignment_period   = format("%ss", var.composer_workflow_failed_task_run_count_policy.alignment_period)
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }

  count = var.composer_workflow_failed_task_run_count_policy == null ? 0 : 1
}

# Composer Task Run Duration
resource "google_monitoring_alert_policy" "composer_workflow_run_duration_policy" {
  project               = var.project_id
  display_name          = format("EDL Composer Workflow Run Duration Policy (%s, %s)", var.resource_label, lookup(var.composer_workflow_run_duration_policy[count.index], "friendly_name",""))
  notification_channels = var.stackdriver_notification_channels
  documentation {
    content = format("Cloud Composer workflow task duration for %s is over threshold in project %s.", lookup(var.composer_workflow_run_duration_policy[count.index], "friendly_name",""), var.project_id)
  }
  combiner = "OR"
  conditions {
    display_name = "EDL Cloud Composer Workflow Run Duration Condition (${lookup(var.composer_workflow_run_duration_policy[count.index], "friendly_name","")})"
    condition_threshold {
      threshold_value = var.composer_workflow_run_duration_policy[count.index].threshold_value
      filter          = <<-EOT
        resource.label.project_id="${local.monitored_resource_project_id}"
        AND metric.type="composer.googleapis.com/workflow/run_duration" 
        AND resource.type="cloud_composer_workflow" 
        AND resource.label.workflow_name="${var.resource_label}-${lookup(var.composer_workflow_run_duration_policy[count.index], "workflow_name","")}"
      EOT
      comparison      = "COMPARISON_GT"
      duration        = format("%ss", var.composer_workflow_run_duration_policy[count.index].duration)
      aggregations {
        alignment_period   = format("%ss", var.composer_workflow_run_duration_policy[count.index].alignment_period)
        per_series_aligner = "ALIGN_SUM"
      }
    }
  }
  count = var.composer_workflow_run_duration_policy == null ? 0 : length(var.composer_workflow_run_duration_policy)
}
