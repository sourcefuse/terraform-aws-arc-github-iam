output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_id" {
  description = "The ID of the IAM role"
  value       = aws_iam_role.this.id
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}

output "policies" {
  value = {
    for k, v in aws_iam_policy.this : k => {
      name = v.name
      path = v.path
      id   = v.id
      arn  = v.arn
    }
  }
}
