variable "project_id" {
  type = string
}

variable "project_number" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "machine_type" {
  type = string
}

variable "min_count" {
  type = number
}

variable "max_count" {
  type = number
}

variable "disk_size_gb" {
  type = number
}

variable "initial_node_count" {
  type = number
}

variable "tags" {
  type = map(list(string))
}
