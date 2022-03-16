output "role_arn" {
    description = "The Role ARN for the Role that gets assumed by CPM"
    value = aws_iam_role.main.arn
}