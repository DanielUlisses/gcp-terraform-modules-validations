### Project variables ###
variable "project_id" {
  description = "GCP Project ID for the monitoring workspace and default project ID for monitored resources. Specified GCP Project MUST exist."
  type        = string
  # Required
}

variable "monitored_resource_project_id" {
  description = <<-DESCRIPTION
    GCP Project ID for the resource being monitored.
    If not specified, the value defaults to the workspace host project ID (I.E. The `project_id` variable).
    If specified, the given GCP project MUST exist.

    Used for consolidated monitoring, where the monitored resource is in a different project than the workspace project.
  DESCRIPTION
  type        = string
  default     = ""
}

variable "resource_label" {
  description = "Resource name prefix, usually the environment name"
  type        = string
  #Required
}

#### Notification channel list ####

##### Using existing notification channels #####
variable "stackdriver_notification_channels" {
  description = <<-DESCRIPTION
  A set of existing notification channel IDs where alerts are sent.
  This will usually be used to pass IDs for notification channels created by other terraform modules.
  Channel IDs have the format of "projects/my-project-id-string/notificationChannels/8705391793086376336"
  DESCRIPTION
  type        = set(string)
  default     = []
}


### Policy Variables ###

#### Bigquery policy variables ####
variable "bigquery_slots_policy" {
  description = "Bigquery slots available alert configuration values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number,
  })
  default = null
}

#### Composer variables ####
### Metric policy override-able variables ###
variable "composer_db_health_policy" {
  description = "composer_db_health policy values"
  type = object({
    threshold_value  = number,
    alignment_period = number,
    duration         = number,
  })
  default = null
}

variable "composer_environment_health_policy" {
  description = "composer_environment_health policy values"
  type        = object({
    threshold_value  = number,
    alignment_period = number,
    duration         = number,
  })
  default = null
}

variable "composer_task_queue_length_policy" {
  description = "task_queue_length policy values"
  type        = object({
    threshold_value  = number,
    alignment_period = number,
    duration         = number,
  })
  default = null
}

variable "composer_workflow_failed_run_count_policy" {
  description = "Composer workflow_failed_run_count policy values"
  type        = object({
    threshold_value  = number,
    alignment_period = number,
    duration         = number,
    state_filter     = string,
  })
  default = null
}

variable "composer_workflow_failed_task_run_count_policy" {
  description = "composer workflow_task_run_count policy values"
  type        = object({
    threshold_value  = number,
    alignment_period = number,
    duration         = number,
    state_filter     = string,
  })
  default = null
}

#more specific, as values require tuning per workflow
variable "composer_workflow_run_duration_policy" {
  description = "composer_workflow_run_duration_policy policy values"
  type        = list(object({
    threshold_value  = number,
    alignment_period = number,
    duration         = number,
    friendly_name    = string,
    workflow_name    = string,
  }))
  default = null
}

#### Dataflow variables ####
variable "dataflow_job_failed_policy" {
  description = "job/is_failed policy values"
  type = object({
    threshold_value  = number # E.G. 1
    duration         = number # E.G. 60
    alignment_period = number # E.G. 60
  })
  default = null
}

variable "dataflow_elapsed_time_policy" {
  # only use this for non-streaming jobs
  description = "job/elapsed_time policy values"
  type = list(object({
    job_name         = string # <<valid job name filter>>
    friendly_name    = string # <<any identifier>>
    threshold_value  = number # E.G. 600
    duration         = number # E.G. 60
    alignment_period = number # E.G. 60
  }))
  default = []
}

variable "dataflow_job_system_lag_policy" {
  description = "job/system_lag policy values"
  type = object({
    threshold_value  = number # E.G. 3600
    duration         = number # E.G. "60"
    alignment_period = number # E.G. "60"
  })
  default = null
}

### Dataproc variables ###
variable "dataproc_job_failed_policy" {
  description = "cluster/job/failed_count policy values"
  type        = object({
    threshold_value  = number
    duration         = number
    alignment_period = number
  })
  default = null
}

variable "dataproc_job_duration_policy" {
  description = "cluster/job/completion_time policy values"
  type        = object({
    threshold_value  = number
    duration         = number
    alignment_period = number
  })
  default = null
}

