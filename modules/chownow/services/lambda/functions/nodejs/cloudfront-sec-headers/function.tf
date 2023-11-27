module "cloudfront_sec_headers_function" {
  source             = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-edge?ref=aws-lambda-edge-v2.0.1"
  env                = local.env
  lambda_name        = "cloudfront-sec-headers-${local.env}"
  lambda_description = "cloudfront-sec-headers for ${local.env}"
  service            = var.service
  lambda_runtime     = "nodejs16.x"
  lambda_handler     = "index.handler"
}
