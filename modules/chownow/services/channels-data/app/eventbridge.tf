# Tripadvisor feed cron schedule
resource "aws_cloudwatch_event_rule" "tripadvisor_cron" {
  name                = "fn-${var.service}-tripadvisor-schedule-${local.env}"
  description         = "Schedule Tripadvisor ETL cron"
  schedule_expression = "cron(15 10 * * ? *)"
}

resource "aws_cloudwatch_event_target" "tripadvisor_event" {
  target_id = "fn-${var.service}-tripadvisor-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.tripadvisor_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "channel_name" : "tripadvisor" })
}

resource "aws_lambda_permission" "cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.tripadvisor_cron.arn
}

# Apple feed cron schedule
resource "aws_cloudwatch_event_rule" "apple_cron" {
  name                = "fn-${var.service}-apple-schedule-${local.env}"
  description         = "Schedule Apple ETL cron"
  schedule_expression = "cron(30 10 * * ? *)"
}

resource "aws_cloudwatch_event_target" "apple_event" {
  target_id = "fn-${var.service}-apple-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.apple_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "channel_name" : "apple" })
}

resource "aws_lambda_permission" "cloudwatch_apple" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.apple_cron.arn
}

# Opentable feed cron schedule
resource "aws_cloudwatch_event_rule" "opentable_cron" {
  name                = "fn-${var.service}-opentable-schedule-${local.env}"
  description         = "Schedule OpenTable ETL cron"
  schedule_expression = "cron(10 10 ? * 6 *)"
}

resource "aws_cloudwatch_event_target" "opentable_event" {
  target_id = "fn-${var.service}-opentable-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.opentable_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "channel_name" : "opentable" })
}

resource "aws_lambda_permission" "cloudwatch_opentable" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.opentable_cron.arn
}

# Nextdoor feed cron schedule
resource "aws_cloudwatch_event_rule" "nextdoor_cron" {
  name                = "fn-${var.service}-nextdoor-schedule-${local.env}"
  description         = "Schedule Nextdoor ETL cron"
  schedule_expression = "cron(30 11 ? * 4 *)"
}

resource "aws_cloudwatch_event_target" "nextdoor_event" {
  target_id = "fn-${var.service}-nextdoor-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.nextdoor_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "channel_name" : "nextdoor" })
}

resource "aws_lambda_permission" "cloudwatch_nextdoor" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.nextdoor_cron.arn
}

# Google Starter/PALs feed cron schedule
resource "aws_cloudwatch_event_rule" "google_starter_cron" {
  name                = "fn-${var.service}-google-starter-schedule-${local.env}"
  description         = "Schedule Google Starter/PALs Service Feed cron"
  schedule_expression = "cron(30 10 ? * * *)"
}

resource "aws_cloudwatch_event_target" "google_starter_event" {
  target_id = "fn-${var.service}-google-starter-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.google_starter_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "channel_name" : "google_starter" })
}

resource "aws_lambda_permission" "cloudwatch_google_starter" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.google_starter_cron.arn
}

# Menu ETL cron schedule
resource "aws_cloudwatch_event_rule" "menu_cron" {
  name                = "fn-${var.service}-menu-schedule-${local.env}"
  description         = "Schedule Menu ETL cron"
  schedule_expression = "cron(15 10 * * ? *)"
}

resource "aws_cloudwatch_event_target" "menu_event" {
  target_id = "fn-${var.service}-menu-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.menu_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "etl_name" : "menus" })
}

resource "aws_lambda_permission" "cloudwatch_menu" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.menu_cron.arn
}

# Restaurant DDB cron schedule
resource "aws_cloudwatch_event_rule" "restaurants_documentdb_cron" {
  name                = "fn-${var.service}-restaurant-documentdb-schedule-${local.env}"
  description         = "Schedule Restaurant ETL cron for inserting data into DocumentDB"
  schedule_expression = "cron(0 10 * * ? *)"
}

resource "aws_cloudwatch_event_target" "restaurants_documentdb_event" {
  target_id = "fn-${var.service}-restaurant-documentdb-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.restaurants_documentdb_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "etl_name" : "restaurants_documentdb" })
}

resource "aws_lambda_permission" "cloudwatch_restaurants_documentdb" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.restaurants_documentdb_cron.arn
}


# Health Check feed cron schedule
resource "aws_cloudwatch_event_rule" "healthcheck_cron" {
  name                = "fn-${var.service}-healthcheck-schedule-${local.env}"
  description         = "Schedule healthcheck ETL cron"
  schedule_expression = "cron(00 23 ? * * *)"
}

resource "aws_cloudwatch_event_target" "healthcheck_event" {
  target_id = "fn-${var.service}-healthcheck-event-target-${local.env}"
  rule      = aws_cloudwatch_event_rule.healthcheck_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "etl_name" : "healthcheck" })
}

resource "aws_lambda_permission" "cloudwatch_healthcheck" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.healthcheck_cron.arn
}

# Singleplatform feed cron schedule
resource "aws_cloudwatch_event_rule" "singleplatform_cron" {
  name                = "fn-${var.service}-singleplatform-schedule"
  description         = "Schedule SinglePlatform ETL cron"
  schedule_expression = "cron(11 8 * * ? *)"
}

resource "aws_cloudwatch_event_target" "singleplatform_event" {
  target_id = "fn-${var.service}-singleplatform-event-target"
  rule      = aws_cloudwatch_event_rule.singleplatform_cron.name
  arn       = module.function.lambda_function_arn
  input     = jsonencode({ "channel_name" : "singleplatform" })
}

resource "aws_lambda_permission" "cloudwatch_singleplatform" {
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_classification
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.singleplatform_cron.arn
}
