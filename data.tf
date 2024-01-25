## aws settings / managed
data "aws_iam_policy" "managed" {
  for_each = toset(var.aws_managed_iam_policy_names)
  name     = each.value
}
