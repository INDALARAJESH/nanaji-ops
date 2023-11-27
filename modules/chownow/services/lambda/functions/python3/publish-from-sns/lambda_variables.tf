# Slack Lambda Variables
variable "slack_lambda_layers" {
  description = "list of lambda layer names"
  default     = []
}

variable "slack_lambda_name" {
  description = "lambda name"
  default     = "sns_to_slack"
}

variable "slack_lambda_description" {
  description = "lambda description"
  default     = "Receives payloads from SNS and publishes them to Slack"
}

variable "slack_lambda_handler" {
  description = "lambda handler (note this can be changed to utilize the same ops-serverless module)"
  default     = "slack.lambda_handler"
}

variable "slack_lambda_env_slack_channel" {
  description = "SLACK_CHANNEL lambda env variable"
  default     = "GHYR4NVN2"
}

variable "slack_lambda_env_slack_icon_emoji" {
  description = "SLACK_ICON_EMOJI lambda env variable"
  default     = ":robot_face:"
}

variable "slack_lambda_env_slack_username" {
  description = "SLACK_USERNAME lambda env variable"
  default     = "sns-to-slack"
}
