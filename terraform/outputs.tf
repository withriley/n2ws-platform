output "role_arn" {
    description = "The Role ARN for the Role that gets assumed by CPM"
    value = aws_iam_role.main.arn
}

output "bucket" {
    description = "The Bucket ARN for the bucket that gets used by CPM"
    value = aws_s3_bucket.main.arn
}