output "iam_user_arn" {
  value = aws_iam_user.service.arn
}

output "iam_user_name" {
  value = aws_iam_user.service.name
}