#### GCE Instance Metric policy variables ####
variable "cpu_usage_policy" {
  description = "cpu usage alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "disk_read_io_policy" {
  description = "disk read usage alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "disk_write_io_policy" {
  description = "disk write usage alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "gce_instance_uptime_policy" {
  description = "instance uptime alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "gce_instance_disk_usage_policy" {
  description = "instance disk usage alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "gce_instance_memory_usage_policy" {
  description = "instance disk usage alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

#### GKE Cluster/Node variables ####
variable "gke_cluster_names" {
  description = "The names of the GKE clusters to raise alerts for"
  type        = set(string)
  default     = null
}

##### GKE Cluster variables #####
variable "gke_connect_dialer_errors_policy" {
  description = "connect dialer errors alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

##### GKE Cluster Node variables #####
variable "gke_allocatable_cpu_cores_policy" {
  description = "allocatable cpu cores alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "gke_allocatable_memory_policy" {
  description = "allocatable memory alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "gke_allocatable_storage_policy" {
  description = "allocatable storage alerting policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}


#### Pubsub policy variables ####
variable "pubsub_subscription_unacked_messages_policy" {
  description = "subscription/num_undelivered_messages policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

variable "pubsub_topic_unacked_messages_policy" {
  description = "topic/num_unacked_messages_by_region policy values"
  type        = object({ duration = number, threshold_value = number, alignment_period = number })
  default     = null
}

#### Service runtime policy variables ####
variable "service_runtime_api_request_latency_policy" {
  description = "Service runtime api_request_latency exceeded values"
  type        = list(object({ service_name = string, threshold_value = number, alignment_period = number, duration = number }))
  default     = []
}

variable "service_runtime_quota_policy" {
  description = "Service runtime quota exceeded values"
  type        = object({ duration = number, threshold_value = number })
  default     = null
}

#### Log Based Metrics varialbes ####


variable "logging_metric_config" {
  description = "Map of Log metric configuration blocks."
  type = map(object({
    metric_name        = string,
    log_filter         = string,
    metric_description = string,
    metric_kind        = string,
    resource_type      = string,
    value_type         = string,
  }))
  default = {}
}

variable "logging_metric_alert_configs" {
  description = <<-DESCRIPTION
  Log metric alerts configuration block list. The combination of `metric_name/alert_description` must be unique.
  The `metric_name` field must reference a key in the `logging_metric_config` map variable.
  DESCRIPTION
  type = list(object({
    logging_metric_config_key = string, # Must match a key from `logging_metric_config` map
    alert_description         = string,
    aligner                   = string,
    alignment_period          = number,
    comparison                = string,
    condition_name            = string,
    duration                  = number,
    group_by                  = string,
    threshold_value           = number,
  }))
  default = []
}

#### SQL Instance Metrics policy variables ####

variable "sql_instance_uptime_policy" {
  description = "Instance uptime alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # Should be in ms/s
  })
  default = null
}

variable "sql_cpu_utilization_policy" {
  description = "cpu usage alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # Should be in %
  })
  default = null
}
variable "sql_instance_memory_quota_policy" {
  description = "instance total memory quota alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # Maximum RAM size in bytes
  })
  default = null
}
variable "sql_instance_memory_usage_policy" {
  description = "instance memory usage alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # RAM usage in bytes
  })
  default = null
}

variable "sql_instance_memory_utilization_policy" {
  description = "instance memory utilization alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # Should be in %
  })
  default = null
}

variable "sql_instance_disk_quota_policy" {
  description = "instance total disk quota alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # Maximum data disk size in bytes
  })
  default = null
}

variable "sql_instance_disk_utilization_policy" {
  description = "instance disk utilization alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number, # Should be in %
  })
  default = null
}


variable "sql_instance_disk_read_io_policy" {
  description = "disk read usage alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number,
  })
  default = null
}

variable "sql_instance_disk_write_io_policy" {
  description = "disk write usage alerting policy values"
  type = object({
    alignment_period = number,
    duration         = number,
    threshold_value  = number,
  })
  default = null
}