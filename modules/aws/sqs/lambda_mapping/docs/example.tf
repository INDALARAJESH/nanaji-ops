# Recommended: passing arn directly
module "sqs_lambda_mapping" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.2.0"
  env                  = "environment"
  env_inst             = "environment instance"
  service              = "service name"
  lambda_iam_role_id   = "lambda iam role id"
  mapping_batch_size   = "sqs batch size"
  sqs_queue_name       = "sqs queue name"
  lambda_function_arn = "lambda function arn"
  maximum_batching_window_in_seconds = "max wait seconds to assemble batch"
}
