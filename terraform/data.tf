data "aws_region" "current" {}

data "local_file" "policies" {
  count = 2
  filename = "./policies/aws_policy_permissions_Enterprise_BYOL_${count.index + 1}.json"
}