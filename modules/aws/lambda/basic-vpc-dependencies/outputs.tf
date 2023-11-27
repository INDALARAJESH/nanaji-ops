output "default_sg_id" {
  value = aws_security_group.lambda.id
}

output "private_subnet_ids" {
  value = data.aws_subnet_ids.private.ids
}
