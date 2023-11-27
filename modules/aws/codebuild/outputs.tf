output "iam_role_id" {
  value = aws_iam_role.codebuild-role.id
}

output "iam_role_arn" {
  value = aws_iam_role.codebuild-role.arn
}
