################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
  default     = "poc"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
  default     = "arc"
}

################################################################################
## github
################################################################################
variable "github_subscriptions" {
  type        = list(string)
  description = "GitHub repo subscriptions for AWS account access"
  default     = []
}

################################################################################
## iam
################################################################################
variable "role_max_session_duration" {
  type        = number
  description = "Session duration of the assumed role"
  default     = 3600
}
