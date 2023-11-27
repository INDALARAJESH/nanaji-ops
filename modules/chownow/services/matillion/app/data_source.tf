data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_lb_target_group" "public_alb_http" {
  name = "${var.service}-pub-${local.env}-${var.tg_port}"
}

data "aws_ami" "matillion" {
  owners      = ["807659967283"]
  most_recent = true

  filter {
    name   = "name"
    values = ["matillion-etl-for-snowflake-ami-*"]
  }
}
#
# sns to slack 
#
data "aws_lambda_function" "sns_to_slack" {
  function_name = var.sns_to_slack_lambda_function_name
}
data "aws_sns_topic" "sns_to_slack" {
  name = var.sns_to_slack_topic_name
}

