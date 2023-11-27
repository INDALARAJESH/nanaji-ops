data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_sns_topic" "restaurant_events" {
  name = "${var.sns_topic_base_name}-${local.env}"
}

data "aws_sfn_state_machine" "restaurant_search_etl_state_machine" {
  name = "${var.etl_service_name}-${local.env}"
}

data "aws_lambda_function" "restaurant_search_etl_kickoff_lambda" {
  function_name = "${var.etl_service_name}-kickoff-${local.env}"
}

data "aws_lambda_function" "restaurant_search_etl_fetch_lambda" {
  function_name = "${var.etl_service_name}-fetch-${local.env}"
}

data "aws_lambda_function" "restaurant_search_etl_delete_lambda" {
  function_name = "${var.etl_service_name}-delete-${local.env}"
}

data "aws_lambda_function" "restaurant_search_etl_insert_lambda" {
  function_name = "${var.etl_service_name}-insert-${local.env}"
}

data "aws_secretsmanager_secret" "by-name" {
  name = "${var.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "restaurant_search_dd_api_key" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}
