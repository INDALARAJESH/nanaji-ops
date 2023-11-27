## Events ETL IAM

data "aws_iam_policy_document" "ecs_task_s3" {
  statement {
    sid     = "AllowS3PutSnowflake"
    effect  = "Allow"
    actions = ["s3:Put*"]

    resources = [
      "arn:aws:s3:::${var.manage_container_snowflake_bucket_name}/*",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_s3" {
  name   = "${local.full_service}-ecs-s3-${local.env}"
  role   = module.ecs_base_web.app_iam_role_id
  policy = data.aws_iam_policy_document.ecs_task_s3.json
}

## CloudWatch Events

resource "aws_cloudwatch_event_rule" "ecs_task_manage_etl_cron" {
  name        = "${local.full_service}-ecs-manage-etl-cron"
  description = "Runs ${local.full_service} ETL manage task"

  is_enabled          = var.event_cron_is_enabled
  schedule_expression = var.event_cron_schedule
}

resource "aws_cloudwatch_event_target" "ecs_task_manage_etl_cron" {
  target_id = "${local.full_service}-ecs-manage-etl-cron"
  arn       = module.ecs_base_web.aws_ecs_cluster
  rule      = aws_cloudwatch_event_rule.ecs_task_manage_etl_cron.name
  role_arn  = data.aws_iam_role.ecs_task_manage_etl_cron.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = 1
    task_definition_arn = "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:task-definition/${module.ecs_task_manage.ecs_task_definition_id}"

    network_configuration {
      subnets = data.aws_subnet_ids.private.ids
    }
  }

  input_transformer {
    input_template = data.template_file.manage_event_target.rendered
  }
}
