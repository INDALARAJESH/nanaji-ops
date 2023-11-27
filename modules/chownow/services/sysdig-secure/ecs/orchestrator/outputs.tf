### ECS Cluster Outputs ###
output "cluster_id" {
  value = aws_ecs_cluster.sysdig_ecs_orchestrator.id
}

output "cluster_name" {
  value = aws_ecs_cluster.sysdig_ecs_orchestrator.name
}

### Sysdig Orchestrator Agent Outputs ###
output "orchestrator_host" {
  description = "The DNS name of the orchestrator's load balancer"
  value       = aws_lb.ecs_orchestrator_agent.dns_name
}

output "orchestrator_port" {
  description = "The configured port on the orchestrator"
  value       = var.orchestrator_port
}
