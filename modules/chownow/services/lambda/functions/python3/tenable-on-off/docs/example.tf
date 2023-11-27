module "lambdas" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/python3/tenable-on-off?ref=aws-lambda-tenable-on-off-v2.0.0"

  env                = var.env
  on_cron  = "cron(0 3 ? * 4 *)"
  off_cron = "cron(0 8 ? * 4 *)"
}
