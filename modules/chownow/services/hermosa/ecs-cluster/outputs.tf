output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "kms_key_arn" {
  description = "KMS key used to encrypt communication between ECS ExecuteCommand client and container"
  value       = module.kms_key.alias_arn_main
}
