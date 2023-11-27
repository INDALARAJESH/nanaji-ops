# Terraform Lambda Module - CloudWatch Logs


## General

* Description: CloudWatch Logs Subscription Filter to Lambda
* Created By: Tim Ho

#### Overview

This module will create a CloudWatch Logs subscription filter to pass logs to a lambda function.
This module does not create a lambda function or any associated resources.
It expects a lambda function name to be passed.

Refer to the lambda/lambda-basic module if you need to create a Lambda function.

#### Terraform

* Basic reference:

```
module "lambda-basic" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-basic?ref=aws-lambda-basic-v2.0.1"

  env                   = var.env
  lambda_description    = "sample description for new lambda"
  lambda_name           = "lambda-basic"                      # Try to use one word or multiple words with no spaces
  service               = "utils"                             # Example: hermosa
}

module "cloudwatchlogs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-cloudwatch-logs?ref=aws-lambda-cloudwatch-logs-v2.0.0"

  lambda_name               = "${module.lambda-basic.lambda_function_name}"
  cloudwatch_log_group_name = "${aws_cloudwatch_log_group.fargate.name}"
}
```

* Trigger a Subscription Filter Event on _Error_ messages:

```
module "lambda-basic" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-basic?ref=lambda-basic-v2.0.0"

  env                   = "${var.env}"
  lambda_description    = "sample description for new lambda"
  lambda_name           = "lambda-basic"                      # Try to use one word or multiple words with no spaces
  service               = "utils"                             # Example: hermosa
}

module "cloudwatchlogs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-cloudwatch-logs?ref=aws-lambda-cloudwatch-logs-v2.0.0"

  lambda_name                                = "${module.lambda-basic.lambda_function_name}"
  cloudwatch_log_group_name                  = "${aws_cloudwatch_log_group.fargate.name}"
  cloudwatch_log_subscription_filter_pattern = "ERROR"
}
```

### Notes
* The cloudwatch_log_subscription_filter_pattern "ERROR" matches log event messages that contain this term, such as the following:
    * [ERROR] A fatal exception has occurred
    * Exiting with ERRORCODE: -1



### References
* https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
