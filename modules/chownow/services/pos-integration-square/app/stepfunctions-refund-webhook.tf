module "stepfunctions_refund_webhook" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/stepfunctions?ref=aws-stepfunctions-v2.0.0"

  name               = var.name
  env                = local.env
  service            = var.service
  step_function_name = format("%s-%s-refund-webhook-%s", var.name, var.service, local.env)
  step_function_definition = templatefile(format("%s/templates/refund-webhook-flow.asl.json", path.module), {
    PerformWebhookRefund  = module.lambda_pure_functions["perform_webhook_refund"].lambda_function_arn_alias_newest
    SendSlackNotification = module.lambda_pure_functions["send_slack_notification"].lambda_function_arn_alias_newest
  })

  tracing_enabled = var.stepfunctions_tracing_enabled
}
