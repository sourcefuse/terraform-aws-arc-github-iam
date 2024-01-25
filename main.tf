################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      version = ">= 4.0"
      source  = "hashicorp/aws"
    }
  }
}

################################################################################
## openid connect
################################################################################
resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 1 : 0
  url   = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = var.github_thumbprint_list

  tags = var.tags
}

################################################################################
## role
################################################################################
resource "aws_iam_role" "this" {
  name                 = local.role_name
  max_session_duration = var.role_max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow"
        Principal = {
          Federated = var.create_github_oidc_provider ? one(aws_iam_openid_connect_provider.github[*].arn) : one(data.aws_iam_openid_connect_provider.github[*].arn)
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = var.github_subscriptions
          },
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  tags = merge(var.tags, tomap({
    Name = local.role_name
  }))
}

################################################################################
## policies
################################################################################
resource "aws_iam_policy" "this" {
  for_each = { for x in var.policies : x.name => x }

  name   = each.value.name
  path   = try(each.value.path, "/")
  policy = each.value.policy_json

  depends_on = [
    aws_iam_role.this
  ]
}

resource "aws_iam_role_policy_attachment" "created" {
  for_each = { for x in aws_iam_policy.this : x.name => x }

  policy_arn = each.value.arn
  role       = aws_iam_role.this.id
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = data.aws_iam_policy.managed

  policy_arn = each.value.arn
  role       = aws_iam_role.this.id
}
