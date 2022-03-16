/*
All elements encrypted where possible
--------------------------------------
1. Role for N2WS 
2. S3 Bucket for N2WS backup storage
4. InternetGateway	
5. Subnet 
6. Security Group
7. Routes
8. RouteTable
9. S3 Gateway Endpoint
10. EBS API Endpoint
11. VPC w/ Flow Logs Enabled (capped retention)
*/

# VPCs
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Subnets
resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
}

# Security Groups & Rules
resource "aws_security_group" "main" {
  name = "n2ws-security-group"
  egress {
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
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.main.id
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "13.55.4.79/32"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block = "52.63.255.188/32"
    gateway_id = aws_internet_gateway.main.id
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
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowAll",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "s3:*"
        ],
        "Resource" : "*"
      }
    ]
  })
  auto_accept = true
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
resource "aws_s3_bucket" "main" { #tfsec:ignore:aws-s3-encryption-customer-key
  bucket = "n2ws-bucket"
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
  assume_role_policy = data.local_file.assume_role_policy.content
}

resource "aws_iam_role_policy" "main" {
  for_each = toset(local.permission_policies)
  name     = each.value
  role     = aws_iam_role.main.id
  policy   = data.local_file.policies[each.value].content
}

