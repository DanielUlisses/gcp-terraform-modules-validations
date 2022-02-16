locals {
  user_labels = merge(var.user_labels, { resource_label = var.resource_label })
}
