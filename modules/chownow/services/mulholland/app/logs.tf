module "mul_2fa_api_gw_log_group" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudwatch/log-group?ref=aws-cloudwatch-log-group-v2.0.0"
  env    = var.env
  path   = "/aws/api-gateway"
  name   = var.mul_2fa_api_gateway_name
}
