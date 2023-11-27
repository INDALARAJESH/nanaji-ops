resource "aws_ecs_cluster" "sysdig_ecs_orchestrator" {
  name = local.ecs_cluster_name

  tags = local.common_tags
}
