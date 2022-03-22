output "role_arn" {
  description = "The Role ARN for the Role that gets assumed by CPM"
  value       = module.n2ws.role_arn
}

output "bucket" {
  description = "The Bucket ARN for the bucket that gets used by CPM"
  value       = module.n2ws.bucket
}

output "externalid" {
  value       = module.n2ws.externalid
  description = "The ExternalID to be used for STS for the Assume Role policy for CPM"
}