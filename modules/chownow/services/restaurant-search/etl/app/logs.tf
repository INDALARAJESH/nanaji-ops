# Datadog Log Forwarding - ETL
module "datadog_log_forward_restaurant_search_etl" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_etl_kickoff" {
  name            = "datadog-log-${module.restaurant_search_etl_kickoff_lambda.lambda_function_name}"
  log_group_name  = "/aws/lambda/${var.etl_kickoff_name}-${lower(local.env)}"
  destination_arn = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${module.datadog_log_forward_restaurant_search_etl.name}"
  filter_pattern  = ""

  depends_on = [module.datadog_log_forward_restaurant_search_etl]
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_etl_fetch" {
  name            = "datadog-log-${module.restaurant_search_etl_fetch_lambda.lambda_function_name}"
  log_group_name  = "/aws/lambda/${var.etl_fetch_name}-${lower(local.env)}"
  destination_arn = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${module.datadog_log_forward_restaurant_search_etl.name}"
  filter_pattern  = ""

  depends_on = [module.datadog_log_forward_restaurant_search_etl]
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_etl_insert" {
  name            = "datadog-log-${module.restaurant_search_etl_insert_lambda.lambda_function_name}"
  log_group_name  = "/aws/lambda/${var.etl_insert_name}-${lower(local.env)}"
  destination_arn = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${module.datadog_log_forward_restaurant_search_etl.name}"
  filter_pattern  = ""

  depends_on = [module.datadog_log_forward_restaurant_search_etl]
}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward_etl_delete" {
  name            = "datadog-log-${module.restaurant_search_etl_delete_lambda.lambda_function_name}"
  log_group_name  = "/aws/lambda/${var.etl_delete_name}-${lower(local.env)}"
  destination_arn = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function:${module.datadog_log_forward_restaurant_search_etl.name}"
  filter_pattern  = ""

  depends_on = [module.datadog_log_forward_restaurant_search_etl]
}
