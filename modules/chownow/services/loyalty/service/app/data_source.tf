data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Loyalty Environment Variables and Secrets

# API Keys

# Private Subnet ID for CodeBuild

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private_base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}

# ACM Certificate

data "aws_acm_certificate" "star_chownow" {
  domain      = "${var.wildcard_domain_prefix}${local.env}.svpn.${var.domain}"
  statuses    = ["ISSUED"]
  most_recent = true
}

# ALB

data "aws_security_group" "ingress_vpn_allow" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}

# Firelens
data "aws_ssm_parameter" "fluentbit" {
  name = "${var.firelens_container_ssm_parameter_name}/${var.firelens_container_image_version}"
}

data "aws_sqs_queue" "existing_queue" {
  name = local.sqs_queue_name
}

data "aws_dynamodb_table" "existing_table" {
  name = local.table_name
}
# ----------------- from pipeline ---------------------

data "aws_iam_policy_document" "allow_ddb_doc" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = [data.aws_dynamodb_table.existing_table.arn]
  }
}

data "aws_iam_policy_document" "queue_policy_doc" {
  statement {
    actions   = ["sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl", "sqs:ReceiveMessage", "sqs:SendMessage"]
    resources = [data.aws_sqs_queue.existing_queue.arn]
  }
}

data "aws_iam_policy_document" "allow_cloudwatch_policy_doc" {
  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "sns_policy_doc" {
  statement {
    actions   = ["sns:Publish"]
    resources = [module.memberships-sns-topic.arn]
  }
}
