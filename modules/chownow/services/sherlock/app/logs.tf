module "cloudwatch2loggly" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//aws/lambda/lambda-cloudwatch-logs?ref=lambda-cloudwatch-logs-v1.0.0"

  cloudwatch_log_group_name = "${module.sherlock_ecs.cloudwatch_log_group_name}"
  lambda_name               = "${local.logs_lambda_name}"
  lambda_iam_role           = "${local.logs_lambda_iam_role}"
}
