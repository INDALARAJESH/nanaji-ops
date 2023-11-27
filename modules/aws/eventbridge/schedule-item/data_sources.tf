data "aws_iam_role" "eventbridge_scheduler_role" {
  name = local.scheduler_role_name
}
