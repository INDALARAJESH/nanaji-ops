module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.2"

  env                = local.env
  lambda_description = "Ships CloudWatch logs to DataDog"
  lambda_name        = "logs"
  service            = var.service

  lambda_env_variables = {
    SSM_PATH_DATADOG_TOKEN = local.dd_api_key_secret_path
    ENV                    = local.env
  }

  lambda_layer_names = local.lambda_layer_names
}
