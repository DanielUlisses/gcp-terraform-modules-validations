provider "google" {
  # Configuration options
}

module "tf_mod_gcp_project" {
  source                    = "git::git@github.com:pythian/tf_mod_gcp_project.git"
  billing_account           = var.billing_account
  default_service_account   = var.default_service_account
  enable_audit_policy       = var.enable_audit_policy
  enabled_api_extraservices = var.enabled_api_extraservices
  enabled_api_services      = var.enabled_api_services
  folder_id                 = var.folder_id
  labels                    = var.labels
  org_id                    = var.org_id
  project_id                = var.project_id
  project_name              = var.project_name
}
