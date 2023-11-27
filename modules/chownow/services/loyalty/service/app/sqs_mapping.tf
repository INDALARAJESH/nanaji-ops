module "lambda_sqs_mapping" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.0.1"

  depends_on           = [module.loyalty_sqs_lambda]
  env                  = var.env
  env_inst             = var.env_inst
  service              = var.service
  lambda_iam_role_id   = module.loyalty_sqs_lambda.lambda_iam_role_id
  mapping_batch_size   = var.sqs_lambda_mapping_batch_size
  sqs_queue_name       = var.sqs_queue_name
  lambda_function_name = module.loyalty_sqs_lambda.lambda_function_name
}
