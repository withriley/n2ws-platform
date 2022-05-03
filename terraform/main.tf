/*
#              /$$$$$$                         
#             /$$__  $$                        
#   /$$$$$$$ |__/  \ $$ /$$  /$$  /$$  /$$$$$$$
#  | $$__  $$  /$$$$$$/| $$ | $$ | $$ /$$_____/
#  | $$  \ $$ /$$____/ | $$ | $$ | $$|  $$$$$$ 
#  | $$  | $$| $$      | $$ | $$ | $$ \____  $$
#  | $$  | $$| $$$$$$$$|  $$$$$/$$$$/ /$$$$$$$/
#  |__/  |__/|________/ \_____/\___/ |_______/ 
*/

# VPCs
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# VPC Flow Logs

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  log_format      = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "n2ws-flow-logs"
  retention_in_days = 14
}

resource "aws_iam_role" "flow_logs" {
  name = "n2ws-flow-logs"

  assume_role_policy = file("${path.module}/policies/aws_flow_logs_trust_relationship.json")
}

resource "aws_iam_role_policy" "flow_logs" { #tfsec:ignore:aws-iam-no-policy-wildcards
  name = "n2ws-flow-logs"
  role = aws_iam_role.flow_logs.id

  policy = file("${path.module}/policies/aws_flow_logs_policy.json")
}

# Subnets
resource "aws_subnet" "main" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[index(keys(var.subnets), each.key)]
  map_public_ip_on_launch = true
  tags = {
    name = each.key
  }
}

# Security Groups & Rules
resource "aws_security_group" "main" { #tfsec:ignore:aws-vpc-add-description-to-security-group
  name   = "n2ws-security-group"
  vpc_id = aws_vpc.main.id
  egress { #tfsec:ignore:aws-vpc-add-description-to-security-group-rule
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
    ipv6_cidr_blocks = ["::/0"]      #tfsec:ignore:aws-vpc-no-public-egress-sgr
    prefix_list_ids  = [aws_vpc_endpoint.s3.prefix_list_id]
  }
}

resource "aws_security_group_rule" "main" {
  for_each          = var.security_group_rules
  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.main.id
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.is_external ? toset([0]) : null
    content {
      cidr_block = var.cpm_instance
      gateway_id = var.is_external ? aws_internet_gateway.main.id : null
    }
  }
  # local route is created implicitly
}

resource "aws_route_table_association" "main" {
  for_each       = var.subnets
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main.id
}

# Endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = [aws_route_table.main.id]
  policy          = file("${path.module}/policies/vpc_endpoint_policy.json")
  auto_accept     = true
}

resource "aws_vpc_endpoint" "ebs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ebs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.main.id,
  ]

  subnet_ids          = [for subnet in aws_subnet.main : subnet.id]
  auto_accept         = true
  private_dns_enabled = true
}

# S3 Bucket
resource "random_string" "random" {
  length           = 8
  special          = true
  override_special = "-"
}

resource "random_string" "externalid" {
  length           = 8
  special          = false
  override_special = "-"
}

resource "aws_s3_bucket" "main" { #tfsec:ignore:aws-s3-encryption-customer-key #tfsec:ignore:aws-s3-enable-bucket-logging #tfsec:ignore:aws-s3-enable-versioning
  bucket = lower(format("n2ws-s3-backup-repository-%s", random_string.random.result))
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" { #tfsec:ignore:aws-s3-encryption-customer-key
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# IAM Role
resource "aws_iam_role" "main" {
  name               = "n2ws-role"
  assume_role_policy = templatefile("${path.module}/policies/trust_relationship.json", { externalid = random_string.externalid.result })
}

resource "aws_iam_role_policy" "main" {
  for_each = toset(local.permission_policies)
  name     = each.value
  role     = aws_iam_role.main.id
  policy   = data.local_file.policies[each.value].content
}

