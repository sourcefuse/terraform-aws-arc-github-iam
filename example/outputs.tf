output "role_arn" {
  description = "The ARN of the IAM role"
  value       = module.github_iam.role_arn
}

output "role_id" {
  description = "The ID of the IAM role"
  value       = module.github_iam.role_id
}

output "role_name" {
  description = "The name of the IAM role"
  value       = module.github_iam.role_name
}

output "policies" {
  value = module.github_iam.policies
}
