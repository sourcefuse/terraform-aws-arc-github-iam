locals {
  role_name = var.role_name_override != null ? var.role_name_override : "${var.namespace}-${var.environment}-github-oidc"
}
