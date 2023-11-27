resource "aws_db_parameter_group" "db" {
  name   = local.name
  family = "postgres11"

  parameter {
    apply_method = "pending-reboot"
    name         = "rds.force_ssl"
    value        = 1
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.name,
    )
  )
}
