resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    dynamic "execute_command_configuration" {
      for_each = var.enable_execute_command_logging ? [] : [1]
      content {
        kms_key_id = module.kms_key.alias_arn_main
      }
    }
    dynamic "execute_command_configuration" {
      for_each = var.enable_execute_command_logging ? [1] : []
      content {
        kms_key_id = module.kms_key.alias_arn_main
        logging    = "OVERRIDE"

        log_configuration {
          cloud_watch_encryption_enabled = true
          cloud_watch_log_group_name     = module.log_group[0].name
          s3_bucket_name                 = module.s3_bucket[0].bucket_name
          s3_bucket_encryption_enabled   = true
        }
      }
    }
  }

  tags = map(
    "Name", local.cluster_name,
    "Service", var.service
  )
}
