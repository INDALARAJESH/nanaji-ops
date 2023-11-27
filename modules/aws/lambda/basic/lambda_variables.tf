locals {
  lambda_classification = var.lambda_classification == "" ? format("%s_%s_%s_%s_%s", lower(var.lambda_name), lower(var.service), lower(var.env), lower(replace(data.aws_region.current.name, "-", "")), lower(replace(var.domain, ".", "_"))) : var.lambda_classification
  lambda_function_name  = var.lambda_ecr ? aws_lambda_function.lambda_ecr[0].function_name : aws_lambda_function.lambda_s3[0].function_name
  lambda_newest_version = var.lambda_ecr ? aws_lambda_function.lambda_ecr[0].version : aws_lambda_function.lambda_s3[0].version
  lambda_env_variables = {
    DEBUG = var.lev_debug
  }
}

variable "lambda_layer_names" {
  description = "list of lambda layer names"
  type        = list(string)
  default     = []
}

variable "lambda_name" {
  description = "unique name for lambda"
  default     = "CHANGETHELAMBDANAME"
}

variable "lambda_classification" {
  description = "unique full name for lambda"
  default     = ""
}

variable "lambda_s3" {
  description = "use S3 for lambda code"
  default     = true
}

variable "lambda_ecr" {
  description = "use ECR for lambda code"
  default     = false
}

variable "lambda_image_uri" {
  description = "lambda ECR image URI"
  default     = ""
}

variable "lambda_image_config_cmd" {
  description = "Parameters that you want to pass in with `entry_point`."
  default     = []
}

variable "lambda_image_entry_point" {
  description = "Image entry point"
  default     = []
}

variable "lambda_vpc_subnet_ids" {
  description = "List of subnet IDs associated with the Lambda function."
  default     = []
}

variable "lambda_vpc_sg_ids" {
  description = "List of security group IDs associated with the Lambda function."
  default     = []
}

variable "lambda_optional_policy_enabled" {
  description = "Whether to pass additional IAM policy to be attached to lambda's role"
  type        = bool
  default     = false
}

variable "lambda_optional_policy_arn" {
  description = "ARN of optional IAM policy to be attached to the role used by this Lambda"
  default     = ""
}

variable "lambda_tracing_enabled" {
  description = "Whether to to sample and trace a subset of incoming requests with AWS X-Ray"
  type        = bool
  default     = false
}

variable "lambda_env_variables" {
  description = "Lambda environment variables map"
  type        = map(string)
  default     = {}
}

variable "lambda_handler" {
  description = "Lambda handler"
  default     = "app.lambda_handler"
}

variable "lambda_memory_size" {
  description = "lambda memory size"
  default     = 128
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  default     = "python3.7"
}

variable "lambda_timeout" {
  description = "Lambda timeout"
  default     = "300"
}

variable "lambda_publish" {
  description = "Whether to publish creation/change as new Lambda Function Version AND Alias `:newest`"
  type        = bool
  default     = false
}

variable "lambda_provisioned_concurrency" {
  description = "Manages a Lambda Provisioned Concurrency Configuration"
  type        = number
  default     = 0
}

variable "lambda_autoscaling" {
  description = "Whether to enable Application AutoScaling - operates on Provisioned concurrency"
  type        = bool
  default     = false
}

variable "lambda_autoscaling_min_capacity" {
  description = "The min capacity of the scalable target"
  type        = number
  default     = 1
}

variable "lambda_autoscaling_max_capacity" {
  description = "The max capacity of the scalable target"
  type        = number
  default     = 5
}

variable "lambda_reserved_concurrent_executions" {
  description = "The max count of concurrent executions"
  type        = number
  default     = 5
}

variable "lambda_description" {
  description = "description of lambda's purpose"
  default     = ""
}

variable "lambda_tag_managed_by" {
  description = "tag to differentiate terraform managed lambda functions from non-terraform managed lambda functions"
  default     = "terraform"
}

variable "cloudwatch_logs_retention" {
  description = "CloudWatch logs retention in days"
  default     = 14
}

variable "cloudwatch_schedule_expression" {
  description = "schedule in cron notation to run lambda"
  default     = "cron(0 10 * * ? *)"
}

variable "lambda_cron_boolean" {
  description = "enables or disables cloudwatch cron creation"
  default     = true
}

####################################
### Lambda Environment Variables ###
####################################

variable "lev_slack_channel" {
  description = "which slack channel to send alerts"
  default     = "GHYR4NVN2" #ops-alerts:GFTJ59NF6 / ops-testing:GHYR4NVN2
}

variable "lev_slack_webhook" {
  description = "webhook to use to send slack alert"
  default     = ""
}

variable "lev_debug" {
  description = "debug flag for lambda"
  default     = "false"
}
