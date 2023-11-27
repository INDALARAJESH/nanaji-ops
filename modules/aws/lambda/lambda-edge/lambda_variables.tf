variable "lambda_layer_names" {
  description = "list of lambda layer names"
  default     = []
}

variable "lambda_name" {
  description = "unique name for lambda"
  default     = "CHANGETHELAMBDANAME"
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
  default     = "3" # lambda@edge requires small timeouts
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
