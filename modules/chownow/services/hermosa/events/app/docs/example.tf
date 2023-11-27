module "hermosa_events_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/events/app?ref=hermosa-events-app-v2.2.7"
  env                  = var.env
  env_inst             = var.env_inst
  lambda_image_version = var.lambda_image_version
  vpc_name_prefix      = var.vpc_name_prefix
  fifo_queue_enabled   = false
}
