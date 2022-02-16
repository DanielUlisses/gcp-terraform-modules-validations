### Google Stackdriver Alert Policies

Creates Google Stackdriver Alert Policies

#### Dependencies

1. GCP project and service account credentials with monitoring.admin permissions.

#### Setup
Use the `notification_channels` submodule to create channels.
Policies are enabled by setting the object variable for that policy.

#### Example Terraform Variables

    ### Project variables ###
    project_id = "ok-project-wkspace"

    # Optional, alternate monitored project
    monitored_resource_project_id = "ok-project"

    resource_label = "ok-label"

    # Notification channels
    notification_email_addresses      = ["user@example.com", "other@example.com"]

    # Policy configuration
    bigquery_slots_policy = {
        threshold_value  = 32
        duration         = 60
        alignment_period = 60
      }

#### Handling secrets and passwords

Some notification channel types require handling sensitive data such as passwords. These secrets should not be stored unencrypted in the repository. To help, there is an [example](./examples/notification_channels_webhook/main.tf) of using the [google_kms_secret data source](https://www.terraform.io/docs/providers/google/d/google_kms_secret.html) to decrypt secrets and pass them into the module.
