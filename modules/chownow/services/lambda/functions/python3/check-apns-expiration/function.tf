module "function" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=lambda-basic-v2.0.0"

  env                = local.env
  lambda_description = "Send email when APNS certificate is about to expire"
  lambda_name        = "check"
  service            = var.service

  lambda_env_variables = {
    PLATFORM_APPLICATION_ARNS = join(",", var.platform_application_arns)
    RECIPIENT                 = "ops+apnscertcheck@chownow.com"
    ENV                       = local.env
  }

  lambda_layer_names = local.lambda_layer_names
}
