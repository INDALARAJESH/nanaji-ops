module "stepfunctions_order" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/stepfunctions?ref=aws-stepfunctions-v2.0.0"

  name               = var.name
  env                = local.env
  service            = var.service
  step_function_name = format("%s-%s-order-%s", var.name, var.service, local.env)
  step_function_definition = templatefile(format("%s/templates/order-flow.asl.json", path.module), {
    ClearOrderMappings         = module.lambda_pure_functions["clear_order_mappings"].lambda_function_arn_alias_newest
    CreatePOSOrderObject       = module.lambda_pure_functions["create_pos_order_object"].lambda_function_arn_alias_newest
    CreatePOSPaymentObject     = module.lambda_pure_functions["create_pos_payment_object"].lambda_function_arn_alias_newest
    MapCNItemsToPOSVendorItems = module.lambda_pure_functions["map_cn_items_to_pos_vendor_items"].lambda_function_arn_alias_newest
    SaveOrderToTheDatabase     = module.lambda_pure_functions["save_order_to_the_database"].lambda_function_arn_alias_newest
    SendOrderToPOSVendor       = module.lambda_pure_functions["send_order_to_pos_vendor"].lambda_function_arn_alias_newest
    SendPaymentToPOSVendor     = module.lambda_pure_functions["send_payment_to_pos_vendor"].lambda_function_arn_alias_newest
    SendSlackNotification      = module.lambda_pure_functions["send_slack_notification"].lambda_function_arn_alias_newest
    UpdateOrderInDatabase      = module.lambda_pure_functions["update_order_in_database"].lambda_function_arn_alias_newest
    SuccessQueueUrl            = data.aws_sqs_queue.success_queue.url
    FailureQueueUrl            = data.aws_sqs_queue.failure_queue.url
  })
  iam_sqs_arns = [
    format("%s", data.aws_sqs_queue.success_queue.arn),
    format("%s", data.aws_sqs_queue.failure_queue.arn)
  ]
  tracing_enabled = var.stepfunctions_tracing_enabled
}
