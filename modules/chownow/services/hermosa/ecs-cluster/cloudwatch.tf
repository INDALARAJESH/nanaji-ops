module "log_group" {
  source            = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudwatch/log-group?ref=aws-cloudwatch-log-group-v2.0.1"
  count             = var.enable_execute_command_logging ? 1 : 0
  env               = var.env
  env_inst          = var.env_inst
  path              = "/aws/ssm"
  name              = "${local.cluster_name}-ecs-execute-command"
  kms_key_id        = module.kms_key.alias_arn_main
  retention_in_days = var.retention_in_days
}
