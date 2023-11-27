variable "env" {
  description = "unique environment/stage name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "cluster_name" {
  description = "ECS cluster name"
  default     = ""
}

variable "alb_name" {
  description = "ALB load balancer name"
  default     = ""
}

variable "alb_hostnames" {
  description = "hostnames to point to the alb"
  type        = list(string)
  default     = []
}

variable "webhook_alb_name" {
  description = "Optional webhook proxy ALB load balancer name"
  default     = ""
}

variable "webhook_alb_hostnames" {
  description = "hostnames to point to the weebhook alb"
  type        = list(string)
  default     = []
}

variable "domain_public" {
  description = "public domain name information"
  default     = "svpn.chownow.com"
}

variable "service" {
  description = "name of service"
  default     = "hermosa"
}

variable "service_id" {
  description = "unique service suffix"
  default     = ""
}

variable "deployment_suffix" {
  description = "suffix to differentiate deployments"
  default     = ""
}

variable "dns_ttl" {
  description = "TTL on route53 records"
  default     = "300"
}

variable "vpc_name" {
  description = "vpc name"
  default     = "main-dev"
}

variable "enable_egress_allow_all" {
  description = "boolean to enable egress allow all"
  default     = 1
}

variable "domain" {
  description = "domain name to use for resource creation"
  default     = "chownow.com"
}

variable "listener_rule_priority" {
  description = "priority of default listener rule"
  default     = 5
}

variable "cloudflare_domain" {
  description = "cloudflare domain name to use for resource creation"
  default     = "cdn.cloudflare.net"
}

variable "cloudflare_hostnames" {
  description = "hostnames to point to cloudflare dns"
  type        = list(string)
  default     = []
}

variable "ssm_kms_key_arn" {
  description = "kms key used to encrypt communication with client and executeCommand logs"
  default     = ""
}

variable "ssm_logs_cloudwatch_log_group_arn" {
  description = "cloudwatch log group to write executeCommand logs"
  default     = ""
}

variable "ssm_logs_s3_bucket_arn" {
  description = "S3 bucket to write executeCommand logs"
  default     = ""
}

variable "sns_topic_arns" {
  description = "Allow override of list of SNS topic ARNs for Hermosa to be able to send messages to"
  default     = []
}

variable "sqs_queue_arns" {
  description = "Allow override of list of SQS queue ARNs for Hermosa to be able to send messages to"
  default     = []
}

locals {
  aws_account_id         = data.aws_caller_identity.current.account_id
  region                 = data.aws_region.current.name
  env                    = "${var.env}${var.env_inst}"
  target_group_name      = "${local.service_full}-${local.env}"
  service                = length(var.service_id) == 0 ? var.service : "${var.service}-${var.service_id}"
  service_role           = length(var.service_id) == 0 ? (length(var.deployment_suffix) == 0 ? "" : var.deployment_suffix) : length(var.deployment_suffix) == 0 ? var.service_id : "${var.service_id}-${var.deployment_suffix}"
  service_full           = length(local.service_role) == 0 ? var.service : "${var.service}-${local.service_role}"
  service_deployment     = length(var.deployment_suffix) == 0 ? var.service : "${var.service}-${var.deployment_suffix}"
  dns_zone               = local.env == "prod" ? var.domain : "${local.env}.svpn.${var.domain}"
  sns_topic_arns_default = ["arn:aws:sns:${local.region}:${local.aws_account_id}:cn-menu-*", "arn:aws:sns:${local.region}:${local.aws_account_id}:cn-order-*", "arn:aws:sns:${local.region}:${local.aws_account_id}:cn-restaurant-*"]
  sns_topic_arns         = length(var.sns_topic_arns) == 0 ? local.sns_topic_arns_default : var.sns_topic_arns
  sqs_queue_arns         = length(var.sqs_queue_arns) == 0 ? ["arn:aws:sqs:${local.region}:${local.aws_account_id}:hermosa-*"] : var.sqs_queue_arns
}
