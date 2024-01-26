################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "tags" {
  description = "Tags to assign created resources"
  type        = map(string)
  default     = {}
}

################################################################################
## github
################################################################################
variable "create_github_oidc_provider" {
  type        = bool
  description = "Create the OIDC GitHub Provider. If false, this module assume it exists and does a data lookup."
  default     = true
}

variable "github_thumbprint_list" {
  type        = list(string)
  description = "GitHub thumbprint list"
  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd" # Refer to: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
  ]
}

variable "github_subscriptions" {
  type        = list(string)
  description = "GitHub repo subscriptions for AWS account access"
}

################################################################################
## iam
################################################################################
variable "role_name_override" {
  type        = string
  description = "Base name to assign resources. If null, it will default to `{var.namespace}-{var.environment}-github-oidc`"
  default     = null
}

variable "role_max_session_duration" {
  type        = number
  description = "Session duration of the assumed role, in seconds"
  default     = 3600
}

variable "policies" {
  description = "The IAM policies to create and attach to the IAM role for managing AWS resources"
  type = list(object({
    name        = string
    path        = optional(string, "/")
    policy_json = any
  }))
  default = []
}

variable "additional_iam_policy_names" {
  type        = list(string)
  description = "List of IAM Policy names to lookup and assign to the created IAM Role"
  default     = []
}
