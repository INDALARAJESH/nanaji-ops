output "repo_url" {
  value = aws_ecrpublic_repository.app.repository_uri
}

output "repo_arn" {
  value = aws_ecrpublic_repository.app.arn
}

output "repo_name" {
  value = aws_ecrpublic_repository.app.repository_name
}
