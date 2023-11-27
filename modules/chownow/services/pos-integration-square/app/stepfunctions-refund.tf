module "stepfunctions_refund" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/stepfunctions?ref=aws-stepfunctions-v2.0.0"

  name               = var.name
  env                = local.env
  service            = var.service
  step_function_name = format("%s-%s-refund-%s", var.name, var.service, local.env)
  step_function_definition = templatefile(format("%s/templates/refund-flow.asl.json", path.module), {
    PerformPartialRefund  = module.lambda_pure_functions["perform_partial_refund"].lambda_function_arn_alias_newest
    PerformFullRefund     = module.lambda_pure_functions["perform_full_refund"].lambda_function_arn_alias_newest
    SendSlackNotification = module.lambda_pure_functions["send_slack_notification"].lambda_function_arn_alias_newest
    UpdateOrderInDatabase = module.lambda_pure_functions["update_order_in_database"].lambda_function_arn_alias_newest
  })

  tracing_enabled = var.stepfunctions_tracing_enabled
}
