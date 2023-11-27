output "repo_url" {
  value = aws_ecr_repository.app.repository_url
}

output "repo_arn" {
  value = aws_ecr_repository.app.arn
}

output "repo_name" {
  value = aws_ecr_repository.app.name
}
