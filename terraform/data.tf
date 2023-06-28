data "aws_region" "current" {}

data "local_file" "policies" {
  for_each = toset(local.permission_policies)
  filename = "${path.module}/policies/${each.value}.json"
}

data "local_file" "assume_role_policy" {
  filename = "${path.module}/policies/trust_relationship.json"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "local_file" "cpm_instance_profile" {
  filename = "${path.module}/policies/aws_cpm_instance_profile.json"
}