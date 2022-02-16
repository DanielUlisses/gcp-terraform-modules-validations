
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "kms_key_id" {
  description = <<-DESCRIPTION
    GCP KMS Keyring name
    Never commit secrets to your repository
    Encrypt secrets and commit the ciphertext.
    Example of encryption:
    `gcloud --project=my-project kms encrypt --keyring=my-key-ring --location=us-central1 --key=my-crypto-key --ciphertext-file=- --plaintext-file=- <<< "my-password" | base64 | tr -d '[:space:]'; echo`

    Key IDs have the format:
    projects/my-project/locations/us-central1/keyRings/my-key-ring/cryptoKeys/my-crypto-key
    Generally you would use a KMS terraform resource to pass IDs to the secrets data module.
  DESCRIPTION
  type        = string
}

variable "password_ciphertext" {
  description = "Base64 encoded ciphertext encrypted by KMS"
  type        = string
}

data "google_kms_secret" "webhook_password" {
  crypto_key = var.kms_key_id
  ciphertext = "${var.password_ciphertext}"
}


module "notification_channels" {
  source = "../../modules/notification_channels"

  project_id = var.project_id

  resource_label = "my-label"

  notification_webhook_tokenauth = ["https://www.myserver.com/stackdriver-hook?auth_token=${data.google_kms_secret.webhook_password.plaintext}"]
  notification_webhook_basicauth = [{
    url      = "https://www.myserver.com/stackdriver-hook-basic"
    username = "my-username"
    password = data.google_kms_secret.webhook_password.plaintext
  }]
  user_labels = { foo = "bar" }
}

output "notification_channel_ids" {
  description = "List of channels output by custom module"
  value       = module.notification_channels.notification_channel_ids
}
