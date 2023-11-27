module "app-marketplace_origin_router" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/cloudfront/function?ref=cloudfront-function-v2.0.0"

  env            = var.env
  env_inst       = var.env_inst
  service        = var.service
  function_name  = "app-marketplace-origin-router"
  file_path      = file("${path.module}/files/index.js")

}
