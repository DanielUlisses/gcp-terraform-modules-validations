### Google Stackdriver Notification Channels

Creates Google Stackdriver Notification Channels

#### Dependencies

1. GCP project and credentials with monitoring.admin permissions
2. A Monitoring Workspace, configured.

#### Example Terraform Inputs

```
    # GCP project access
    project_id = "my-project-id"

    # Useful label, if monitoring from an amalgamated workspace
    resource_label = "my-proj"

    # Notification channels for emails
    notification_email_addresses = ["me@mydomain.com","you@yourdomain.com"]

    # Notification channels for slack
    notification_slack = { channels = ["#foobar"], auth_token = "one" }
```

### Getting channel types and labels from Google API
https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.notificationChannelDescriptors/list?apix_params=%7B%22name%22%3A%22projects%2Fproject-id%22%7D

```
gcloud beta monitoring channel-descriptors list --format="json(type,launchStage,labels)" --filter="launchStage!=DEPRECATED"
```

#### Handling secrets and passwords

Some notification channel types require handling sensitive data such as passwords. These secrets should not be stored unencrypted in the repository. To help, there is an [example](./examples/notification_channels_webhook/main.tf) of using the [google_kms_secret data source](https://www.terraform.io/docs/providers/google/d/google_kms_secret.html) to decrypt secrets and pass them into the module.

NOTE: Auth token webhooks rely on a token embedded into the webhook URL which will be exposed in notification channel information to anyone with access to the project. It is generally recommended to avoid this by using a Cloud Function triggered from a PubSub subscription and push events via the PubSub Notification Channel. The Cloud Function can then make the actual call to your webhook securely if needed. Using VPC connectors may also help with security.
