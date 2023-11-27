module "tenable_on_function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.1.1"

  env                            = var.env
  lambda_name                    = "tenable-on"
  lambda_cron_boolean            = true
  lambda_description             = "Turns Tenable back on before run on tuesday"
  service                        = var.service
  cloudwatch_schedule_expression = var.on_cron
  lambda_layer_names             = local.lambda_layer_names
  domain                         = "chownow.com"
}

module "tenable_off_function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.1.1"

  env                            = var.env
  lambda_name                    = "tenable-off"
  lambda_cron_boolean            = true
  lambda_description             = "Turns Tenable off after run on Tuesday"
  service                        = var.service
  cloudwatch_schedule_expression = var.off_cron
  lambda_layer_names             = local.lambda_layer_names
  domain                         = "chownow.com"
}
