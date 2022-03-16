data "aws_region" "current" {}



data "local_file" "policies" {
  for_each = toset(local.permission_policies)
  filename = "policies/${each.value}.json"
}

data "local_file" "assume_role_policy" {
  filename = "policies/trust_relationship.json"
}