## aws settings / managed
data "aws_iam_policy" "managed" {
  for_each = toset(var.additional_iam_policy_names)
  name     = each.value
}

## oidc
data "aws_iam_openid_connect_provider" "github" {
  count = var.create_github_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}
