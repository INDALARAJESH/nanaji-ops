resource "aws_iam_role" "ecs_events" {
  name = "${var.service}-periodic-backfill-role-${local.env}"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "${var.service}-periodic-backfill-role-${local.env}"
  role = aws_iam_role.ecs_events.id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.env}/restaurant-search-etl-*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "arn:aws:ecs:us-east-1:${data.aws_caller_identity.current.account_id}:task-definition/restaurant-search-etl-manage-*"
        }
    ]
}
DOC
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "${var.service}-periodic-backfill-${local.env}"
  arn       = data.aws_ecs_cluster.restaurant-search.arn
  rule      = aws_cloudwatch_event_rule.restaurant-search-backfill.name
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = data.aws_ecs_task_definition.restaurant-search-etl-manage.arn
    launch_type         = "FARGATE"

    network_configuration {
      subnets         = tolist(data.aws_subnets.env_vpc_subnets.ids)
      security_groups = [data.aws_security_group.ingress_security_group.id]
    }
  }

  input = <<DOC
{
  "containerOverrides": [
    {
      "name": "restaurant-search-etl-manage-${local.env}",
      "command": ["mammoth_etl", "backfill", "--time-frame", "${var.lookback_time_frame}"]
    }
  ]
}
DOC
}
