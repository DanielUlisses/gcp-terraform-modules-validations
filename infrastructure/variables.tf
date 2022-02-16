variable "billing_account" {
  type        = string
  description = "The ID of the billing account to associate this project with"
}

variable "default_service_account" {
  type        = string
  description = "Project default service account setting: can be one of delete, deprivilege, disable, or keep."
  default     = "deprivilege"
}

variable "enable_audit_policy" {
  type        = bool
  default     = true
  description = "True or false value depending on whether the audit policy should be enabled. Recommended for production."
}

variable "enabled_api_extraservices" {
  description = "Extra API services to activate within the project"
  type        = list(string)
  default     = []
}

variable "enabled_api_services" {
  description = "The list of apis to activate within the project"
  type        = list(string)
}

variable "folder_id" {
  type        = string
  description = "The ID of a folder to host this project"
}

variable "org_id" {
  type        = string
  description = "GCP organization ID"
}

variable "project_name" {
  type        = string
  description = "The name for the project"
}

variable "project_id" {
  type        = string
  description = "The ID to give the project."
}

variable "labels" {
  type        = map(string)
  description = "Label dict to apply to this project"
  default     = {}
}
