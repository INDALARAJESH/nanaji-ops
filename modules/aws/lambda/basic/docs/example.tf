/*
  Basic reference:
*/
module "randomjob1" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.4"

  env                   = var.env
  lambda_description    = "sample description for new lambda"
  lambda_classification = "randomjob1_${var.env}"
  service               = "joetest"
}

/*
  A more custom reference with customized threshold and lambda run frequency variables:
*/
module "randomjob2" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.4"

  env                 = var.env
  lambda_cron_boolean = false
  lambda_description  = "sample description for new lambda"
  lambda_name         = "randomjob1"
  lev_slack_channel   = "ABCDEFG"
  service             = var.service
}
