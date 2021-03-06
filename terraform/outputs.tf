output "role_arn" {
  description = "The Role ARN for the Role that gets assumed by CPM"
  value       = aws_iam_role.main.arn
}

output "bucket" {
  description = "The Bucket ARN for the bucket that gets used by CPM"
  value       = aws_s3_bucket.main.arn
}

output "externalid" {
  value       = random_string.externalid.result
  description = "The ExternalID to be used for STS for the Assume Role policy for CPM"
}


output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID for the N2WS VPC"
}

output "route_table_id" {
  value       = aws_route_table.main.id
  description = "The ID for the N2WS VPC route table"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "The CIDR range for the N2WS VPC"
}

output "s3_prefix_list" {
  value       = aws_vpc_endpoint.s3.prefix_list_id
  description = "The ID for the Prefix List for S3"
}