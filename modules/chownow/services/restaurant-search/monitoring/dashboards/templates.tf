data "template_file" "rss_etl_dashboard_template" {
  template = file("${path.module}/templates/rss_etl_dashboard.json.tpl")

  vars = {
    service_name            = var.etl_service_name
    local_env               = local.env
    restaurants_event_name  = "${var.sns_topic_base_name}-${local.env}"
    etl_state_machine_arn   = lower(data.aws_sfn_state_machine.restaurant_search_etl_state_machine.arn)
    etl_kickoff_lambda_name = data.aws_lambda_function.restaurant_search_etl_kickoff_lambda.function_name
    etl_fetch_lambda_arn    = data.aws_lambda_function.restaurant_search_etl_fetch_lambda.arn
    etl_fetch_lambda_name   = data.aws_lambda_function.restaurant_search_etl_fetch_lambda.function_name
    etl_delete_lambda_arn   = data.aws_lambda_function.restaurant_search_etl_delete_lambda.arn
    etl_delete_lambda_name  = data.aws_lambda_function.restaurant_search_etl_delete_lambda.function_name
    etl_insert_lambda_arn   = data.aws_lambda_function.restaurant_search_etl_insert_lambda.arn
    etl_insert_lambda_name  = data.aws_lambda_function.restaurant_search_etl_insert_lambda.function_name
  }
}


data "template_file" "rss_dm_dashboard_template" {
  template = file("${path.module}/templates/rss_dm_dashboard_template.json.tpl")

  vars = {
    service_name = var.dm_service_name
    local_env    = local.env
  }
}
