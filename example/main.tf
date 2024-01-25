################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = "example"
}

################################################################################
## iam
################################################################################
data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

module "github_iam" {
  source = "../"

  environment = var.environment
  namespace   = var.namespace

  ## role settings
  role_max_session_duration = var.role_max_session_duration
  github_subscriptions      = var.github_subscriptions

  ## policies
  policies = [
    {
      name        = "${var.namespace}-${var.environment}-s3-access"
      policy_json = data.aws_iam_policy_document.s3.json
    }
  ]
  aws_managed_iam_policy_names = [
    "ReadOnlyAccess"
  ]

  tags = module.tags.tags
}
