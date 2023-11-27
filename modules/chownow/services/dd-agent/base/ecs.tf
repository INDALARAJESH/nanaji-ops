resource "aws_ecs_cluster" "dd_agent" {
  name = local.name
}
