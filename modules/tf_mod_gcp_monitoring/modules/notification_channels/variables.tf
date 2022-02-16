### Project variables ###
variable "project_id" {
  description = "GCP Project ID"
  type        = string
  # Required
}

variable "resource_label" {
  description = "Resource name prefix, usually the environment name"
  type        = string
  #Required
}

variable "user_labels" {
  description = "Labels added to any created notification channels"
  type        = map(string)
  default     = {}
}

#### Notification channel lists ####

##### Using existing notification channels #####

variable "notification_existing_channels_by_name" {
  description = "A set (distinct list) of display names for existing notification channels"
  type        = set(string)
  default     = []
}

##### Create new notification channels #####

variable "notification_email_addresses" {
  description = "A set (distinct list) of unique email addresses to send alerts to"
  type        = set(string)
  default     = []
}

# Google expects slack notification channels to be created manually
# and acquiring an auth_token for slack is not well defined
# https://cloud.google.com/monitoring/support/notification-options#slack
variable "notification_slack" {
  description = <<-DESCRIPTION
    A set of slack channels from a single slack workspace

    Do NOT commit plaintext passwords directly to the repository.
    Using the KMS modules is recommended to store secrets in an encrypted format.
  DESCRIPTION
  type = object({
    channels   = set(string)
    auth_token = string # Do not commit plaintext passwords directly to your repository
  })
  default = null
}


# service-[PROJECT_NUMBER]@gcp-sa-monitoring-notification.iam.gserviceaccount.com must be authorized to publish to the given topics
variable "notification_pubsub_topics" {
  description = "A set (distinct list) of pubsub topics"
  type        = set(string)
  default     = []
}

variable "notification_webhook_basicauth" {
  description = <<-DESCRIPTION
  A set (distinct list) of webhook URLs, usernames, and plaintext passwords

  Do NOT commit plaintext passwords directly to the repository.
  Using the KMS modules is recommended to store secrets in an encrypted format.
  DESCRIPTION
  type = set(object({
    url      = string
    username = string
    password = string # Do not commit plaintext passwords directly to your repository
  }))
  default = []
}

variable "notification_webhook_tokenauth" {
  description = <<-DESCRIPTION
    A set (distinct list) of webhook URLs. It is expected that an auth token be included as a query parameter.

    Do NOT commit the plaintext auth token part of the URL to the repository.
    The auth token is sensitive information and should be encrypted.
    Using the KMS modules is recommended to store secrets in an encrypted format.
  DESCRIPTION
  type        = set(string)
  default     = []
}
