module "dms_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/dms/base?ref=cn-dms-base-v2.1.5"

  env = var.env

  # Enabling PrivateLink for MDS
  enable_privatelink               = 1
  service_provider_aws_account_ids = [tostring(var.aws_account_id)]
}
