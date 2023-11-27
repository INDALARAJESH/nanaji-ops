resource "aws_ecs_cluster" "app" {
  name = local.cluster_name

  setting {
    name  = var.ecs_cluster_setting_name
    value = var.ecs_cluster_setting_value
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.cluster_name }
  )
}


output "cluster_id" {
  value = aws_ecs_cluster.app.id
}

output "cluster_name" {
  value = aws_ecs_cluster.app.name
}
